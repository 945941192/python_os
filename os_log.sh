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

    msg "Call command: ${cmd:0:60}"

    if_command_not_exist $cmd && result $skip && return
    [ "$action" = "path" ] && cmd="$cmd $log"
    
    echo "Command: $cmd" >> $log
    eval $cmd >> $log 2>&1
    res=$?
    result $res
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
is_el7()
{
    local el7=$(cat /etc/redhat-release | grep -c 7\.)
    [ $el7 -eq 1 ] && return 0
    return 1
}
prepare_to_run()
{
    LOCK_FILE="${SLOGDIR}/${WORKDIR}.pid"
    LOGDIR="${SLOGDIR}/${WORKDIR}"
    rm -rf $LOGDIR
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
    local log_temp=$1
    local nic_devices=$(ls /sys/class/net/)
    
    echo "nic_list=$nic_divices"
    for device in ${nic_devices}
    do
        if [ "${device}" != 'lo' ] && [ -d /sys/class/net/${device} ]
        then
            ethtool -i ${device} >> "${log_temp}_$device"
            ethtool ${device}    >> "${log_temp}_$device"
            ethtool -S ${device} >> "${log_temp}_$device"
            ethtool -g ${device} >> "${log_temp}_$device"
            ethtool -k ${device} >> "${log_temp}_$device"
        fi
    done
}
get_bonding_info()
{
    local log_temp=$1
    local bonds=$(ls /proc/net/bonding/)

    echo "$bonds"
    for bond in $bonds
    do
        cat /proc/net/bonding/$bond >> "${log_temp}_$bond"
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
    rm -f ${SLOGDIR}/${WORKDIR}.tar.gz
    cd $SLOGDIR
    tar -zcf $SLOGDIR/${WORKDIR}.tar.gz $WORKDIR 
    md5sum ${SLOGDIR}/${WORKDIR}.tar.gz > ${SLOGDIR}/${WORKDIR}.tar.gz.md5sum
    echo "Tarball md5 file: ${SLOGDIR}/${WORKDIR}.tar.gz.md5sum"
    echo "Tarball file: ${SLOGDIR}/${WORKDIR}.tar.gz"
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
    copy_files "/etc/kdump.conf" "$dir/"
    copy_files "/boot/grub/" "$dir/"
    copy_files "/etc/sysctl.conf" "$dir/"
    copy_files "/var/log/kern" "$dir/"
    copy_files "/etc/security/limits.conf" "$dir/"
    copy_files "/var/log/secure" "$dir/"
    /bin/cp /var/log/secure-* "$dir/"
    copy_files "/var/log/messages" "$dir/"
    /bin/cp /var/log/messages-* "$dir/"
    #copy_files "/var/log/sa/" "$dir"
    return 0
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

    info "$info_output"
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
    done | tee -a "${LOGDIR}/running_output"
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
    local type_pattern="Collection Data"
    sed -n "/## ${type_pattern} ##/,/## End ${type_pattern} ##/"p $0 > $DATA_FILE
}
start_checking()
{
    local tarball="$syslog_tgz"
    local check_dir="$LOGDIR"
    [ $checking -eq 0 ] && return

    if [ "$syslog_tgz" != "" ];then
        tar -zxf $syslog_tgz -C /var/log/
        check_dir=${syslog_tgz%.tar.gz}
    fi

    info "$check_dir"
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

prepare_to_run
trap cleanup EXIT
generate_data_file
free_space_check "$LOGDIR" 5
check_single_instance
show_system_info
start_collection
start_checking
compress_log
exit 0
############################# End Main ##############################

########################## Collection Data ############################
############################# Type Data ############################
#Info Type:logdir:description
System Info Data:system_info:Start collecting system information ...
Network Info Data:network_info:Start collecting network information ...
BMC Info Data:bmc_info:Start collecting bmc information ...
Dom0 Info Data:dom0_info:Start collecting dom0 information ...
Disk Info Data:disk_info:Start collecting disk information ...
########################### End Type Data ##########################

#flag:collect_function:action:filename:scope:analysis_function:fix_function

#flag make sure it is unique
#action include:
# check <-- check if command exist, default to check
# path  <-- send target path to command

#filename is log file name.
#scope include 1(small), 2(normal) and 3(all).
########################## System Info Data ###########################
history:cat $HOME/.bash_history::history:2:
uname:uname -a::uname_a:2:
df:df -h::df_h:2:
free:free -m::free_m:2:
ps:ps -Le -wwo 'pid,psr,pcpu,pmem,rsz,vsz,stime,user,stat,uid,wchan=WIDE-WCHAN-COLUMN,args' --sort rsz::ps_Le_wwo_rsz:2:
last:last reboot::last_reboot:2:
chkconfig:chkconfig --list::chkconfig__list:2:
runlevel:runlevel::runlevel:2:
uptime:uptime::uptime:2:
mount:mount::mount:2:
top_thread:top -H -b -n 1::top_H_b:2:
top:top -b -n 1::top_b:2:
kdump:/etc/init.d/kdump status::kdump_status:2:
lsmod:lsmod::lsmod:2:
cmdline:cat /proc/cmdline::cat_proc_cmdline:2:
meminfo:cat /proc/meminfo::cat_proc_meminfo:2:
slabinfo:cat /proc/slabinfo::cat_proc_slabinfo:2:
vmallocinfo:cat /proc/vmallocinfo::cat_vmallocinfo:2:
swaps:cat /proc/swaps::cat_proc_swaps:2:
cpuinfo:cat /proc/cpuinfo::cat_proc_cpuinfo:2:
dmidecode:dmidecode::dmidecode:2:
dmesg:dmesg::dmesg:2:
ulimit:ulimit -a::ulimit_a:2:
crontab:crontab -l::crontab_l:2:
mpstat:mpstat -P ALL -I ALL::mpstat_A:2:
iostat:iostat -xm 1 6::iostat_xm:2:
vmstat:vmstat 1 6::vmstat:2:
tsar:tsar -n 6:check:tsar_n6:2:
blkid:blkid::blkid:2:
lsscsi:lsscsi::lsscsi:2:
mdadm:mdadm --detail::mdadm__detail:2:
lvs_detail:lvs -vv::lvs_vv:2:
lvs:lvs -v::lvs_v:2:
vgs:vgs::vgs:2:
pvs:pvs::pvs:2:
journalctl:journalctl -xn:check:journalctl_xn:2:
cp_system_files:copy_system_files:path:copy_system_files:2:
top10_mem:get_top10_mem_process_info:path:top_mem_order:2:
top10_cpu:get_top10_cpu_process_info:path:top_cpu_order:2:
######################### End System Info Data ########################
######################## Network Info Data ###########################
sarnet:sar -n DEV 1 6::sar_n_dev:2:
ss:ss -anpei::ss_anpei:3:
ifstat:ifstat -a 1 6::ifstat_a:2:
ipaddr:ip addr show::ip_addr_show:2:
iproute:ip route show::ip_route_show:2:
ifconfig:ifconfig::ifconfig:2:
ifconfig_all:ifconfig -a::ifconfig_a:2:
route_cache:route -Cn::route_Cn:2:
route:route -n::route_n:2:
netstat:netstat -anpo::netstat_anpo:2:
netstat_pro:netstat -s::netstat_s:2:
netstat_dev:netstat -i::netstat_i:2:
bonding_info:get_bonding_info:path:bonding_info:2:
netcard_info:get_netcard_info:path:netcard_info:2:
###################### End Network Info Data #########################
########################## BMC Info Data #######################
ipmifru:ipmitool fru list::ipmitool_fru_list:2:
ipmilan:ipmitool lan print 1::ipmitool_lan_print_1:2:
ipmimc:ipmitool mc info::ipmitool_mc_info:2:
ipmisensor:ipmitool sensor list::ipmitool_sensor_list:2:
ipmisdr:ipmitool sdr list::ipmitool_sdr_list:2:
ipmisel:ipmitool sel elist::ipmitool_sel_elist:2:
######################## End BMC Info Data #####################
########################## Dom0 Info Data ######################
docker_info:get_docker_info:path:docker_info:2:
######################## End Dom0 Info Data ####################
############################ Disk Info Data ####################
disks_io_detail:get_disks_io_detail:path:disks_io_detail:3:
disk_info:get_disk_info:path:disk_info:2:
raid_info:get_raid_log:path:raid_type:2:
check_syslog:/usr/alisys/dragoon/libexec/alimonitor/independent_domain_check_syslog:check:independent_domain_check_syslog:2:
check_hardware:/usr/alisys/dragoon/libexec/alimonitor/independent_domain_check_hardware:check:independent_domain_check_hardware:2:
########################## End Disk Info Data #####################
######################## End Collection Data ##########################
