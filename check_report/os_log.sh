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
WORKDIR="crash_log.$LOGDATE"
SLOGDIR="/var/log"
LOCK_FILE=""
DATA_FILE="/tmp/data_file.$LOGDATE"
LOGDIR=""
SCOPE_TYPE=""

list_items=0
target_cmd=""
target_type=""
target_scope=2
checking=0
syslog_tgz=""
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
    eval $check_fun "$log" >> "${log}_check" 2>&1
    result $?

    [ "$fix_fun" = "" ] && return
    msg "Fixing: ${cmd:0:60}"
    eval $fix_fun "$log" >> "${log}_fix" 2>&1
    result $?
}

cleanup()
{
    rm -f "$LOCK_FILE"
    rm -f "$DATA_FILE"
    [ "$LOGDIR" != "/" ] && rm --preserve-root -rf "$LOGDIR"
}
check_single_instance()
{
    if [ -f $LOCK_FILE ];then
        info ""
        error "Another $(basename $0) is running, please waiting it finish and then retry !"
    fi
    touch "$LOCK_FILE"
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
prepare_to_run()
{
    export LANG=C
    LOCK_FILE="${SLOGDIR}/${WORKDIR}.pid"
    LOGDIR="${SLOGDIR}/${WORKDIR}"

    rm -rf $LOGDIR
    if [ "$syslog_tgz" != "" ];then
        local tarball=$(basename $syslog_tgz)
        LOGDIR=${SLOGDIR}/${tarball%.tar.gz}
        rm -rf $LOGDIR
        info "Start uncompress $syslog_tgz to $SLOGDIR ..."
        tar -zxf $syslog_tgz -C $SLOGDIR
        [ $? -ne 0 ] && error "Uncompress $syslog_tgz failed, exit ..."
    fi
    mkdir -p $LOGDIR

    case $SCOPE_TYPE in
        'all')
            target_scope=3;;
        'small')
            target_scope=1;;
        *)
            target_scope=2;;
    esac
}
free_space_check()
{
    local dir=$1
    local target=$2

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

    info "$raid_type"
    case $raid_type in
        "megaraidsas")   get_megaraidsas_log "$logdir";;
        "hpraid")        get_hpraid_log "$logdir";;
        "megaraidscsi")  get_megaraidscsi_log "$logdir";;
        "mptsas")        get_mptsas_log "$logdir";;
        "aacraid")       get_aacraid_log "$logdir";;
        "mpt2sas")       get_mpt2sas_log "$logdir";;
        *) info "Can't find any raid type ...";;
    esac
}
get_disk_info()
{
    local log_temp=$1
    local disks=$(cd /dev/ && ls sd* | grep -v [1-9])
    local debugfs=$(cat /proc/mounts | grep -ic debugfs)

    ls -l /dev/sd*
    for disk in $disks
    do
        smartctl -a /dev/$disk >> "${log_temp}_$disk"
        parted /dev/$disk print >> "${log_temp}_$disk"
        cat /sys/block/$disk/queue/scheduler >> "${log_temp}_$disk"
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
    done
}

compress_log()
{
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
    echo "System:    $(cat /etc/redhat-release)"
    echo "Hostname:  $(hostname -f)"
    echo "Kernel:    $(uname -r)"
    echo "Arch:      $(uname -i)"
    echo "Product:   $(dmidecode -s system-product-name)"
}
copy_files()
{
    local src=$1
    local dst=$2
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

    ps -e -wwo 'pid,comm,psr,pmem,rsz,vsz,stime,user,stat,uid,args' --sort rsz >> $file

    local top10_mem=$(tail -10 $file | awk '{print $1}')
    
    get_top10_process_info "$top10_mem" "$dir"
}
get_top10_cpu_process_info()
{
    local file=$1
    local dir=$(dirname $file)

    ps -e -wwo 'pid,comm,psr,pcpu,rsz,vsz,stime,user,stat,uid,args' --sort pcpu >> $file

    local top10_cpu=$(tail -10 $file | awk '{print $1}')
    get_top10_process_info "$top10_cpu" "$dir"
}
copy_system_files()
{
    local dir=$(dirname $1)
    copy_files "/var/log/kern" "$dir/"
    copy_files "/var/log/messages" "$dir/"
    #copy_files "/var/log/sa/" "$dir"
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
    [ $status -ne 0 ] && res=$warn
    return $res
}
check_disk_size()
{
    local log_file=$1
    local res=$success

    for item in $(cat $log_file | awk '{print $5}' | sed '2d' | sed 's/%//g')
    do
        [ $item -ge 80 ] && res=$warn
        [ $item -ge 95 ] && res=$fail
    done
    [ $res -ne $success ] && info "Please check $log_file for disk usage !"
    return $res
}
check_free_memory()
{
    local log_file=$1
    local res=$success
    local total=$(cat $log_file | grep Mem | awk '{print $2}')
    local used=$(cat $log_file | grep buffers/cache | awk '{print $3}')
    is_el7 && local used=$(($(cat $log_file | grep Mem | awk '{print $2}')-$(cat $log_file | grep Mem | awk '{print $NF}')))
    local used_percentage=$((${used}*100/${total}))
    [[ ${used_percentage} -ge 80 ]] && res=$warn
    [[ ${used_percentage} -ge 90 ]] && res=$fail
    return $res
}
check_process_status()
{
    local log_file=$1
    local res=$success
    local num_D=$(awk '{print $9}' $log_file | grep -c 'D')
    local num_Z=$(awk '{print $9}' $log_file | grep -c 'Z')
    local total=$(($num_D + $num_Z))
    echo "total=${total}"
    [ $total -ge 100 ] && res=$warn
    [ $total -ge 200 ] && res=$fail
    return $res
}
check_system_load()
{
    local log_file=$1
    local res=$success
    local average_data=$(grep -w 'average' $log_file | sed "s/,//g")
    local one_minutes_average=$(printf "%.0f" $(echo ${average_data} | awk '{print $10}'))
    local five_minutes_average=$(printf "%.0f" $(echo ${average_data} | awk '{print $11}'))
    local fifteen_minutes_average=$(printf "%.0f" $(echo ${average_data} | awk '{print $12}'))
    [ $one_minutes_average -ge 100 ] && res=$warn
    [ $five_minutes_average -ge 80 ] && res=$warn
    [ $fifteen_minutes_average -ge 50 ] && res=$warn
    [ $one_minutes_average -ge 150 ] && res=$fail
    [ $five_minutes_average -ge 120 ] && res=$fail
    [ $fifteen_minutes_average -ge 100 ] && res=$fail
    return $res
}
check_filesystems()
{
    local log_file=$1
    local res=$success
    local status=$(cat $log_file | grep -wc "ro")
    [[ $status -ne 0  ]] && res=$fail
    return $res

}
check_kdump_status()
{
    local log_file=$1
    local res=$fail
    local status=$(cat $log_file | grep -wc "not")
    [[ $status -eq 0  ]] && res=$success
    return $res
}
check_kdump_config()
{
    local log_file=$1
    local res=$fail
    local device=$(df -lh /var | tail -1 | awk '{print $1}')
    local filesystem=$(mount|grep -w $device|awk '{print $(NF-1)}')
    local first_line="$device $filesystem"
    local second_line="path /var/crash"
    local third_line_el5="core_collector makedumpfile -c --message-level 1 -d 1"
    local third_line_el6_or_el7="core_collector makedumpfile -c --message-level 1 -d 31"
    local fourly_line="extra_modules mpt2sas mpt3sas megaraid_sas hpsa ahci"
    local five_line="default reboot"
    third_line=$third_line_el6_or_el7
    is_el5 && thirdline=$third_line_el5
    [[ $(awk 'NR==1{print $1}' /etc/kdump.conf) == "$filesystem"  ]] && \
    [[ $(awk 'NR==1{print $2}' /etc/kdump.conf) == "$device"  ]] && \
    [[ $(awk 'NR==2{print}' /etc/kdump.conf) == "$second_line"  ]] && \
    [[ $(awk 'NR==3{print}' /etc/kdump.conf) == "$third_line"  ]] && \
    [[ $(awk 'NR==4{print}' /etc/kdump.conf) == "$fourly_line"  ]] && \
    [[ $(awk 'NR==5{print}' /etc/kdump.conf) == "$five_line"  ]] && \
    res=$success
    return $res
}
check_conman_config()
{
    local log_file=$1
    local res=$success
    is_el5 && local status=$(grep -wc crashkernel=[0-9]*M@[0-9]*M ${log_file})
    is_el6 && local status=$(grep -wc crashkernel=256M ${log_file})
    is_el7 && local status=$(grep -wc crashkernel=auto ${log_file})
    [[ ${status} -eq 0 ]] && res=$fail
    return $res
}
check_io_utilize()
{
    local log_file=$1
    local res=$success
    local util_index=$(awk '{for(i=1;i<=NF;i++)if($i ~ /'^%util$'/) print i }' $log_file | head -1)
    local iowait_index=$(awk '{for(i=1;i<=NF;i++)if($i ~ /'^%iowait$'/) print i }' $log_file | head -1)
    local iowait_data=$(awk '$'${util_index}'=="" {print $0}' $log_file | grep  -v '^[A-Za-z]+*' | awk '{print $'$((${iowait_index}-1))'}')
    local iowait_total=0
    for num in $iowait_data; do iowait_total=$(awk 'BEGIN{print '${iowait_total}'+'${num}'}') ; done
    local iowait_average_6=$(printf '%.0f' $(awk 'BEGIN{print '${iowait_total}'/6}'))
    [ $iowait_average_6 -ge 100  ] && res=$warn
    local util_data=$(awk  '$'${util_index}'!="" {print $0}' $log_file | grep -v 'Device:')
    local devic_num=$(($(echo "$util_data" | wc -l)/6))
    for devic in $(seq ${devic_num})
    do
        local devic_name=$(echo "$util_data" | awk 'NR=='${devic}' {print $1}')
        local devic_io_data=$(grep -w "$devic_name" $log_file | awk '{print $'${util_index}'}')
        local total=0
        for num in $devic_io_data; do total=$(awk 'BEGIN{print '${total}'+'${num}' }') ; done
        local devic_io_average_6=$(printf '%.0f' $(awk 'BEGIN{print '${total}'/6}'))
        [ $devic_io_average_6 -ge 80 ] && res=$warn
        [ $devic_io_average_6 -ge 100 ] && res=$fail && break  
    done 
    [ $iowait_average_6 -ge 200  ] && res=$fail
    return $res
}
kernel_bug()
{
    local confirm=$1
    local key=$2
    local info="kernel bug: $key"
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
    echo "Please refer to http://os.alibaba-inc.com/osbasebuginfo_list/" 
}
confirm_bug()
{
    local line=$1
    local msg=$2
    local logfile=$3
    local bug=$4
    local confirm=1

    [ $bug -eq 0 ] && return 0

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
    local confirm=0
    local info_type="Kernel Bug Info Data"
    local info_data=$(sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#') 
    while read line
    do
        local action_fun=$(echo $line | awk -F "@" '{print $1}')
        local master_msg=$(echo $line | awk -F "@" '{print $2}')
        local bug=$(grep -ic "$master_msg" $logfile)

        confirm_bug "$line" "$master_msg" "$logfile" $bug
        confirm=$?

        if [[ $bug -ne 0 ]]
        then
            eval "$action_fun" $confirm "$master_msg"
            res=$fail
        fi
    done<<<"$info_data"

    return $res
}
check_system_log()
{
    local log_file=$1
    local log_dir=$(dirname $log_file)
    kernel_error_message "${log_dir}/kern"
    [ $? -eq $success ] && kernel_error_message "${log_dir}/messages"
    return $?
}
check_dmesg()
{
    local log_file=$1
    kernel_error_message $log_file
    return $?
}

check_openfiles()
{
    local log_file=$1
    local res=$success
    local status=$(cat ${log_file} | grep -Fc '(deleted)')
    [[ $status -ne 0 ]] && res=$warn
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
            local LinkState=$(cat ${log_dir}/${device}/operstate)
            local DuplexMode=$(cat ${log_dir}/${device}/duplex)
            [ "$LinkState" != "up" ] || [ "$DuplexMode" != "full" ] && res=$fail
        fi
    done
    return $res
}

check_dockers()
{
    local log=$1
    local log_dir=$(dirname $1)
    local res=$success
    local dockers=$(cat ${log} | awk  '{print $1}' | grep -iv "Command:" | grep -iv "CONTAINER") 
    for docker in ${dockers}
    do
        local docker_path="${log_dir}/${docker}"
        local total=$(cat "$docker_path/free_m" | grep 'Mem' | awk '{print $2}')
        local used=$(cat "$docker_path/free_m" | grep buffers/cache | awk '{print $3}')
        local is_el5_6_status=$(cat "$docker_path/free_m" | grep -Fc "/+ buffers/cache")
        [ $is_el5_6_status -eq 0 ] && used=$(($(cat "$docker_path/free_m" | grep 'Mem' | awk '{print $2}')-$(cat "$docker_path/free_m" | grep 'Mem' | awk '{print $NF}')))
        local used_percentage=$((${used}*100/${total}))
        [ ${used_percentage} -ge 85 ] && res=$warn
        [ ${used_percentage} -ge 90 ] && res=$fail 
        [ $res -ne $success ] && info "Docker: $docker, Mem total: $total, used: $used"
    done
    return $res
}
check_abnormal_packets()
{
    local log_file=$1
    local res=$success
    local rx_tx_info=$(egrep -w "RX|TX" $log_file | grep -w errors | awk -F "errors" '{print $2}' | sed "s/:/ /g")
    local flag_num=$(echo "$rx_tx_info" | wc -l)
    local errors_ok_num=$(echo "$rx_tx_info" | awk '{print $1}'| grep -wc 0)
    local dropped_ok_num=$(echo "$rx_tx_info" | awk '{print $3}' | grep -wc 0)
    local carrier_ok_num=$(echo "$rx_tx_info" | grep -w carrier | awk '{print $7}' | grep -wc 0)
    [ $dropped_ok_num -ne $flag_num ] && res=$warn
    [ $carrier_ok_num -ne $(($flag_num/2)) ] && res=$warn
    [ $errors_ok_num -ne $flag_num ] && res=$fail
    return $res
}
check_bonding()
{
    local log=$1
    local log_dir=$(dirname $log)
    local bonds=$(ls -ld ${log_dir}/*/ | awk '{print $9}' | awk -F / '{print $6}')

    for bond in $bonds
    do
        local bonding_dir="${log_dir}/${bond}"
        local bonding_log="$bonding_dir/cat_$bond"
        [ ! -e $bonding_log ] && continue
        local SLAVE_flag=$(grep -c "MII Status" "$bonding_log")
        local UP_flag=$(grep -v "Duplex" "$bonding_log" | grep -c "up")
        local LACP_flag=$(grep -c "LACP" "$bonding_log")
        [ $LACP_flag -ne 1 ] || [ $SLAVE_flag -ne $UP_flag ] && return $fail
    done
    return $success
}
check_alimonitor_syslog()
{
    local log_file=$1
    local flag=$(grep "collection_flag" $log_file|grep -c "0")
    local status=$(grep -c "OK" $log_file)
    if [ $flag -eq 1 ] && [ $status -eq 5 ]
    then
        return $success
    else
        return $fail
    fi
}
check_alimonitor_hardward()
{
    local log_file=$1
    local flag=$(grep "collection_flag" $log_file|grep -c "0")
    local status=$(grep -c "OK" $log_file)
    if [ $flag -eq 1 ] && [ $status -eq 1 ]
    then
        return $success
    else
        return $fail
    fi
}
check_raid_card()
{
    local typefile=$1
    local logdir=$(dirname $typefile)
    local raid_type=$(cat $typefile|tail -2|head -1)
    case $raid_type in
        hpraid);;
        megaraidsas)
            local cfg_logfile="$logdir/$raid_type/cfgdsply.log"
            local pdld_logfile="$logdir/$raid_type/ldpdinfo.log"
            local vds=$(grep "Number of DISK GROUPS" $cfg_logfile|awk '{print $5}')
            local optimal_count=$(grep "^State" $cfg_logfile|grep -c "Optimal")
            local pds=$(grep -v "Physical Disk Information" $cfg_logfile|grep -c "Physical Disk")
            local media_error_count=$(grep "Media Error Count" $cfg_logfile|awk '{sum += $4};END {print sum}')
            local other_error_count=$(grep "Other Error Count" $cfg_logfile|awk '{sum += $4};END {print sum}')
            local predictive_failure_count=$(grep "Predictive Failure Count" $cfg_logfile|awk '{sum += $4};END {print sum}')
            local firmware_state=$(grep -c "Online, Spun Up" $cfg_logfile)
            [ $optimal_count -lt $vds ] && return $fail 
            [ $firmware_state -lt $pds ] && return $fail
            [ $media_error_count -gt 0 ] || [ $other_error_count -gt 0 ] || [ $predictive_failure_count -gt 0 ] && return $warn
            ;;
        mpt2sas);;
        *);;
    esac
    return $success
}
list_flags()
{
    local type_pattern="Type Data"

    info ""
    sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $0 | grep -v '#' | while read typeline
    do
        local info_type=$(echo $typeline | awk -F: '{print $1}')
        echo "Type: $info_type"
        sed -n "/## $info_type ##/,/## End $info_type ##/"p $0 | grep -v '#' | while read line
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
        local info_output=$(echo $typeline | awk -F: '{print $3}')
        local full_path="${LOGDIR}/$info_dir"
        
        [ "$target_type" != "" ] && [ "$target_type" != "$info_type" ] && continue
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

start_checking()
{
    local type_pattern="Type Data"
    [ $checking -eq 0 ] && return
    sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#' | while read typeline
    do
        local info_type=$(echo $typeline | awk -F: '{print $1}')
        local info_dir=$(echo $typeline | awk -F: '{print $2}')
        local info_output=$(echo $typeline | awk -F: '{print $3}')
        local full_path="${LOGDIR}/$info_dir"

        checking_items "$info_type" "$info_output" "$full_path"
    done | tee -a "${LOGDIR}/checking_output"
}
make_check_report()
{
    [ $checking -eq 0 ] && return	
	local type_pattern="Type Data"
	local n=1
	local report_data=""
	local type_data=$(sed -n "/## $type_pattern ##/,/## End $type_pattern ##/"p $DATA_FILE | grep -v '#')
	while read typeline
	do
		local info_type=$(echo $typeline | awk -F : '{print $1}')
		local info_dir=$(echo $typeline | awk -F : '{print $2}')
		local full_path="${LOGDIR}/$info_dir"
		echo "info_type--------------------${info_type}"	

	    local item_data=$(sed -n "/## $info_type ##/,/## End $info_type ##/"p $DATA_FILE | grep -v '#') 
		echo "item_data===================${item_data}"
		
		while read line
    	do
        	local cmd=$(echo $line | awk -F: '{print $2}')
			echo "cmd============================>${cmd}"
        	local filename=$(echo $line | awk -F: '{print $4}')
			local collect_log="${full_path}/${filename}"
        	local check_log="${full_path}/${filename}_check"
			#echo "cmd----------------->${cmd}   collect_log------------>${collect_log}       check_log--------------------->${check_log}"
			[ ! -e "$check_log" ] && continue 
			local check_result_reson=$(cat $check_log 2>/dev/null | head -1)
			local check_status=$(cat $check_log 2>/dev/null | head -1)
			local collect_log_data=$(cat $collect_log | awk '{print $0 "<br>"}')
	#		#echo "check_result_reson----------------->$check_result_reson       check_status-------------------->${check_status}"		
 
		    local check_item=" 
	    <tr>
         <th scope=\"row\">${n}</th>
         <td>${cmd}</td>
         <td>${check_status}</td>
         <td>${check_result_reson}</td>
         <td><button type=\"button\" class=\"btn btn-success\" onclick = \"document.getElementById('light${n}').style.display='block';document.getElementById('fade${n}').style.display='block'\">detail </button></td>
         <div id=\"light${n}\" class=\"white_content\">
             <button type=\"button\" class=\"btn btn-success\"  onclick = \"document.getElementById('light${n}').style.display='none';document.getElementById('fade${n}').style.display='none'\">返回</button>
             <br>
${collect_log_data}
         </div> 
         <div id=\"fade${n}\" class=\"black_overlay\"></div> 
     	</tr>"

			report_data="$report_data""${check_item}"
			n=$(($n+1))

    	done <<< "$item_data"	

	done <<< "${type_data}"
	
	echo "n==============${n}"	
	echo "===============================================>${report_data}"


	local html_info="<!DOCTYPE html>
<html lang=\"zh-CN\">
  <head>
	<meta charset=\"utf-8\">
	<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
	<title>OS check report</title>
	<script src=\"https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js\"></script>
	<script src=\"https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js\"></script>
	<script src=\"https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js\"></script>
	<link rel=\"stylesheet\" href=\"https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css\">
	<link rel=\"stylesheet\" href=\"https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap-theme.min.css\" >
	<style> 
		.black_overlay{ 
			display: none; 
			position: absolute; 
			top: 0%; 
			left: 0%; 
			width: 100%; 
			height: 100%; 
			background-color: black; 
			z-index:1001; 
			-moz-opacity: 0.8; 
			opacity:.80; 
			filter: alpha(opacity=88); 
		} 
		.white_content { 
			display: none; 
			position: absolute; 
			top: 25%; 
			left: 25%; 
			width: 55%; 
			height: 55%; 
			padding: 20px; 
			border: 10px solid orange; 
			background-color: white; 
			z-index:1002; 
			overflow: auto; 
		} 
	</style> 
	 
  </head>
  <body>
	<h1>你好，帅哥！</h1>

	<div class=\"bs-example\" data-example-id=\"bordered-table\">
	<table class=\"table table-bordered\">
	  <thead>
		<tr>
		  <th>index</th>
		  <th>Collection cmd</th>
		  <th>Check status</th>
		  <th>Investigation reason</th>
		  <th>Log detail</th>
		</tr>
	  </thead>
	  <tbody>
		${report_data}
	  </tbody>
	</table>
	</div>
  </body>
</html>
"
	echo "$html_info" > "${LOGDIR}"/check_report.html
}
start_collection_and_check()
{
    [ "$syslog_tgz" = "" ] && start_collection
    start_checking && make_check_report
	
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
        $(basename $0) -c                     Check system environment or check system log.
        $(basename $0) -f <log file>          Check system by log file, need parameter -c.
        $(basename $0) -l                     Just list items out.
    Example:
        $(basename $0) -d /apsara -s all
        $(basename $0) -s small
        $(basename $0) -c -f ./crash_log.2017-09-01-15-23-57.tar.gz
        $(basename $0) -i disks_io_detail
EOF
    exit 1
}
while getopts d:t:f:i:achlV OPTION
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
        l) list_items=1;;
        *) usage;;
    esac
done

show_system_info
prepare_to_run
trap cleanup EXIT
generate_data_file
free_space_check "$LOGDIR" 5
check_single_instance
start_collection_and_check
compress_log
exit 0
############################# End Main ##############################

########################## Main Info Data ############################
########################## Collection Data ############################
############################# Type Data ############################
#Info Type:logdir:description
System Info Data:system_info:system information ...
Network Info Data:network_info:network information ...
BMC Info Data:bmc_info:bmc information ...
Dom0 Info Data:dom0_info:dom0 information ...
Disk Info Data:disk_info:disk information ...
########################### End Type Data ##########################

#flag:collect_function:action:filename:scope:analysis_function:fix_function

#flag make sure it is unique
#action include:
# check <-- check if command exist, default to check
# path  <-- send target path to command

#filename is log file name.
#scope include 1(small), 2(normal) and 3(all).
########################## System Info Data ###########################
hwconfig:hwconfig::hwconfig:2::
history:cat $HOME/.bash_history::history:2:check_user_behavior:
uname:uname -a::uname_a:2::
df:df -h::df_h:2:check_disk_size:
free:free -m::free_m:2:check_free_memory:
ps:ps -Le -wwo 'pid,psr,pcpu,pmem,rsz,vsz,stime,user,stat,uid,wchan=WIDE-WCHAN-COLUMN,args' --sort rsz::ps_Le_wwo_rsz:2:check_process_status:
last:last reboot::last_reboot:2::
chkconfig:chkconfig --list::chkconfig__list:2::
runlevel:runlevel::runlevel:2::
uptime:uptime::uptime:2:check_system_load:
mount:mount::mount:2::
cat_mount:cat /proc/mounts::cat_mount:2:check_filesystems:
top_thread:top -H -b -n 1::top_H_b:2::
top:top -b -n 1::top_b:2::
kdump:/etc/init.d/kdump status::kdump_status:2:check_kdump_status:
kdump_conf:cat /etc/kdump.conf::kdump_conf:2:check_kdump_config:
lsmod:lsmod::lsmod:2::
cmdline:cat /proc/cmdline::cat_proc_cmdline:2:check_conman_config:
meminfo:cat /proc/meminfo::cat_proc_meminfo:2::
slabinfo:cat /proc/slabinfo::cat_proc_slabinfo:2::
vmallocinfo:cat /proc/vmallocinfo::cat_vmallocinfo:2::
swaps:cat /proc/swaps::cat_proc_swaps:2::
cpuinfo:cat /proc/cpuinfo::cat_proc_cpuinfo:2::
dmidecode:dmidecode::dmidecode:2::
dmesg:dmesg::dmesg:2:check_dmesg:
ulimit:ulimit -a::ulimit_a:2::
crontab:crontab -l::crontab_l:2::
mpstat:mpstat -P ALL 1 6::mpstat_P:2::
iostat:iostat -xm 1 6::iostat_xm:2:check_io_utilize:
vmstat:vmstat 1 6::vmstat:2::
tsar:tsar -n 6:check:tsar_n6:2::
blkid:blkid::blkid:2::
lsscsi:lsscsi::lsscsi:2::
mdadm:mdadm --detail::mdadm__detail:2::
lvs_detail:lvs -vv::lvs_vv:2::
lvs:lvs -v::lvs_v:2::
vgs:vgs::vgs:2::
pvs:pvs::pvs:2::
lsof:lsof::lsof:2:check_openfiles:
journalctl:journalctl -xn:check:journalctl_xn:2::
cp_system_files:copy_system_files:path:copy_system_files:2:check_system_log:
cp_other_files:copy_other_files:path:copy_other_files:3::
top10_mem:get_top10_mem_process_info:path:top_mem_order:2::
top10_cpu:get_top10_cpu_process_info:path:top_cpu_order:2::
######################### End System Info Data ########################
######################## Network Info Data ###########################
sarnet:sar -n DEV 1 6::sar_n_dev:2::
ss:ss -anpei::ss_anpei:3::
ifstat:ifstat -a 1 6::ifstat_a:2::
ipaddr:ip addr show::ip_addr_show:2::
iproute:ip route show::ip_route_show:2::
ifconfig:ifconfig::ifconfig:2:check_abnormal_packets:
ifconfig_all:ifconfig -a::ifconfig_a:2::
route_cache:route -Cn::route_Cn:2::
route:route -n::route_n:2::
netstat:netstat -anpo::netstat_anpo:2:check_tcp_status:
netstat_pro:netstat -s::netstat_s:2::
netstat_dev:netstat -i::netstat_i:2:check_send_receive_err:
bonding_info:get_bonding_info:path:bonding_info:2:check_bonding:
netcard_info:get_netcard_info:path:netcard_info:2:check_netcard:
###################### End Network Info Data #########################
########################## BMC Info Data #######################
ipmifru:ipmitool fru list::ipmitool_fru_list:2::
ipmilan:ipmitool lan print 1::ipmitool_lan_print_1:2::
ipmimc:ipmitool mc info::ipmitool_mc_info:2::
ipmisensor:ipmitool sensor list::ipmitool_sensor_list:2:check_ipmi_sensor:
ipmisdr:ipmitool sdr list::ipmitool_sdr_list:2:check_ipmi_sdr:
ipmisel:ipmitool sel elist::ipmitool_sel_elist:2::
######################## End BMC Info Data #####################
########################## Dom0 Info Data ######################
docker_info:get_docker_info:path:docker_info:2:check_dockers:
######################## End Dom0 Info Data ####################
############################ Disk Info Data ####################
disks_io_detail:get_disks_io_detail:path:disks_io_detail:3::
disk_info:get_disk_info:path:disk_info:2::
raid_info:get_raid_log:path:raid_type:2:check_raid_card:
check_syslog:/usr/alisys/dragoon/libexec/alimonitor/independent_domain_check_syslog:check:independent_domain_check_syslog:2:check_alimonitor_syslog:
check_hardware:/usr/alisys/dragoon/libexec/alimonitor/independent_domain_check_hardware:check:independent_domain_check_hardware:2:check_alimonitor_hardward
########################## End Disk Info Data #####################
######################## End Collection Data ##########################

############################ Checking Data ##############################
#1 function
#2 key word
#3 key word
# etc ..
######################## Kernel Bug Info Data #######################
kernel_bug@arch/x86/kernel/paravirt.c@paravirt_enter_lazy_mmu
kernel_bug_known@arch/x86/kernel/xsave.c:@__sanitize_i387_state
kernel_bug_known@divide error: 0000@thread_group_times
kernel_bug_known@unable to handle kernel NULL pointer@netpoll_poll_dev
kernel_bug_known@general protection fault:@update_shares
kernel_bug_known@kernel BUG at fs/jbd/commit.c@journal_commit_transaction
kernel_bug_known@kernel BUG at fs/jbd2/commit.c@jbd2_journal_commit_transaction
kernel_bug_known@unable to handle kernel NULL pointer@lookup_user_key
kernel_bug_known@BUG: soft lockup - CPU@_spin_lock
kernel_bug_known@unable to handle kernel NULL pointer@tcp_fastretrans_alert
###################### End Kernel Bug Info Data ####################
######################### End Checking Data ##############################
######################## End Main Info Data ##########################

