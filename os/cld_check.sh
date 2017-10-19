#!/bin/bash
#########################################################################
# File Name: os_log.sh
# Author: PeiYuan
# Mail: peiyuan.wc@alibaba-inc.com
# Description: collect privte cloud os log for system
#              faulty and kernel crash.
# Created Time: Sun May 21 10:35:12 2017
#########################################################################
#set -o pipefail

############# Global Variable ############
LOGDATE=$(date "+%Y-%m-%d-%H-%M-%S")
WORKDIR="cloud_log.$LOGDATE"
SLOGDIR="/var/log"
LOCK_FILE=""
DATA_FILE="/tmp/data_file.$LOGDATE"
LOGDIR=""
SCOPE_TYPE=""

need_free_space=5
list_items=0
target_cmd=""
target_type=""
target_scope=2
checking=0
syslog_tgz=""
no_compress=0
success=0
fail=1
warn=2
skip=3
########### End Global Variable ##########

################################## Utility Function ################################

info()
{
    local info="$1"
    local cmd="echo -e $info"
    echo ""
    eval $cmd
    echo ""
}
msg()
{
    local strings="$1"
    printf "%-80s" "$strings"
}
error()
{
    local info="$1"
    info ""
    info "[Error]: $info"
    exit 1
}
if_command_exist()
{
    local cmd=$1
    command -v $cmd > /dev/null
    return $?
}
if_command_not_exist()
{
    local cmd=$1
    if_command_exist $cmd
    [ $? -eq $success ] && return $fail
    return $success
}
cmd_log()
{
    local cmd=$1
    local log=$2
    local action="$3"
    local res=$fail

    msg "Calling: ${cmd:0:60}"

    if_command_not_exist $cmd && result $skip && return
    [ "$action" = "path" ] && cmd="$cmd $log"

    echo "Command: $cmd" >> $log
    eval $cmd >> $log 2>&1
    res=$?
    result $res
}
analysis_log()
{
    local cmd=$1
    local check_fun=$2
    local fix_fun=$3
    local log=$4

    [ "$check_fun" = "" ] && return
    msg "Checking: ${cmd:0:60}"
    [ ! -e "$log" ] && result $skip && return
    eval $check_fun "$log" > "${log}_check" 2>&1
    result $?

    [ "$fix_fun" = "" ] && return
    msg "Fixing: ${cmd:0:60}"
    eval $fix_fun "$log" >> "${log}_fix" 2>&1
    result $?
}
run_cmd()
{
    local cmd="$1"
    local silent=$2

    [ "$silent" != "" ] && cmd+=" > /dev/null 2>&1"
    eval $cmd
}
cleanup()
{
    rm -f "$LOCK_FILE"
    rm -f "$DATA_FILE"
    [ "$LOGDIR" != "/" ] && [ $no_compress -eq 0 ] && run_cmd "rm --preserve-root -rf $LOGDIR" "silent"
}
check_single_instance()
{
    if [ -f $LOCK_FILE ];then
        info ""
        error "Another $(basename $0) is running, please waiting it finish and then retry !"
    fi
    echo "$$" > "$LOCK_FILE"
}
check_root()
{
    [ $(whoami) != "root" ] && error "Please run this script as root !"
}
check_file()
{
    local file=$1
    [ ! -e $file ] && info "$file does not exsit ..." && return $fail
    return $success
}
is_el5()
{
    local el5=$(cat /etc/redhat-release | grep -c '5\.')
    [ $el5 -eq 1 ] && return 0
    return 1
}
is_el6()
{
    local el6=$(cat /etc/redhat-release | grep -c '6\.')
    [ $el6 -eq 1 ] && return 0
    return 1
}
is_el7()
{
    local el7=$(cat /etc/redhat-release | grep -c '7\.')
    [ $el7 -eq 1 ] && return 0
    return 1
}
show_result()
{
    local report="Check Report Info: "
    local msg="$1"
    local value=$2
    case $value in
        0)
            return
            ;;
        2)
            report+="(WARNING)"
            ;;
        3)
            return
            ;;
        *)
            report+="(FAIL)"
            ;;
    esac
    report+=" $msg"
    echo $report
}
check_and_uncompress_tarball()
{
    local tarball=$(basename $syslog_tgz)
    local tarball_ok=$(echo "$syslog_tgz" | grep -c "tar.gz")

    [ $tarball_ok -eq 0 ] && error "File: $syslog_tgz is not a tarball file !"
    LOGDIR=${SLOGDIR}/${tarball%.tar.gz}
    run_cmd "rm -rf $LOGDIR" "silent"
    info "Start uncompress $syslog_tgz to $SLOGDIR ..."
    tar -zxf $syslog_tgz -C $SLOGDIR
    [ $? -ne 0 ] && error "Uncompress $syslog_tgz failed, exit ..."
    [ ! -d "$LOGDIR" ] && error "Dir $LOGDIR is not a directory !"
}
prepare_to_run()
{
    export LANG=C
    LOCK_FILE="${SLOGDIR}/${WORKDIR}.pid"
    LOGDIR="${SLOGDIR}/${WORKDIR}"

    run_cmd "rm -rf $LOGDIR" "silent"
    [ "$syslog_tgz" != "" ] && check_and_uncompress_tarball
    run_cmd "mkdir -p $LOGDIR" "slient"

    case $SCOPE_TYPE in
        'all')
            target_scope=3
            need_free_space=10
            ;;
        'small')
            target_scope=1;;
        *)
            target_scope=2;;
    esac
}
free_space_check()
{
    local dir="$LOGDIR"
    local target=$need_free_space

    local threshold=$(($target * 1024 * 1024))
    local current=$(df -P $(dirname $dir) | grep -v Filesystem | awk '{print int($(NF-2))}')

    [ $current -lt $threshold ] && error "$node: The available space on $dir is less than ${target}G, Please cleanup for more."
}
# 0 success
# 1 failed
# 2 warning
# 3 skip
result()
{
    local res=$1
    case $res in
        0)
            printf "\t\E[1;31;32mPASS\E[0m\n"
            ;;
        2)
            printf "\t\E[1;31;33mWARNING\E[0m\n"
            ;;
        3)
            printf "\t\E[1;31;33mSKIP\E[0m\n"
            ;;
        *)
            printf "\t\E[1;31;31mFAIL\E[0m\n"
            ;;
    esac
}
get_netcard_info()
{
    local log_temp=$(dirname $1)
    local nic_devices=$(ls /sys/class/net/)

    echo "nic_list="$nic_devices
    for device in ${nic_devices}
    do
        if [ "${device}" != 'lo' ] && [ -d /sys/class/net/${device} ]
        then
            local ndir="${log_temp}/${device}"
            mkdir -p $ndir
            /bin/cp -r /sys/class/net/${device}/* "${ndir}"
            ethtool -i ${device} >> "${ndir}/ethtool_i"
            ethtool ${device}    >> "${ndir}/ethtool"
            ethtool -S ${device} >> "${ndir}/ethtool_S"
            ethtool -g ${device} >> "${ndir}/ethtool_g"
            ethtool -k ${device} >> "${ndir}/ethtool_k"
        fi
    done
}
get_bonding_info()
{
    local log_temp=$(dirname $1)

    [ ! -e /proc/net/bonding ] && return $skip

    local bonds=$(cd /proc/net/bonding/;ls)
    echo "$bonds"
    for bond in $bonds
    do
        mkdir -p $log_temp/${bond}
        cat /proc/net/bonding/$bond >> "${log_temp}/${bond}/cat_${bond}"
    done
}
get_raid_type()
{
    local raidtype=""
    local lsmod=$(lsmod)
    local lspci=$(lspci 2>/dev/null)

    # mptSAS/mpt2SAS
    echo $lsmod | egrep -qw "mptsas|mptbase|mpt2sas"
    if [ $? -eq 0 ] && [ -z $raidtype ]; then
        if echo $lsmod | egrep -qw "mpt2sas" && echo $lspci | grep -q "SAS2"; then
            raidtype="mpt2sas"
        elif echo $lsmod | egrep -qw "mptsas" && echo $lspci | grep -q "SAS1" || echo $lsmod | egrep -qw "megaraid_sas,mptsas"; then
            raidtype="mptsas"
        fi
    fi
    # MegaRAID SCSI
    echo $lsmod | egrep -qw "megaraid_mbox|megaraid2"
    if [ $? -eq 0 ] && [ -z $raidtype ]; then
        raidtype="megaraidscsi"
    fi
    # MegaRAID SAS
    echo $lsmod | egrep -qw "megaraid_sas"
    if [ $? -eq 0 ] && [ -z $raidtype ]; then
        raidtype="megaraidsas"
    fi
    # aacRAID
    echo $lsmod | egrep -qw "aacraid"
    if [ $? -eq 0 ] && [ -z $raidtype ]; then
        raidtype="aacraid"
    fi
    # HP RAID
    echo "$lspci" | grep -iE "RAID|SCSI|SAS|SATA" | grep -q "Hewlett-Packard" && echo $lsmod | grep -qE "cciss|hpsa"
    if [ $? -eq 0 ] && [ -z $raidtype ]; then
        raidtype="hpraid"
    fi
    # MegaRAID SAS
    echo "$lspci" | grep -qE "MegaRAID|Dell PowerEdge Expandable RAID controller|MegaRAID SAS"
    if [ $? -eq 0 ] && [ -z $raidtype ]; then
        raidtype="megaraidsas"
    fi
    if [ -z $raidtype ]; then
        raidtype="unknown"
        # echo "this host raid is unknown raid"
    fi
    echo "$raidtype"
}

get_hpraid_log()
{
    local log_temp=$1
    local cmd="/usr/sbin/hpacucli"

    [ -x "/usr/local/bin/hpacucli" ] && cmd="/usr/local/bin/hpacucli"

    mkdir -p $log_temp
    #$cmd version
    $cmd ctrl all show status > ${log_temp}/hpacucli_status.log 2>&1
    $cmd ctrl all show config > ${log_temp}/hpacucli_config.log 2>&1
    $cmd ctrl slot=0 pd all show status > ${log_temp}/hpacucli_pd_status.log 2>&1
    $cmd ctrl slot=0 ld all show > ${log_temp}/hpacucli_ld_status.log 2>&1
    local ld_nums=$(grep -c "logicaldrive" ${log_temp}/hpacucli_ld_status.log)
    local index_ld=1
    while [ $index_ld -le $ld_nums ]
    do
        $cmd ctrl slot=0 ld $index_ld show >> ${log_temp}/hpacucli_allld_status.log 2>&1
        index_ld=$((index_ld+1))
    done
    local pd_id=$(grep "physicaldrive" ${log_temp}/hpacucli_pd_status.log|awk '{print $2}')
    local pd_nums=$(grep -c "physicaldrive" ${log_temp}/hpacucli_pd_status.log)
    local index_pd=1
    while [ $index_pd -le $pd_nums ]
    do
        if [ $index_pd -eq $pd_nums ];then
            pds=$(echo "${pd_id}"|sed -n "${index_pd}p")
        else
            pds=$(echo "${pd_id}\n"|sed -n "${index_pd}p")
        fi
        $cmd ctrl slot=0 pd $pds show >> ${log_temp}/hpacucli_allpd_status.log 2>&1
        index_pd=$((index_pd+1))
    done
}
get_megaraidscsi_log()
{
    local log_temp=$1
    local cmd="/usr/local/sbin/megarc.bin"

    mkdir -p $log_temp
    $cmd -AllAdpInfo > ${log_temp}/alladpinfo.log 2>&1
    $cmd -dispcfg -a0 > ${log_temp}/dispcfg.log 2>&1
}
get_mptsas_log()
{
    local log_temp=$1
    local cmd="/usr/local/sbin/cfggen"

    mkdir -p $log_temp
    $cmd LIST > ${log_temp}/cfggen_list.log 2>&1
}
get_aacraid_log()
{
    local log_temp=$1
    local cmd="/usr/local/sbin/arcconf"
    [ -a "/usr/StorMan/arcconf" ] && cmd="/usr/StorMan/arcconf"

    mkdir -p $log_temp
    $cmd GETVERSION > ${log_temp}/arcconf_getversion.log 2>&1
}
get_mpt2sas_log()
{
    local log_temp=$1
    local cmd="/usr/local/sbin/sas2ircu"

    mkdir -p $log_temp
    $cmd LIST > ${log_temp}/sas2ircu_list.log 2>&1
    local controller_nums=$(awk '$1~/^[0-9]/{print $0}' ${log_temp}/sas2ircu_list.log|wc -l)
    local controller_id=0
    while [ $controller_id -lt $controller_nums ]
    do
        $cmd $controller_id status >> ${log_temp}/sas2ircu_controllers_status.log 2>&1
        $cmd $controller_id display >> ${log_temp}/sas2ircu_controllers_display.log 2>&1
        controller_id=$((controller_id+1))
    done
}
get_megaraidsas_log()
{
    local log_temp="$1"
    local cmd="/opt/MegaRAID/MegaCli/MegaCli64"

    mkdir -p $log_temp
    $cmd -fwtermlog -dsply -aall -NoLog > ${log_temp}/fwtermlog.log 2>&1
    $cmd -adpeventlog -getevents -f ${log_temp}/adpeventlog.log -aall -NoLog >/dev/null 2>&1
    $cmd -phyerrorcounters -aall -NoLog > ${log_temp}/phyerrorcounters.log 2>&1
    $cmd -encinfo -aall -NoLog > ${log_temp}/encinfo.log 2>&1
    $cmd -cfgdsply -aall -NoLog > ${log_temp}/cfgdsply.log 2>&1
    $cmd -adpbbucmd -aall -NoLog > ${log_temp}/adpbbucmd.log
    $cmd -LdPdInfo -aall -NoLog | egrep 'RAID Level|Number Of Drives|Enclosure Device|Slot Number|Virtual Drive|Firmware state|Media Error Count|Predictive Failure Count|Other Error Count' > ${log_temp}/ldpdinfo.log 2>&1
    $cmd -PDList -aall -NoLog | egrep 'Enclosure Device ID|Slot Number|Firmware state|Inquiry Data' > ${log_temp}/pdlist.log 2>&1
    $cmd -AdpAllInfo -aall -NoLog > ${log_temp}/adpallinfo.log 2>&1
}
get_raid_log()
{
    local log_temp=$(dirname $1)
    local raid_type=$(get_raid_type)
    local logdir="${log_temp}/${raid_type}"

    info "raid_controller:$raid_type"
    case $raid_type in
        "megaraidsas")   get_megaraidsas_log "$logdir";;
        "hpraid")        get_hpraid_log "$logdir";;
        "megaraidscsi")  get_megaraidscsi_log "$logdir";;
        "mptsas")        get_mptsas_log "$logdir";;
        "aacraid")       get_aacraid_log "$logdir";;
        "mpt2sas")       get_mpt2sas_log "$logdir";;
        *) echo "Can't find any raid type ...";;
    esac
}

get_disk_info()
{
    local log_temp=$(dirname $1)
    local disks=$(cd /dev/ && ls sd* | grep -v [1-9])

    echo "Disks: $disks"
    for disk in $disks
    do
        local dir="${log_temp}/$disk"
        mkdir -p $dir
        smartctl -a /dev/$disk > "${dir}/smartctl_a"
        parted /dev/$disk print > "${dir}/parted"
        cat /sys/block/$disk/queue/scheduler > "${dir}/cat_scheduler"
    done
}
get_aliflash_info()
{
    local log_temp=$(dirname $1)
    local disks=$(cd /dev/ && ls df* | grep -v [1-9])

    [ "$disks" = "" ] && return $skip

    echo "Aliflash: $disks"
    for disk in $disks
    do
        local dir="${log_temp}/$disk"
        mkdir -p $dir
        aliflash-status -a /dev/$disk > "${dir}/aliflash-status_a"
    done
}
install_rpm()
{
    local rpm=$1
    yum install -y $rpm
}
get_disk_io_detail()
{
    local dir=$1
    local disk=$2

    mkdir -p $dir
    cd $dir
    blktrace -d /dev/$disk -w 5 > blktrace.log
    blkparse -i $disk -d $disk.blktrace.bin > blkparse.log
    btt -i $disk.blktrace.bin > btt.log
    cd -
}
get_disks_io_detail()
{
    local log_temp=$(dirname $1)
    local debugfs=$(cat /proc/mounts | grep -ic debugfs)
    local disks=$(cd /dev/ && ls sd*)

    if_command_not_exist "blktrace" && install_rpm "blktrace"
    if_command_not_exist "blktrace" && info "Command blktrace install failed ..." && return

    [ $debugfs -eq 0 ] && mount -t debugfs debugfs /sys/kernel/debug
    for disk in $disks
    do
        info "Start geting disk $disk detail ..."
        get_disk_io_detail "${log_temp}/$disk" $disk
    done
    [ $debugfs -eq 0 ] && umount /sys/kernel/debug
}
get_docker_info()
{
    local log_temp=$(dirname $1)
    local dockers=$(docker ps -q)

    #docker ps --no-trunc
    docker ps
    [ $? -ne $success ] && info "None docker running !" && return
    for docker in $dockers
    do
        local ddir="${log_temp}/${docker}"
        mkdir -p $ddir
        docker inspect $docker >> "${ddir}/inspect"
        docker exec $docker free -m >> "${ddir}/free_m"
        docker exec $docker df -h >> "${ddir}/df_h"
    done
}

compress_log()
{
    [ $no_compress -eq 1 ] && return
    info "Start compressing log dir ..."
    rm -f ${LOGDIR}.tar.gz
    cd $SLOGDIR
    tar -zcf ${LOGDIR}.tar.gz $(basename $LOGDIR)
    [ $? -ne 0 ] && error "Compress log failed, exit ..."
    md5sum ${LOGDIR}.tar.gz > ${LOGDIR}.tar.gz.md5sum
    echo "Tarball md5 file: ${LOGDIR}.tar.gz.md5sum"
    echo "Tarball file: ${LOGDIR}.tar.gz"
    echo ""
    echo -e "\E[1;31;31mPlease copy the tarball file to level 2 supporter ! \E[0m\n"
}
show_system_info()
{
    echo ""
    if if_command_exist "hwconfig"
    then
        hwconfig
    else
        echo "System:    $(cat /etc/redhat-release)"
        echo "Hostname:  $(hostname -f)"
        echo "Kernel:    $(uname -r)"
        echo "Arch:      $(uname -i)"
        echo "Product:   $(dmidecode -s system-product-name | grep -v '#')"
    fi
}
copy_files()
{
    local src=$1
    local dst=$2

    [ ! -e $src ] && return
    if [ "$3" = "ignore" ];then
        /bin/cp -r "$src" "$dst" 2>/dev/null
    else
        /bin/cp -r "$src" "$dst"
    fi
}

get_top10_process_info()
{
    local top10=$1
    local log_dir=$2

    for pid in $top10
    do
        local dir="${log_dir}/$pid"
        local files=$(ls "/proc/${pid}")
        local exclude="task pagemap"

        [ -d "$dir" ] && continue
        mkdir -p "$dir"
        pmap -x $pid > $dir/pmap_x 2>&1
        pmap -d $pid > $dir/pmap_d 2>&1

        for file in $files
        do
            echo "$exclude" | grep -qw "$file" && continue
            copy_files "/proc/${pid}/$file" "${log_dir}/${pid}/" "ignore"
        done
    done
}

get_top10_mem_process_info()
{
    local file=$1
    local dir=$(dirname $file)

    ps -e -wwo 'pid,comm,psr,pmem,rsz,vsz,stime,user,stat,uid,args' --sort rsz

    local top10_mem=$(tail -10 $file | awk '{print $1}')

    get_top10_process_info "$top10_mem" "$dir"
}
get_top10_cpu_process_info()
{
    local file=$1
    local dir=$(dirname $file)

    ps -e -wwo 'pid,comm,psr,pcpu,rsz,vsz,stime,user,stat,uid,args' --sort pcpu

    local top10_cpu=$(tail -10 $file | awk '{print $1}')
    get_top10_process_info "$top10_cpu" "$dir"
}
get_dns_info()
{
    local file=$1
    local domain=$(cat /etc/resolv.conf | grep -v '#' | grep -i search | awk '{print $2}')
    cat /etc/resolv.conf
    for dns in $(cat /etc/resolv.conf | grep -v '#' | grep nameserver | awk '{print $2}')
    do
        local full_domain="$(hostname -f)"
        [ "$domain" != "" ] && full_domain="$(hostname -f).$domain"
        dig $full_domain @${dns}
    done
}
copy_system_files()
{
    local dir=$(dirname $1)
    local kern="/var/log/kern"
    local messages="/var/log/messages"
    copy_files "$kern" "$dir/"
    copy_files "$messages" "$dir/"
    [ -e $kern ] && echo "$kern" && tail -200 $kern
    [ -e $messages ] && echo "$messages" && tail -200 $messages
    return $success
}
copy_other_files()
{
    local dir=$(dirname $1)
    copy_files "/boot/grub/" "$dir/"
    copy_files "/etc/sysctl.conf" "$dir/"
    copy_files "/etc/security/limits.conf" "$dir/"
    copy_files "/var/log/secure" "$dir/"
    /bin/cp /var/log/messages-* "$dir/"
    /bin/cp /var/log/secure-* "$dir/"
    #copy_files "/var/log/sa/" "$dir"
    return $success
}
check_user_behavior()
{
    local log_file=$1
    local res=$success
    local status=$(egrep -c "^reboot|^shutdown|^ctrlatdel|^poweroff|^rm" $log_file)
    local key=''
    [ $status -ne 0 ] && key="History cmd include reboot shutdown ctrlatdel or poweroff " && res=$warn
    show_result "$key" "$res"
    return $res
}
check_disk_size()
{
    local log_file=$1
    local res=$success
    local key=''

    for item in $(cat $log_file | awk '{print $5}' | sed '1,2d' | sed 's/%//g')
    do
        [ $item -ge 80 ] && key="File system disk usage > 80%"  && res=$warn
        [ $item -ge 95 ] && key="File system disk usage > 95%"  && res=$fail
    done

    show_result "$key" "$res"
    return $res
}
check_free_memory()
{
    local log_file=$1
    local res=$success
    local key=''
    local total=$(cat $log_file | grep Mem | awk '{print $2}')
    local used=$(cat $log_file | grep buffers/cache | awk '{print $3}')
    is_el7 && local used=$(($(cat $log_file | grep Mem | awk '{print $2}')-$(cat $log_file | grep Mem | awk '{print $NF}')))
    local used_percentage=$((${used}*100/${total}))
    [[ ${used_percentage} -ge 80 ]] && key="Memory usage > 80%"  && res=$warn
    [[ ${used_percentage} -ge 90 ]] && key="Memory usage > 90%"  && res=$fail
    show_result "$key" "$res"
    return $res
}
check_process_status()
{
    local log_file=$1
    local res=$success
    local key=''
    local num_D=$(awk '{print $9}' $log_file | grep -c 'D')
    local num_Z=$(awk '{print $9}' $log_file | grep -c 'Z')
    local total=$(($num_D + $num_Z))
    echo "total=${total}"
    [ $total -ge 100 ] && key="Process statistics: PS_STAT D and PS_STAT Z total > 100" && res=$warn
    [ $total -ge 200 ] && key="Process statistics: PS_STAT D and PS_STAT Z total > 200" && res=$fail
    show_result "$key" "$res"
    return $res
}
check_system_load()
{
    local log_file=$1
    local res=$success
    local key=""
    local average_data=$(grep -w 'average' $log_file | sed "s/,//g")
    local one_minutes_average=$(printf "%.0f" $(echo ${average_data} | awk '{print $10}'))
    local five_minutes_average=$(printf "%.0f" $(echo ${average_data} | awk '{print $11}'))
    local fifteen_minutes_average=$(printf "%.0f" $(echo ${average_data} | awk '{print $12}'))
    [ $one_minutes_average -ge 100 ] && key="The average load of the system in the last 1 minutes > 100" && res=$warn
    [ $five_minutes_average -ge 80 ] && key="The average load of the system in the last 5 minutes > 80" &&res=$warn
    [ $fifteen_minutes_average -ge 50 ] && key="The average load of the system in the last 15 minutes > 50" && res=$warn
    [ $one_minutes_average -ge 150 ] && key="The average load of the system in the last 1 minutes > 150" && res=$fail
    [ $five_minutes_average -ge 120 ] && key="The average load of the system in the last 5 minutes > 120" && res=$fail
    [ $fifteen_minutes_average -ge 100 ] && key="The average load of the system in the last 15 minutes > 100" && res=$fail
    show_result "$key" "$res"
    return $res
}
check_readonly()
{
    local log_file=$1
    local res=$success
    local key=""
    local status=$(cat $log_file | grep -wc "ro")
    [[ $status -ne 0  ]] && key="Exist mount file system is read-only" && res=$fail
    show_result "$key" "$res"
    return $res

}
get_fstab_info()
{
    echo "########## mount info #############"
    mount
    echo "######### end mount info ###########"
    echo "########## fstab info ############"
    cat /etc/fstab
    echo "######### end fstab info #########"
}
check_fstab()
{
    local log_file=$1
    local res=$success
    local key=""
    local mount=$(sed -n "/## mount info ##/,/## end mount info ##/"p $log_file | grep -v '#')
    local fstab=$(sed -n "/## fstab info ##/,/## end fstab info ##/"p $log_file | grep -v '#' | awk '{print $2}')
    while read item
    do
        local ok=0
        [ "$item" = "" ] && continue
        while read line
        do
            ok=$(echo $line | grep -cw "$item")
            [ $ok -ne 0 ] && break
        done <<< "$mount"
        [ $ok -eq 0 ] && res=$fail && show_result "fstab: $item is error." "$res"
    done <<< "$fstab"
    return $res
}
check_kdump_status()
{
    local log_file=$1
    local res=$fail
    local key="Service kdump status is not operational"
    local status=$(cat $log_file | grep -wc "not")
    [[ $status -eq 0  ]] && key='' && res=$success
    show_result "$key" "$res"
    return $res
}
check_kdump_config()
{
    local log_file=$1
    local res=$success
    local key="Kdump config err: "
    local device=$(df -lh /var | tail -1 | awk '{print $1}')
    local filesystem=$(mount|grep -w $device|awk '{print $(NF-1)}')
    local first_line="$device $filesystem"
    local second_line="path /var/crash"
    local third_line="core_collector makedumpfile -c --message-level 1 -d 31"
    local fourly_line="extra_modules mpt2sas mpt3sas megaraid_sas hpsa ahci"
    local five_line="default reboot"
    [[ $(awk 'NR==2 {print $1}' $log_file) != "$filesystem"  ]] && key+="$filesystem " && res=$fail
    [[ $(awk 'NR==2 {print $2}' $log_file) != "$device"  ]] && key+="$device" && res=$fail
    [[ $(awk 'NR==3 {print}' $log_file) != "$second_line"  ]] && key+="$second_line " && res=$fail
    [[ $(awk 'NR==4 {print}' $log_file) != "$third_line"  ]] && key+="$third_line " && res=$fail
    [[ $(awk 'NR==5 {print}' $log_file) != "$fourly_line"  ]] && key+="$fourly_line " && res=$fail
    [[ $(awk 'NR==6 {print}' $log_file) != "$five_line"  ]] && key+="$five_line " && res=$fail
    show_result "$key" "$res"
    return $res
}
check_conman_config()
{
    local log_file=$1
    local res=$success
    local key=""
    is_el5 && local status=$(grep -wc 'crashkernel=[0-9]\+M@[0-9]\+M' ${log_file})
    is_el6 && local status=$(grep -wc 'crashkernel=256M' ${log_file})
    is_el7 && local status=$(grep -wc 'crashkernel=auto' ${log_file})
    [[ ${status} -eq 0 ]] && key="Conman config exist error about crashkernel option" && res=$fail
    show_result "$key" "$res"
    return $res
}
check_io_utilize()
{
    local log_file=$1
    local res=$success
    local key=""
    local util_index=$(awk '{for(i=1;i<=NF;i++)if($i ~ /'^%util$'/) print i }' $log_file | head -1)
    local iowait_index=$(awk '{for(i=1;i<=NF;i++)if($i ~ /'^%iowait$'/) print i }' $log_file | head -1)
    local iowait_data=$(awk '$'${util_index}'=="" {print $0}' $log_file | grep  -v '^[A-Za-z]+*' | awk '{print $'$((${iowait_index}-1))'}')
    local iowait_total=0
    for num in $iowait_data; do iowait_total=$(awk 'BEGIN{print '${iowait_total}'+'${num}'}') ; done
    local iowait_average_6=$(printf '%.0f' $(awk 'BEGIN{print '${iowait_total}'/6}'))
    [ $iowait_average_6 -ge 100  ] && key="IOwait average > 100" &&  res=$warn
    local util_data=$(awk  '$'${util_index}'!="" {print $0}' $log_file | grep -v 'Device:')
    local devic_num=$(($(echo "$util_data" | wc -l)/6))
    for devic in $(seq ${devic_num})
    do
        local devic_name=$(echo "$util_data" | awk 'NR=='${devic}' {print $1}')
        local devic_io_data=$(grep -w "$devic_name" $log_file | awk '{print $'${util_index}'}')
        local total=0
        for num in $devic_io_data; do total=$(awk 'BEGIN{print '${total}'+'${num}' }') ; done
        local devic_io_average_6=$(printf '%.0f' $(awk 'BEGIN{print '${total}'/6}'))
        [ $devic_io_average_6 -ge 80 ] && key="IO average util > 80 " && res=$warn
        [ $devic_io_average_6 -ge 100 ] && key="IO average util > 100" && res=$fail && break
    done
    [ $iowait_average_6 -ge 200  ] && key="IOwait average >200" && res=$fail
    show_result "$key" "$res"
    return $res
}
kernel_bug()
{
    local confirm=$1
    local key=$2
    local info="Kernel bug: $key"
    #confirm 1 means we have confirmed it is a bug
    [ $confirm -ne 1 ] && echo -n "Suspect: "
    echo $info
}
kernel_bug_known()
{
    local confirm=$1
    local key=$2
    local info="Known kernel bug: $key"
    [ $confirm -ne 1 ] && echo -n "Suspect: "
    echo $info
}
confirm_bug()
{
    local line=$1
    local msg=$2
    local logfile=$3
    local confirm=1

    local OLD_IFS="$IFS"
    IFS="@"
    local array=($line)
    IFS="$OLD_IFS"
    local length=${#array[@]}

    for ((i=2; i<$length; i++))
    do
        local ok=$(grep -A 100 -B 100 -i "$msg" "$logfile" | grep -ic "${array[$i]}")
        [ $ok -eq 0 ] && confirm=0
    done
    return $confirm
}
kernel_error_message()
{
    local logfile=$1
    local res=$success
    local info_type="Kernel Bug Info Data"
    local info_data=$(sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#')
    while read line
    do
        local action_fun=$(echo $line | awk -F "@" '{print $1}')
        local err_info=$(echo $line | awk -F "@" '{print $2}')
        local bug=$(grep -ic "$err_info" $logfile)
        local msg=$(grep -i "$err_info" $logfile)

        if [ $bug -ne 0 ]
        then
            local confirm=0
            confirm_bug "$line" "$err_info" "$logfile"
            confirm=$?
            eval "$action_fun" $confirm "\"$msg\""
            res=$fail
        fi
    done<<<"$info_data"

    return $res
}
check_ipmi_device()
{
    local log=$1
    local ok=$(cat "$log" | grep -c "Could not open device")
    [ $ok -ne 0 ] && show_result "Ipmi module did not load." $fail && return $fail
    return $success
}
check_ipmi_event()
{
    local logfile=$1
    local res=$success
    local info_type="Ipmi Event Data"
    local info_data=$(sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '##')

    check_ipmi_device "$logfile"
    [ $? -eq $fail ] && return $fail

    while read line
    do
        local msg=$(echo $line | awk -F "@" '{print $1}')
        local key=$(echo $line | awk -F "@" '{print $2}')
        local fail=$(cat $logfile | grep -c "$key")
        [ $fail -ne 0 ] && res=$fail && show_result "${msg}: $key" $res
    done<<<"$info_data"
    
    return $res
}
check_system_log()
{
    local log_file=$1
    local res=""
    local key=""
    local log_dir=$(dirname $log_file)
    key=$(kernel_error_message "${log_dir}/kern")
    res=$?
    if [ $res -eq $success ];then
         key=$(kernel_error_message "${log_dir}/messages")
         res=$?
    fi
    show_result "$key" "$res"
    return $res
}
check_dmesg()
{
    local log_file=$1
    local res=""
    local key=""
    key=$(kernel_error_message $log_file)
    res=$?
    show_result "$key" "$res"
    return $res
}

check_openfiles()
{
    local log_file=$1
    local res=$success
    local key=""
    local status=$(cat ${log_file} | grep -Fc '(deleted)')
    [[ $status -ne 0 ]] && key="Current system open file exists deleted state" && res=$warn
    show_result "$key" "$res"
    return $res
}

check_netcard()
{
    local log=$1
    local log_dir=$(dirname "$log")
    local nic_devices=$(ls -ld ${log_dir}/*/|awk '{print $9}'|awk -F / '{print $6}')
    local LinkState=""
    local DuplexMode=""
    local res=$success
    local nic_numbers=0
    for device in ${nic_devices}
    do
        if [ "${device}" != 'lo' ] && [ -d "${log_dir}/${device}" ]
        then
            [ ! -e ${log_dir}/${device}/device ] && continue
            LinkState=$(cat ${log_dir}/${device}/operstate)
            DuplexMode=$(cat ${log_dir}/${device}/duplex)
            [ "$LinkState" != "up" ] && key="the netcard $device link state is $LinkState" && res=$fail
            [ "$DuplexMode" != "full" ] && key="the netcard $device duplex mode is $DuplexMode" && res=$fail
        fi
    done
    show_result "$key" "$res"
    return $res
}

check_docker_mem()
{
    local dockers=$1
    local log_dir=$2
    local res=$success
    for docker in ${dockers}
    do
        local docker_path="${log_dir}/${docker}"
        local total=$(cat "$docker_path/free_m" | grep 'Mem' | awk '{print $2}')
        local used=$(cat "$docker_path/free_m" | grep buffers/cache | awk '{print $3}')
        local is_el5_6_status=$(cat "$docker_path/free_m" | grep -Fc "/+ buffers/cache")
        [ $is_el5_6_status -eq 0 ] && used=$(($(cat "$docker_path/free_m" | grep 'Mem' | awk '{print $2}')-$(cat "$docker_path/free_m" | grep 'Mem' | awk '{print $NF}')))
        local used_percentage=$((${used}*100/${total}))
        [ ${used_percentage} -ge 85 ] && key="Docker: $docker ,Mem total: $total ,used: $used ,Used percentage: $used_percentage > %85" && res=$warn
        [ ${used_percentage} -ge 90 ] && key="Docker: $docker ,Mem total: $total ,used: $used ,Used percentage: $used_percentage > %90" && res=$fail
    done
    show_result "$key" "$res"
    return $res
}
check_docker_diskspace()
{
    local dockers=$1
    local log_dir=$2
    local res=$success

    for docker in ${dockers}
    do
        local df_file="${log_dir}/${docker}/df_h"
        local devices=$(grep -v "Filesystem" $df_file | awk '{print $1}')
        for device in $devices
        do
            local device_line=$(grep -wE "^$device" $df_file)
            local total=$(echo $device_line|awk '{print $2}')
            local used=$(echo $device_line|awk '{print $3}')
            local mount_point=$(echo $device_line|awk '{print $6}')
            local used_percentage=$(echo $device_line|awk '{print $5}'|awk -F% '{print $1}')
            if [ $used_percentage -ge 85 ];
            then
                show_result "Docker: $docker ,device: $device ,fs: $mount_point ,used percentage: $used_percentage >= 85%" $warn
                [ "$res" = "" ] && res=$warn
            fi
            if [ $used_percentage -ge 90 ];then
                show_result "Docker: $docker ,device: $device ,fs: $mount_point ,used percentage: $used_percentage >= 90%" $fail
                res=$fail
            fi
        done
    done
    return $res
}
check_dockers()
{
    local log=$1
    local log_dir=$(dirname $log)
    local res=$success
    local key=""
    local dockers=$(cat ${log} | awk  '{print $1}' | grep -iv "Command:" | grep -iv "CONTAINER")

    check_docker_mem "$dockers" "$log_dir"
    [ $? -ne $success ] && res=$?
    check_docker_diskspace "$dockers" "$log_dir"
    [ $? -ne $success ] && res=$?
    return $res
}
check_abnormal_packets()
{
    local log_file=$1
    local res=$success
    local key=""
    local rx_tx_info=$(egrep -w "RX|TX" $log_file | grep -w errors | awk -F "errors" '{print $2}' | sed "s/:/ /g")
    local flag_num=$(echo "$rx_tx_info" | wc -l)
    local errors_ok_num=$(echo "$rx_tx_info" | awk '{print $1}'| grep -wc 0)
    local dropped_ok_num=$(echo "$rx_tx_info" | awk '{print $3}' | grep -wc 0)
    local carrier_ok_num=$(echo "$rx_tx_info" | grep -w carrier | awk '{print $7}' | grep -wc 0)
    [ $dropped_ok_num -ne $flag_num ] && key=" RX packets or TX packets exist dropped problem!" && res=$warn
    [ $carrier_ok_num -ne $(($flag_num/2)) ] && key="TX packets exist carrier problem!" && res=$warn
    [ $errors_ok_num -ne $flag_num ] && key="RX packets or TX packets exist errors problem!" && res=$fail
    show_result "$key" "$res"
    return $res
}
check_bonding()
{
    local log=$1
    local log_dir=$(dirname $log)
    local res=$success
    local key=""
    local bonds=$(ls -ld ${log_dir}/*/ | awk '{print $9}' | awk -F / '{print $6}')

    for bond in $bonds
    do
        local bonding_dir="${log_dir}/${bond}"
        local bonding_log="$bonding_dir/cat_$bond"
        [ ! -e $bonding_log ] && continue
        local slave_flag=$(grep -c "MII Status" "$bonding_log")
        local up_flag=$(grep -v "Duplex" "$bonding_log" | grep -c "up")
        local lacp_flag=$(grep -c "LACP" "$bonding_log")
        local port_flag=$(grep "Number of ports" $bonding_log|awk '{print $4}')
        [ $port_flag -ne 2 ] && show_result "Number of ports is $port_flag" $warn && res=$warn
        [ $lacp_flag -ne 1 ] && show_result "$bond is not LACP protocal" $fail && res=$fail
        [ $slave_flag -ne $up_flag ] && show_result "$bond has slave nic down" $fail && res=$fail
    done
    return $res
}
check_alimonitor_syslog()
{
    local log_file=$1
    local res=$success
    local key=""
    local flag=$(grep "collection_flag" $log_file|awk -F: '{print $2}'|grep -c "0,")
    local total_status=$(grep -c "OK" $log_file)
    local childs=$(grep "MSG" -A 5 $log_file|grep -v MSG|sed 's/"/ /g'|awk '{print $4}')
    for child in $childs
    do
        local child_status=$(grep "MSG" -A 5 $log_file|grep -v MSG|sed 's/"/ /g'|grep $child|grep -c OK)
        if [ $child_status -eq 1 ];then
            continue
        else
            key+="$child is not ok"
        fi
    done
    [ $flag -lt 1 ] || [ $total_status -lt 5 ] && res=$warn
    [ $flag -eq 1 ] && [ $total_status -eq 5 ] && res=$fail
    show_result "$key" "$res"
    return $res
}
check_alimonitor_hardward()
{
    local log_file=$1
    local res=$success
    local key=""
    local flag=$(grep "collection_flag" $log_file|awk -F: '{print $2}'|grep -c "0,")
    local status=$(grep -c "OK" $log_file)
    [ $flag -lt 1 ] || [ $status -lt 1 ] && local key+="collection flag is not ok!" && res=$warn
    [ $flag -eq 1 ] && [ $status -eq 1 ] && local key+="hardware health is not ok!" && res=$fail
    show_result "$key" "$res"
    return $res
}
check_raid_card()
{
    local typefile=$1
    local logdir=$(dirname $typefile)
    local raid_type=$(cat $typefile|grep -i "raid_controller" | awk -F: '{print $2}')
    local res=$success
    local key=""
    case $raid_type in
        hpraid)
            local cfg_logfile="$logdir/$raid_type/hpacucli_config.log"
            local lds=$(grep "logicaldrive" $cfg_logfile|awk '{print $1,$2}')
            local pds=$(grep "physicaldrive" $cfg_logfile|awk '{print $1,$2}')
            for ld in $lds
            do
                local ld_status=$(grep "$ld" $cfg_logfile|grep -c OK)
                [ $ld_status -lt 1 ] && key+="$ld is not ok!" && res=$fail
            done
            for pd in $pds
            do
                local pd_status=$(grep "$pd" $cfg_logfile|grep -c OK)
                [ $pd_status -lt 1 ] && key+="$pd is not ok!" && res=$fail
            done
            show_result "$key" "$res"
            return $res
            ;;
        megaraidsas)
            local cfg_logfile="$logdir/$raid_type/cfgdsply.log"
            local pdld_logfile="$logdir/$raid_type/ldpdinfo.log"
            local lds=$(grep "Number of DISK GROUPS" $cfg_logfile|awk '{print $5}')
            local optimal_count=$(grep "^State" $cfg_logfile|grep -c "Optimal")
            local pds=$(grep -v "Physical Disk Information" $cfg_logfile|grep -c "Physical Disk")
            local media_error_count=$(grep "Media Error Count" $cfg_logfile|awk '{sum += $4};END {print sum}')
            local other_error_count=$(grep "Other Error Count" $cfg_logfile|awk '{sum += $4};END {print sum}')
            local predictive_failure_count=$(grep "Predictive Failure Count" $cfg_logfile|awk '{sum += $4};END {print sum}')
            local firmware_state=$(grep -c "Online, Spun Up" $cfg_logfile)

            local disk_group=$(grep -v "Number of DISK GROUP" $cfg_logfile |grep "DISK GROUP")
            for ld in $disk_group
            do
                dg_status=$(sed -n "/$ld/,/^State/p" $cfg_logfile|grep State|awk '{print $3}')
                [[ "$dg_status" -eq "Optimal" ]] && continue
                key+="$ld status is $dg_status"
            done

            if [ $firmware_state -lt $pds ];then
                local pd_state=$(grep "Firmware state" $cfg_logfile|cat -n|grep -v "Online, Spun Up")
                key+="$pd_state"
            fi

            [ $media_error_count -gt 0 ] || [ $other_error_count -gt 0 ] || [ $predictive_failure_count -gt 0 ] && res=$warn
            [ $optimal_count -lt $lds ] || [ $firmware_state -lt $pds ] && res=$fail
            show_result "$key" "$res"
            return $res
            ;;
        mpt2sas)
            local cfg_logfile="$logdir/$raid_type/sas2ircu_controllers_display.log"
            local ir_status=$(grep -v "IR Volume information" $cfg_logfile|grep -c "IR volume")
            local lds=$(grep -v "IR Volume information" $cfg_logfile|grep "IR volume")
            local pds=$(grep "Slot #" $cfg_logfile)
            if [ $ir_status -gt 0 ];then
                for ld in $lds
                do
                    local ld_status=$(grep "$ld" -A 4 $cfg_logfile|tail -1|grep -Ec "Degraded|Failed|Missing")
                    [ $ld_status -gt 0 ] && local key+="$ld is Degraded|Failed|Missing"  && res=$fail
                done
            fi
            for pd in $pds
            do
                local pd_status=$(grep "$pd" -A 2 $cfg_logfile|tail -1|grep -Ec "Available|Failed|Missing|Degraded")
                [ $pd_status -gt 0 ] && key="physical drive in $pd is Available|Failed|Missing|Degraded" && res=$fail
            done
            show_result "$key" "$res"
            return $res
            ;;
        unknown)
            key="raid type is unknown,please confirm that" && res=$fail
            show_result "$key" "$res"
            return $res
            ;;
        *)
            key="can not find any raid type" && res=$warn
            show_result "$key" "$res"
            return $res
    esac
    return $res
}

check_send_receive_err()
{
    local file=$1
    local key=""
    local res=$success
    local title=$(sed '1,2d' $file|head -1)
    local colume_num=0
    local rx_err_n=0
    local rx_drp_n=0
    local rx_ovr_n=0
    local tx_err_n=0
    local tx_drp_n=0
    local tx_ovr_n=0

    for title_item in $title
    do
        ((colume_num++));
        case $title_item in
            "RX-ERR") rx_err_n=$colume_num
            ;;
            "RX-DRP") rx_drp_n=$colume_num
            ;;
            "RX-OVR") rx_ovr_n=$colume_num
            ;;
            "TX-ERR") tx_err_n=$colume_num
            ;;
            "TX-DRP") tx_drp_n=$colume_num
            ;;
            "TX-OVR") tx_ovr_n=$colume_num
            ;;
        esac
    done

    local sum_one_line=$(sed '1,3d' $file|awk -v v1=$rx_err_n -v v2=$rx_drp_n \
                       -v v3=$rx_ovr_n  -v v4=$tx_err_n -v v5=$tx_drp_n \
                       -v v6=$tx_ovr_n '{print int($v1+$v2+$v3+$v4+$v5+$v6)}')
    for i in $sum_one_line
    do
        [ $i -gt 0 ] && key="Receive or send packets error" && res=$warn
    done
    show_result "$key" $res
    return $res
}

check_tcp_status()
{
    local logfile=$1
    local res=$success
    local key=""
    local close_wait_count=$(sed -n '/Active Internet/,/Active UNIX/p' $logfile|grep -Ev "^udp|Internet|UNIX|Proto|raw"|awk '{print $6}'|grep -c "CLOSE_WAIT")
    [ $close_wait_count -ge 100 ] && local key="More than $close_wait_count tcp connection in close_wait status." && res=$warn
    [ $close_wait_count -ge 200 ] && local key="More than $close_wait_count tcp connection in close_wait status." && res=$fail
    show_result "$key" "$res"
    return $res
}

check_ipmi_sensor()
{
    local logfile=$1
    local res=$success
    local key=""
    local sensor_status=$(grep -v "Command" $logfile|awk -F '|' '{print $4}'|grep -Evc "ok|0x0100|0x0000|0x8000|0x0080|0x0180|0x4080|0x0200|0x4000|na|nc|cr")

    check_ipmi_device "$logfile"
    [ $? -eq $fail ] && return $fail
    [ $sensor_status -gt 0 ] && local key="Sensor status is abnormal." && res=$warn
    show_result "$key" "$res"
    return $res
}

check_ipmi_sdr()
{
    local logfile=$1
    local res=$success
    local key=""
    local sdr_err=$(grep -v "Command" $logfile|awk -F '|' '{print $3}'| egrep -vc "ok|nc|cr")
    check_ipmi_device "$logfile"
    [ $? -eq $fail ] && return $fail
    [ $sdr_err -ne 0 ] && local key="Sdr status is abnormal." && res=$warn
    show_result "$key" "$res"
    return $res
}

check_ntp()
{
    local logfile=$1
    local res=$success
    local ntp_master=$(grep "\*" $logfile|awk '{print $1}'|awk -F'*' '{print $2}')
    local ntpq_offset=$(grep "\*" $logfile|awk '{print $9}'|sed -r 's/-([0-9]+)/\1/g'|awk -F'.' '{print $1}')
    local key=""
    [ $ntpq_offset -ge 500 ] && key="offset is $ntpq_offset,big than 500!" && res=$warn
    [[ "$ntp_master" =~ "127.127" ]] && key="Ntp client sync to local clock." && res=$fail
    show_result "$key" "$res"
    return $res
}

check_dns()
{
    local logfile=$1
    local res=$success
    local key=""
    local query_times=$(grep -c "@" $logfile)
    local query_noerror=$(grep "HEADER" $logfile|grep -c "NOERROR")

    [ $query_noerror -lt $query_times ] && key="only have $query_noerror server response" && res=$warn
    [ $query_noerror -eq 0 ] && key="no server can response this query" && res=$fail
    show_result "$key" "$res"
    return $res
}
summary_cpu_process()
{
    local type_pattern="Type Data"
    local info_pattern="System Info Data"
    local logdir=$(sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE|grep "$info_pattern"|awk -F: '{print $2}')
    local ps_log=$(sed -n "/## $info_pattern ##/,/## End $info_pattern ##/"p $DATA_FILE|grep -E "^ps"|awk -F: '{print $4}')
    local top_log=$(sed -n "/## $info_pattern ##/,/## End $info_pattern ##/"p $DATA_FILE|grep -E "^top_thread"|awk -F: '{print $4}')
    local ps_logfile="$LOGDIR/$logdir/$ps_log"
    local top_logfile="$LOGDIR/$logdir/$top_log"
    local d_logfile="$LOGDIR/summary_cpu_process_check"

    echo "Start summary process load info ..."
    
    > $d_logfile
    [ ! -e $ps_logfile ] || [ ! -e $top_logfile ] && return
    PID=$(awk '{print $1}' $ps_logfile|grep -Ev "PID|Command"|uniq -c|sort -rn|awk '{print $2}')
    cat $top_logfile|head -6|tail -5 >> $d_logfile
    echo "" >> $d_logfile
    printf "%-5s %-5s %-5s %-5s %-20s %-15s\n" PID COUNT %CPU %MEM WIDE-WCHAN-COLUMN COMMAND >> $d_logfile
    for pid in $PID
    do
        local WCHAN=$(grep -wE "^[ ]*$pid" $ps_logfile|awk '{print $11}'|sort|uniq)
        local command=$(grep -wE "^[ ]*$pid" $ps_logfile|awk '{$1="";$2="";$3="";$4="";$5="";$6="";$7="";$8="";$9="";$10="";$11="";print}'|tail -1)
        local mem_result=$(grep -wE "^[ ]*$pid" $ps_logfile|awk '{print $5}'|tail -1)
        for wchan in $WCHAN
        do
            local cpu_result=0
            local CPU=$(grep -wE "^[ ]*$pid" $ps_logfile|grep -w "$wchan"|awk '{print $4}')
            for cpu in $CPU
            do
                cpu_result=$(echo "$cpu $cpu_result"|awk '{printf ("%.1f\n",$1+$2)}')
            done
            local wchan_count=$(grep -wE "^[ ]*$pid" $ps_logfile|grep -wc "$wchan")
            printf "%-5s %-5s %-5s %-5s %-20s %-10s\n" "$pid" "$wchan_count" "$cpu_result" "$mem_result" "$wchan" "$command" >> $d_logfile
        done
    done
}
check_rpmdb()
{
    local log=$1
    local res=$success
    local bad_result="Database verification failed"
    local nofile_result="No such file or directory"
    local result=$(egrep -c "$bad_result|$nofile_result" $log)
    [ $result -ge 1 ] && key="rpm database verification failed" && res=$fail
    show_result "$key" "$res"
    return $res
}
generate_item_json_format()
{
    local check_log=$1
    local check_fun=$2
    local check_name=$3
    local json_file=$4
    local check_file="${check_log}_check"
    local json_status=""

    [ "$check_fun" = "" ] && return
    [ ! -s $check_file ] || [ ! -e "$check_file" ] && return
    [ -s $check_file ] && [ $(grep -Ec "WARNING|FAIL" $check_file) -eq 0 ] && return

    local check_info=$(cat "$check_file")
    local warn_status=$(tail -1 "$check_file"|grep -c 'WARNING')
    local fail_status=$(tail -1 "$check_file"|grep -c 'FAIL')
    [ $warn_status -eq 1 ] && json_status=1
    [ $fail_status -eq 1 ] && json_status=2

    echo " {" >> $json_file
    echo "  \"status\": $json_status," >> $json_file
    echo "  \"name\": \"$check_name\"," >> $json_file
    echo "  \"info\": \"$check_info\"," >> $json_file
    echo " }," >> $json_file
}
generate_item_json()
{
    local info_type="$1"
    local full_path="$2"
    local json_file="$3"
    sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#' | while read line
    do
        local flag=$(echo $line | awk -F: '{print $1}')
        local action=$(echo $line | awk -F: '{print $3}')
        local filename=$(echo $line | awk -F: '{print $4}')
        local scope=$(echo $line | awk -F: '{print $5}')
        local check_fun=$(echo $line | awk -F: '{print $6}')
        local log="${full_path}/${filename}"

        if [ "$target_cmd" != "" ];then
            [ "$target_cmd" = "$flag" ] && generate_item_json_format "$log" "$check_fun" "$filename" "$json_file"
            continue
        fi
        [ $target_scope -ge $scope ] && generate_item_json_format "$log" "$check_fun" "$filename" "$json_file"
    done
}
generate_json_report()
{
    local type_pattern="Type Data"
    local json_file="$LOGDIR/check.json"
    sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#' | while read typeline
    do
        local info_type=$(echo $typeline | awk -F: '{print $1}')
        local info_dir=$(echo $typeline | awk -F: '{print $2}')
        local default=$(echo $typeline | awk -F: '{print $3}')
        local info_output=$(echo $typeline | awk -F: '{print $4}')
        local full_path="${LOGDIR}/$info_dir"

        [ "$target_type" != "" ] && [ "$target_type" != "$info_type" ] && continue
        [ "$target_type" = "" ] && [ "$default" != "default" ] && continue
        generate_item_json "$info_type" "$full_path" "$json_file"
    done
    sed -i '1i\[' $json_file
    sed -i '$d' $json_file && echo " }" >> $json_file
    echo "]" >> $json_file
}
list_flags()
{
    local type_pattern="Type Data"

    info ""
    sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#' | while read typeline
    do
        local info_type=$(echo $typeline | awk -F: '{print $1}')
        echo "Type: $info_type"
        sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#' | while read line
        do
            local flag=$(echo $line | awk -F: '{print $1}')
            echo -e "\t$flag"
        done
    done
    exit 0
}

collection_items()
{
    local info_type="$1"
    local info_output="$2"
    local full_path="$3"

    info "Start collecting $info_output"
    mkdir -p "$full_path"
    sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#' | while read line
    do
        local flag=$(echo $line | awk -F: '{print $1}')
        local cmd=$(echo $line | awk -F: '{print $2}')
        local action=$(echo $line | awk -F: '{print $3}')
        local filename=$(echo $line | awk -F: '{print $4}')
        local scope=$(echo $line | awk -F: '{print $5}')
        local log="${full_path}/${filename}"

        if [ "$target_cmd" != "" ];then
            [ "$target_cmd" = "$flag" ] && cmd_log "$cmd" "$log" "$action"
            continue
        fi

        [ $target_scope -ge $scope ] && cmd_log "$cmd" "$log" "$action"
    done
}
collection_all()
{
    local type_pattern="Type Data"

    sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#' | while read typeline
    do
        local info_type=$(echo $typeline | awk -F: '{print $1}')
        local info_dir=$(echo $typeline | awk -F: '{print $2}')
        local default=$(echo $typeline | awk -F: '{print $3}')
        local info_output=$(echo $typeline | awk -F: '{print $4}')
        local full_path="${LOGDIR}/$info_dir"

        [ "$target_type" != "" ] && [ "$target_type" != "$info_type" ] && continue
        [ "$target_type" = "" ] && [ "$default" != "default" ] && continue
        collection_items "$info_type" "$info_output" "$full_path"
    done | tee -a "${LOGDIR}/collecting_output"
}
start_collection()
{
    if [ $list_items -eq 1 ];then
        list_flags
    else
        collection_all
    fi
}
generate_data_file()
{
    local type_pattern="Main Info Data"
    sed -n "/## ${type_pattern} ##/,/## End ${type_pattern} ##/"p $0 > $DATA_FILE
}

checking_items()
{
    local info_type="$1"
    local info_output="$2"
    local full_path="$3"

    info "Start checking $info_output"

    sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#' | while read line
    do
        local flag=$(echo $line | awk -F: '{print $1}')
        local cmd=$(echo $line | awk -F: '{print $2}')
        local action=$(echo $line | awk -F: '{print $3}')
        local filename=$(echo $line | awk -F: '{print $4}')
        local scope=$(echo $line | awk -F: '{print $5}')
        local check_fun=$(echo $line | awk -F: '{print $6}')
        local fix_fun=$(echo $line | awk -F: '{print $7}')
        local log="${full_path}/${filename}"

        if [ "$target_cmd" != "" ];then
            [ "$target_cmd" = "$flag" ] && analysis_log "$cmd" "$check_fun" "$fix_fun" "$log" "$action"
            continue
        fi

        [ $target_scope -ge $scope ] && analysis_log "$cmd" "$check_fun" "$fix_fun" "$log" "$action"
    done
}
summary_process_html()
{
    local system_monitor_info=""
    local summary_top_info=$(cat "$LOGDIR/summary_cpu_process_check" | grep -Ev "PID|^[0-9]+")
    local summary_process_info=""

    local summary_process_field_info=$(cat "$LOGDIR/summary_cpu_process_check" | grep "PID")
    local summary_process_line_info=$(cat "$LOGDIR/summary_cpu_process_check" | grep '^[0-9]\+')

    local PID=$(echo "$summary_process_field_info" | awk '{print $1}')
    local COUNT=$(echo "$summary_process_field_info" | awk '{print $2}')
    local CPU=$(echo "$summary_process_field_info" | awk '{print $3}')
    local MEM=$(echo "$summary_process_field_info" | awk '{print $4}')
    local WIDE_WCHAN_COLLUMN=$(echo "$summary_process_field_info" | awk '{print $5}')
    local COMMAND=$(echo "$summary_process_field_info" | awk '{print $6}')
    local summary_process_field_html="
         <table class=\"table table-bordered\" style=\"word-break:break-all; word-wrap:break-all;\">
            <thead>
                <tr class=\"tr_top\" height=\"30px\">
                    <th class=\"as\" id=\"th0\" onclick=\"ProcessCountSort(this)\" width=\"10%\" style=\"text-align: center;vertical-align: middle;\">${PID}</th>
                    <th class=\"as\" id=\"th1\" onclick=\"ProcessCountSort(this)\" width=\"10%\" style=\"text-align: center;vertical-align: middle;\">${COUNT}</th>
                    <th class=\"as\" id=\"th2\" onclick=\"ProcessCountSort(this)\" width=\"15%\" style=\"text-align: center;vertical-align: middle;\">${CPU}</th>
                    <th class=\"as\" id=\"th3\" onclick=\"ProcessCountSort(this)\" width=\"15%\" style=\"text-align: center;vertical-align: middle;\">${MEM}</th>
                    <th width=\"15%\" style=\"text-align: center;vertical-align: middle;\">${WIDE_WCHAN_COLLUMN}</th>
                    <th width=\"65%\" style=\"text-align: center;vertical-align: middle;\">${COMMAND}</th>
                </tr>
            </thead>
            <tbody id=\"summary_process_line_color\">"
    while read process_line
    do
        local pid=$(echo "$process_line" | awk '{print $1}')
        local num=$(echo "$process_line" | awk '{print $2}')
        local cpu=$(echo "$process_line" | awk '{print $3}')
        local mem=$(echo "$process_line" | awk '{print $4}')
        local wide_wchan_column=$(echo "$process_line" | awk '{print $5}')
        local commands=$(echo "$process_line" | awk '{data="";for(i=6;i<=NF;i++){data=data""$i} print data}')
        local summary_process_line_html+="
                <tr class=\"text-center\" height=\"25px\">
                    <td name="td0" height=\"25px\">${pid}</td>
                    <td name="td1" height=\"25px\">${num}</td>
                    <td name="td2" height=\"25px\">${cpu}</td>
                    <td name="td3" height=\"25px\">${mem}</td>
                    <td name="td4" height=\"25px\">${wide_wchan_column}</td>
                    <td name="td5" height=\"25px\">${commands}</td>
                </tr>"
    done <<< "${summary_process_line_info}"
    local summary_process_line_html_end="
            </tbody>
        </table>"
    summary_process_info="${summary_process_field_html}${summary_process_line_html}${summary_process_line_html_end}"
    system_monitor_info="${summary_top_info}${summary_process_info}"
	echo "$system_monitor_info"
}
html_body()
{
    local flag=$1
    local check_status=$2
    local check_result_reson=$3
    local collect_log_data=$4
    local n=$5
    local html_content="
            <tr class=\"text-center\">
                <td></td>
                <td>${flag}</td>
                ${check_status}
                <td>${check_result_reson}</td>
                <td>
                    <button class=\"btn btn-success \" data-toggle=\"modal\" data-target=\"#myModal${n}\">
                        Detail
                    </button>
                </td>
            <div class=\"modal fade\" id=\"myModal${n}\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">
                <div class=\"modal-dialog\">
                <div class=\"modal-content\">
                <div class=\"modal-header\">
                <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">
                    &times;
                </button>
                <h4 class=\"modal-title\" id=\"myModalLabel\">
                    ${flag}
                </h4>
                </div>
                <div class=\"modal-body\">
                ${collect_log_data}
                </div>
            <div class=\"modal-footer\">
            <button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">关闭
            </button>
                </div>
                </div>
                </div>
                </div>
            </tr>"
    echo "$html_content"
}
get_system_info_from_log()
{
    local type_pattern="Type Data"
    local info_pattern="System Info Data"
    local logdir=$(sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE|grep "$info_pattern"|awk -F: '{print $2}')
    local sysinfo_log=$(sed -n "/## $info_pattern ##/,/## End $info_pattern ##/"p $DATA_FILE|grep -E "^sysinfo"|awk -F: '{print $4}')
    local sysinfo_file="${LOGDIR}/${logdir}/$sysinfo_log"
    cat $sysinfo_file | sed '1,1d'
}
generate_html_body()
{
    local html=$1
    local type_pattern="Type Data"
    local type_data=$(sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#')
    local n=1
    local system_info=$(echo "$(get_system_info_from_log)" | grep -v "^$")
    local html_info_system="<pre id=\"system_data\" style=\"display: none\"><code>${system_info}</code></pre>"
    local system_monitor_info=$(summary_process_html)
    local html_info_system_monitor="<pre id=\"system_monitor_data\" style=\"display: none\"><code>${system_monitor_info}</code></pre>"
    local html_type_report="Check Report Html Article"
    local html_info_check_report_th=$(sed -n "/## ${html_type_report} ##/,/## End ${html_type_report} ##/"p $DATA_FILE | grep -v '^#\+')
    echo "$html_info_system" >> "$html"
    echo "$html_info_system_monitor" >> "$html"
    echo "$html_info_check_report_th" >> "$html"

    while read typeline
    do
        local info_type=$(echo $typeline | awk -F : '{print $1}')
        local info_dir=$(echo $typeline | awk -F : '{print $2}')
        local full_path="${LOGDIR}/$info_dir"
        local item_data=$(sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#')

        while read line
        do
            local flag=$(echo $line | awk -F: '{print $1}')
            local filename=$(echo $line | awk -F: '{print $4}')
            local collect_log="${full_path}/${filename}"
            local check_log="${full_path}/${filename}_check"
            local check_status=""
            local check_result_reson=""
            local check_report_status=0
            local collect_log_data=""

            [ ! -e "$check_log" ] && continue

            check_report_status=$(cat $check_log 2>/dev/null | grep -c 'Check Report Info')
            while read line
            do
                local res_status=$(echo $line | awk -F ':' '{print $2}' | awk -F ')' '{print $1}' | sed 's/(//g' | sed 's/ //g')
                case "$res_status" in
                    "WARNING")
                        [ "$check_status" = "" ] && check_status="<td style=\"color:orange\">$res_status</td>"
                        ;;
                    "FAIL")
                        check_status="<td style=\"color:red\">$res_status</td>";;
                    *) ;;
                esac
                check_result_reson+="$(echo $line | awk -F ')' '{data=""; for(i=2;i<=NF;i++) {data=data""$i}; print data }')<br>"
            done <<< "$(cat $check_log 2>/dev/null | grep "Check Report Info")"
            [ $check_report_status -eq 0 ] && check_status="<td style=\"color:lime\">SUCCESS</td>" && check_result_reson=''

            collect_log_data=$(tail -1000 $collect_log 2>/dev/null | awk '{print $0 "<br>"}')
            html_body "$flag" "$check_status" "$check_result_reson" "$collect_log_data" $n  >> "$html"
            ((n++))
        done <<< "${item_data}"
    done <<< "${type_data}"
}
generate_html_report()
{
    local html_type_head="Check Report Html Head"
    local html_type_tail="Check Report Html Tail"
    local html_info_head=$(sed -n "/## ${html_type_head} ##/,/## End ${html_type_head} ##/"p $DATA_FILE | grep -v '^#\+')
    local html_info_tail=$(sed -n "/## ${html_type_tail} ##/,/## End ${html_type_tail} ##/"p $DATA_FILE | grep -v '^#\+')
    local html_file="${LOGDIR}/check_report.html"

    echo "$html_info_head" > "$html_file"
    generate_html_body "$html_file"
    echo "$html_info_tail" >> "$html_file"
}
generate_report()
{
    info "Start generate report ..."
    generate_html_report
    generate_json_report
}
start_checking()
{
    local type_pattern="Type Data"
    sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#' | while read typeline
    do
        local info_type=$(echo $typeline | awk -F: '{print $1}')
        local info_dir=$(echo $typeline | awk -F: '{print $2}')
        local info_output=$(echo $typeline | awk -F: '{print $4}')
        local full_path="${LOGDIR}/$info_dir"

        checking_items "$info_type" "$info_output" "$full_path"
    done | tee -a "${LOGDIR}/checking_output"
}
check_and_generate_report()
{
    [ $checking -eq 0 ] && return
    start_checking
    summary_cpu_process
    generate_report
}
collection_log()
{
    [ "$syslog_tgz" = "" ] && start_collection
}
################################ End Utility Function ################################

############################### Main ################################
usage()
{
    cat << EOF
    Usage:
        $(basename $0) -V                     debug mode.
        $(basename $0) -d <target dir>        All log will be generated to target dir.
        $(basename $0) -i <target item>       Call target item to get info.
        $(basename $0) -t <target type>       Call target type to get info.
        $(basename $0) -s <target scope>      Call target scope: small, normal(default), all to get info.
        $(basename $0) -n                     Will not compress log files to generate tarball.
        $(basename $0) -c                     Check log content and generate report.
        $(basename $0) -f <log file>          Assign log tarball file, need with parameter -c.
        $(basename $0) -l                     Just list type and items out.
    Example:
        $(basename $0) -d /apsara -s all
        $(basename $0) -s small
        $(basename $0) -t "Slb Info Data"
        $(basename $0) -i disks_io_detail
        $(basename $0) -c -f ./cloud_log.2017-09-01-15-23-57.tar.gz
EOF
    exit 1
}
while getopts d:t:f:i:s:achnlV OPTION
do
    case $OPTION in
        h) usage;;
        V) set -x;;
        i) target_cmd="$OPTARG";;
        t) target_type="$OPTARG";;
        s) SCOPE_TYPE="$OPTARG";;
        d) SLOGDIR="$OPTARG";;
        c) checking=1;;
        f) syslog_tgz="$OPTARG";;
        n) no_compress=1;;
        l) list_items=1;;
        *) usage;;
    esac
done

show_system_info
prepare_to_run
trap cleanup EXIT
generate_data_file
free_space_check
check_single_instance
collection_log
check_and_generate_report
compress_log
exit 0
############################# End Main ##############################

########################## Main Info Data ############################
########################## Collection Data ############################
############################# Type Data ############################
#Info Type:logdir:scope:description
System Info Data:system_info:default:system information ...
Network Info Data:network_info:default:network information ...
BMC Info Data:bmc_info:default:bmc information ...
Dom0 Info Data:dom0_info:default:dom0 information ...
Disk Info Data:disk_info:default:disk information ...
Slb Info Data:lsb_info::slb information ...
########################### End Type Data ##########################

#flag:collect_function:action:filename:scope:analysis_function:fix_function

#flag make sure it is unique
#action include:
# check <-- check if command exist, default to check
# path  <-- send target path to command

#filename is log file name.
#scope include 1(small), 2(normal) and 3(all).
########################## System Info Data ###########################
sysinfo:show_system_info::system_info:1::
history:cat $HOME/.bash_history::history:1:check_user_behavior:
uname:uname -a::uname_a:1::
df:df -h::df_h:1:check_disk_size:
free:free -m::free_m:1:check_free_memory:
ps:ps -Le -wwo 'pid,spid,psr,pcpu,pmem,rsz,stime,user,stat,uid,wchan=WIDE-WCHAN-COLUMN,args' --sort rsz::ps_Le_wwo_rsz:1:check_process_status:
last:last reboot::last_reboot:1::
chkconfig:chkconfig --list::chkconfig__list:1::
runlevel:runlevel::runlevel:1::
uptime:uptime::uptime:1:check_system_load:
fstab:get_fstab_info::fstab_info:1:check_fstab:
cat_mount:cat /proc/mounts::cat_mount:1:check_readonly:
top_thread:top -H -b -n 1::top_H_b:1::
top:top -b -n 1::top_b:1::
kdump:/etc/init.d/kdump status::kdump_status:1:check_kdump_status:
kdump_conf:cat /etc/kdump.conf::kdump_conf:1:check_kdump_config:
lsmod:lsmod::lsmod:1::
cmdline:cat /proc/cmdline::cat_proc_cmdline:1:check_conman_config:
meminfo:cat /proc/meminfo::cat_proc_meminfo:1::
slabinfo:cat /proc/slabinfo::cat_proc_slabinfo:1::
vmallocinfo:cat /proc/vmallocinfo::cat_vmallocinfo:1::
swaps:cat /proc/swaps::cat_proc_swaps:1::
cpuinfo:cat /proc/cpuinfo::cat_proc_cpuinfo:1::
ntp:ntpq -np::ntpq_np:1:check_ntp:
dns:get_dns_info::dns_info:1:check_dns:
dmidecode:dmidecode::dmidecode:1::
dmesg:dmesg::dmesg:1:check_dmesg:
ulimit:ulimit -a::ulimit_a:1::
crontab:crontab -l::crontab_l:1::
mpstat:mpstat -P ALL 1 6::mpstat_P:2::
iostat:iostat -xm 1 6::iostat_xm:1:check_io_utilize:
vmstat:vmstat 1 6::vmstat:2::
tsar:tsar -n 6:check:tsar_n6:2::
blkid:blkid::blkid:1::
lsscsi:lsscsi::lsscsi:1::
mdadm:mdadm --detail::mdadm__detail:1::
lvs_detail:lvs -vv::lvs_vv:1::
lvs:lvs -v::lvs_v:1::
vgs:vgs::vgs:1::
pvs:pvs::pvs:1::
lsof:lsof::lsof:1:check_openfiles:
journalctl:journalctl -xn:check:journalctl_xn:2::
cp_system_files:copy_system_files:path:copy_system_files:1:check_system_log:
cp_other_files:copy_other_files:path:copy_other_files:3::
top10_mem:get_top10_mem_process_info:path:top_mem_order:1::
top10_cpu:get_top10_cpu_process_info:path:top_cpu_order:1::
rpmdb_verify:/usr/lib/rpm/rpmdb_verify /var/lib/rpm/Packages::rpmdb_verify:1:check_rpmdb:
######################### End System Info Data ########################
######################## Network Info Data ###########################
sarnet:sar -n DEV 1 6::sar_n_dev:2::
ss:ss -anpei::ss_anpei:3::
ifstat:ifstat -a 1 6::ifstat_a:2::
ipaddr:ip addr show::ip_addr_show:1::
iproute:ip route show::ip_route_show:1::
ifconfig:ifconfig::ifconfig:1:check_abnormal_packets:
ifconfig_all:ifconfig -a::ifconfig_a:1::
route_cache:route -Cn::route_Cn:1::
route:route -n::route_n:1::
netstat:netstat -anpo::netstat_anpo:1:check_tcp_status:
netstat_pro:netstat -s::netstat_s:1::
netstat_dev:netstat -i::netstat_i:1:check_send_receive_err:
bonding_info:get_bonding_info:path:bonding_info:1:check_bonding:
netcard_info:get_netcard_info:path:netcard_info:1:check_netcard:
###################### End Network Info Data #########################
########################## BMC Info Data #######################
ipmifru:ipmitool fru list::ipmitool_fru_list:1::
ipmilan:ipmitool lan print 1::ipmitool_lan_print_1:1::
ipmimc:ipmitool mc info::ipmitool_mc_info:1::
ipmisensor:ipmitool sensor list::ipmitool_sensor_list:1:check_ipmi_sensor:
ipmisdr:ipmitool sdr list::ipmitool_sdr_list:1:check_ipmi_sdr:
ipmisel:ipmitool sel elist::ipmitool_sel_elist:1:check_ipmi_event:
######################## End BMC Info Data #####################
########################## Dom0 Info Data ######################
docker_info:get_docker_info:path:docker_info:1:check_dockers:
######################## End Dom0 Info Data ####################
############################ Disk Info Data ####################
disks_io_detail:get_disks_io_detail:path:disks_io_detail:3::
disk_info:get_disk_info:path:disk_info:2::
aliflash:get_aliflash_info:path:aliflash_info:2::
raid_info:get_raid_log:path:raid_type:1:check_raid_card:
check_syslog:/usr/alisys/dragoon/libexec/alimonitor/independent_domain_check_syslog:check:independent_domain_check_syslog:1:check_alimonitor_syslog:
check_hardware:/usr/alisys/dragoon/libexec/alimonitor/independent_domain_check_hardware:check:independent_domain_check_hardware:1:check_alimonitor_hardward
########################## End Disk Info Data #####################
############################ Slb Info Data #########################
########################## End Slb Info Data #########################
######################## End Collection Data ##########################

############################ Checking Data ##############################
#1 function
#2 key word
#3 key word
# etc ..
######################## Kernel Bug Info Data #######################
kernel_bug@BUG: unable to handle kernel paging request@fib_list_tables
kernel_bug@oom-killer@memory: usage
kernel_bug@arch/x86/kernel/paravirt.c@paravirt_enter_lazy_mmu
kernel_bug_known@arch/x86/kernel/xsave.c:@__sanitize_i387_state
kernel_bug_known@divide error: 0000@thread_group_times
kernel_bug_known@unable to handle kernel NULL pointer@netpoll_poll_dev
kernel_bug_known@unable to handle kernel NULL pointer@update_shares
kernel_bug_known@general protection fault:@update_shares
kernel_bug_known@kernel BUG at fs/jbd/commit.c@journal_commit_transaction
kernel_bug_known@kernel BUG at fs/jbd2/commit.c@jbd2_journal_commit_transaction
kernel_bug_known@unable to handle kernel NULL pointer@lookup_user_key
kernel_bug_known@BUG: soft lockup - CPU@_spin_lock
kernel_bug_known@unable to handle kernel NULL pointer@tcp_fastretrans_alert
###################### End Kernel Bug Info Data ####################
#1 message
#2 key word
###################### Ipmi Event Data #######################
Hardware Error:PCIe error@Critical Interrupt #0x8c | Bus Fatal Error
Hardware Error: maybe memory error@Processor #0xfa | Configuration Error
manual shutdown@System ACPI Power State #0xc1 | S4/S5: soft-off
Hardware Error:Unknown@Unknown #0xcb
Hardware Error:Processor IERR@Processor #0x0f | IERR
#################### End Ipmi Event Data #######################
######################### End Checking Data ##############################
######################## Check Report Html Head ###########################
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OS check report</title>
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
    <script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <style type="text/css">

        header, nav, article, footer {
            border-style: outset;
            border-width: 1px;
            border-color:rgba(34, 74, 158, 0.3);
        }
        header {
            width: 100%;
        }
        nav {
            float: left;
            width: 15%;
            height: 800px;
        }
        article {
            float: left;
            width: 85%;
            height: 800px;
        }
        footer {
            clear: both;
            width: 100%;
        }
        tr.tr_top th{line-height:40px;border:none;background-color:rgba(34, 74, 158, 0.4);color:rgb(255,255,255);font-weight:bold;}
        .table tbody tr td{
            vertical-align: middle;
        }
        pre{
            background-color:#E6F0FE;
            color: rgba(19,107,230,0.6)
        }
        code{
            font-family:Microsoft yahei;
            font-size:16px;
        }
        h4{
            font-family:Microsoft yahei;
            color:rgba(19,107,230,0.8)
        }
        body{
            background-color:#E6F0FE;
        }
        .even_line{
        background-color:rgba(207,215,232,0.4);
            text-align:center;
        }
        .odd_line{
            text-align:center;
        }
        @-webkit-keyframes move{
            0%{left:-1800px;}
            100%{left:0px;}
        }

        #wrap{
            height: 34px;
            margin-top: 0px;
            margin-bottom: 0px;
            border:1px solid #000;
            position:relative;
            margin:100px auto;
            overflow: hidden;
        }

        #list{
            width:800%;
            position:absolute;left:0;top:0;padding:0;margin:0;
            -webkit-animation:40s move infinite linear;}

        #list li{
            list-style:none;
            width:380px;
            height: 32px;
            border:1px solid rgba(19,107,230,0.5);
            /*background: rgba(34, 74, 158, 0.4) ;*/
            color:rgba(19,107,230,0.8);
            text-align: center;
            float:left;
            font-family:Microsoft yahei;
            line-height:27px;
        }

       #wrap:hover #list{
        -webkit-animation-play-state:paused;
        }
    </style>
</head>
<body>
    <header>
        <h2 align="center" style="font-family:Microsoft yahei;color:rgba(19, 107, 230,0.8);margin-top: 10px">日志检测报告</h2>
    </header>
    <nav style="overflow:auto;">
        <h4 id="introduce_show"><a href="#">&nbsp;1.功能介绍</a></h4>
        <h4 id="system_show"><a href="#">&nbsp;2.系统信息</a></h4>
        <h4 id="system_monitor_show"><a href="#">&nbsp;3.系统负载分析</a></h4>
        <h4 id="check_report_show"><a href="#">&nbsp;4.日志检测报告</a></h4>
    </nav>
    <article style="overflow:auto;border-right-width: 7px;">
        <pre id="introduce_data"><code style="font-family:Microsoft yahei;font-size:16px;">系统日志收集与分析工具，主要包括以下几个部分：
1. 收集系统信息、网络信息、磁盘信息、硬件信息等。
2. 分析并检查日志，判断是否否符合标准。
3. 生成报告。

遇到问题请联系相关人员:
        OS/OPS     :                     丁嘉龙,崔学婷
        天基/天目   :                     贾振兵,公丕斌
        VPC/SLB    :                     景利婷,刘新龙
        </code></pre>
######################## End Check Report Html Head ###########################
######################## Check Report Html Article ###########################
        <div class="bs-example" id="check_report_data" style="display:none" data-example-id="bordered-table">
            <table class="table table-bordered" name="check_report_table"  style="word-break:break-all; word-wrap:break-all;">
                <thead>
                    <tr class="tr_top" height="60px">
                        <th width="10%" style="text-align: center;vertical-align: middle">序号</th>
                        <th width="20%" style="text-align: center;vertical-align: middle">Collection items</th>
                        <th width="25%" style="text-align: center;vertical-align: middle">Check status</th>
                        <th width="25%" style="text-align: center;vertical-align: middle">Investigation reason</th>
                        <th width="20%" style="text-align: center;vertical-align: middle">Log detail</th>
                    </tr>
                </thead>
                <tbody id="line_color_change">
######################## End Check Report Html Article ###########################
####################### Check Report Html Tail ###########################
                </tbody>
            </table>
        </div>
    </article>
    <footer>
        <div id="wrap" style="margin-top: 0px;margin-bottom: 0px;">
            <ul id="list">
                <li>遇到问题请联系相关人员: </li>
                <li>OS/OPS    :             丁嘉龙,崔学婷</li>
                <li>天基/天目 :             贾振兵,公丕斌</li>
                <li>VPC/SLB   :             刘新龙,景利婷</li>
                <li>遇到问题请联系相关人员: </li>
                <li>OS/OPS    :             丁嘉龙,崔学婷</li>
                <li>天基/天目 :             贾振兵,公丕斌</li>
                <li>VPC/SLB   :             刘新龙,景利婷</li>
            </ul>
        </div>
    </footer>
</body>
</html>
<script type="text/javascript">

$("#introduce_show").click(function(){
    $("#introduce_data").show()
    $("#system_data").hide()
    $("#system_monitor_data").hide()
    $("#check_report_data").hide()
});

$("#system_show").click(function(){
    $("#introduce_data").hide()
    $("#system_data").show()
    $("#system_monitor_data").hide()
    $("#check_report_data").hide()
});

$("#system_monitor_show").click(function(){
    $("#introduce_data").hide()
    $("#system_data").hide()
    $("#system_monitor_data").show()
    $("#check_report_data").hide()
});

$("#check_report_show").click(function(){
    $("#introduce_data").hide()
    $("#system_data").hide()
    $("#system_monitor_data").hide()
    $("#check_report_data").show()
});

$("#wrap").click(function(){
    $("#introduce_data").show()
    $("#system_data").hide()
    $("#system_monitor_data").hide()
    $("#check_report_data").hide()

});

function makeSortable(table) {
    var headers=table.getElementsByTagName("th");
    for(var i=0;i<headers.length;i++){
        (function(n){
            var flag=false;
            headers[n].onclick=function(){
                var tbody=table.tBodies[0];
                var rows=tbody.getElementsByTagName("tr");
                rows=Array.prototype.slice.call(rows,0);
                rows.sort(function(row1,row2){
                    var cell1=row1.getElementsByTagName("td")[n];
                    var cell2=row2.getElementsByTagName("td")[n];
                    var val1=cell1.textContent||cell1.innerText;
                    var val2=cell2.textContent||cell2.innerText;

                    if(val1<val2){
                        return -1;
                    }else if(val1>val2){
                        return 1;
                    }else{
                        return 0;
                    }
                });
                if(flag){
                    rows.reverse();
                }
                for(var i=0;i<rows.length;i++){
                    tbody.appendChild(rows[i]);
                }
                flag=!flag;
                td_color_change();
                summary_cpu_process_check_info();
            }
        }(i));
    }
}
function td_color_change(){
    var oTable = document.getElementById("line_color_change");
    for(var i=0;i<oTable.rows.length;i++){
        oTable.rows[i].cells[0].innerHTML = (i+1);
        if(i%2==0){
        oTable.rows[i].className = "even_line";
        }
        else{
        oTable.rows[i].className = "odd_line";
        }
    }
}

function summary_cpu_process_check_info(){
    var oTable = document.getElementById("summary_process_line_color");
    for(var i=0;i<oTable.rows.length;i++){
        if(i%2==0){
        oTable.rows[i].className = "even_line";
        }
        else{
        oTable.rows[i].className = "odd_line";
        }
    }
}

function sortNumberAS(a, b)
{
    return a-b
}
function sortNumberDesc(a, b)
{
    return b-a
}

function ProcessCountSort(obj){
    var td0s=document.getElementsByName("td0");
    var td1s=document.getElementsByName("td1");
    var td2s=document.getElementsByName("td2");
    var td3s=document.getElementsByName("td3");
    var td4s=document.getElementsByName("td4");
    var td5s=document.getElementsByName("td5");
    var tdArray0=[];
    var tdArray1=[];
    var tdArray2=[];
    var tdArray3=[];
    var tdArray4=[];
    var tdArray5=[];
    for(var i=0;i<td0s.length;i++){
        tdArray0.push(td0s[i].innerHTML);
    }
    for(var i=0;i<td1s.length;i++){
        tdArray1.push(parseInt(td1s[i].innerHTML));
    }
    for(var i=0;i<td2s.length;i++){
        tdArray2.push(td2s[i].innerHTML);
    }
    for(var i=0;i<td3s.length;i++){
        tdArray3.push(td3s[i].innerHTML);
    }
    for(var i=0;i<td4s.length;i++){
        tdArray4.push(td4s[i].innerHTML);
    }
    for(var i=0;i<td5s.length;i++){
        tdArray5.push(td5s[i].innerHTML);
    }
    var tds=document.getElementsByName("td"+obj.id.substr(2,1));
    var columnArray=[];
    for(var i=0;i<tds.length;i++){
        columnArray.push(parseInt(tds[i].innerHTML));
    }
    var orginArray=[];
    for(var i=0;i<columnArray.length;i++){
        orginArray.push(columnArray[i]);
    }
    if(obj.className=="as"){
        columnArray.sort(sortNumberAS);
        obj.className="desc";
    }
    else{
        columnArray.sort(sortNumberDesc);
        obj.className="as";
    }
    for(var i=0;i<columnArray.length;i++){
        for(var j=0;j<orginArray.length;j++){
            if(orginArray[j]==columnArray[i]){
                document.getElementsByName("td0")[i].innerHTML=tdArray0[j];
                document.getElementsByName("td1")[i].innerHTML=tdArray1[j];
                document.getElementsByName("td2")[i].innerHTML=tdArray2[j];
                document.getElementsByName("td3")[i].innerHTML=tdArray3[j];
                document.getElementsByName("td4")[i].innerHTML=tdArray4[j];
                document.getElementsByName("td5")[i].innerHTML=tdArray5[j];
                orginArray[j]=null;
                break;
            }
        }
    }
}

window.onload=function(){
    td_color_change();
    summary_cpu_process_check_info();
    var check_report_table=document.getElementsByName("check_report_table")[0];
    makeSortable(check_report_table);
}
</script>
###################### End Check Report Html Tail ########################
######################## End Main Info Data ##########################
