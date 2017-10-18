#!/bin/bash

ntpq_res=""
ntp_master=""
ntpstat_ip=""
ntpstat_res=""
ntpdate_res=""
ntpq_offset=""
ntpq_clock_res=""
ntpq_offset_res=""
arg="$1"
node="$2"

ssh_check()
{
    [[ $node == "" ]] || [[ $arg != "-h" ]] && usage
    ssh -o LogLevel=error -o ConnectTimeout=3 -o BatchMode=yes $node true
    [ $? -ne 0 ] && echo "Connect to $node failure!!!" && exit 1
}

ssh_cmd()
{
    local node=$1
    local cmd="$2"
    ssh -o LogLevel=error $node "$cmd"
}

get_ntp_info()
{
    ntpq_res=$(ssh_cmd $node "ntpq -pn")
    ntp_master=$(echo "$ntpq_res"|grep "\*"|awk '{print $1}'|awk -F'*' '{print $2}')
}

ntp_service_check()
{
    el7=$(ssh_cmd $node "cat /etc/redhat-release"|grep " 7\."|wc -l)
    if [ $el7 -eq 1 ];then
        service_flag=$(ssh_cmd $node "systemctl status ntpd"|grep Active|awk '{print $2}')
        [[ "$service_flag" == "active" ]] && echo "NTP server is running!" || echo "Please try to exec <systemctl start ntpd>!"
    else
        service_flag=$(ssh_cmd $node "service ntpd status"|grep -c "running")
        [ $service_flag -eq 1 ] && echo "NTP server is running!" || echo "Please try to exec <service ntpd start>!"	
    fi
}

ntpq_check()
{
    ntpq_offset=$(echo "$ntpq_res"|grep "\*"|awk '{print $9}'|sed -r 's/-([0-9]+)/\1/g'|awk -F'.' '{print $1}')
    
    [ $ntpq_offset -le 50 ] && ntpq_offset_res=0 || ntpq_offset_res=1 
    [[ $ntp_master =~ "127.127" ]] && ntpq_clock_res=1 || ntpq_clock_res=0
}

ntpstat_check()
{
    ntpstat_ip=$(ssh_cmd $node "ntpstat"|grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    res=$(echo $ntpstat_ip|wc -l)
    [ $res -eq 1 ] && ntpstat_res=0 || ntpstat_res=1
}

ntpdate_check()
{
    sync_res=$(ssh_cmd $node "ntpdate -q -u $ntp_master 2>&1" | tail -1 | grep -c "$ntp_master")
    [ $sync_res -eq 1 ] && ntpdate_res=0 || ntpdate_res=1
}

ping_check()
{
    local ntp_servers=$(ssh_cmd $node "cat /etc/ntp.conf" | grep -v '#' | grep -v '127.127' |grep -v 'nopeer'|egrep 'server|peer' | awk '{print $2}')

    for ntp_server in $ntp_servers
    do
        ssh_cmd $node "ping -c 3 $ntp_server" > /dev/null 2>&1
        [ $? -ne 0 ] && echo "Ping ntp server $ntp_server failed, please fix it and try again ... " && exit 1
        echo "Ping ntp server $ntp_server success!" 
    done
}

check_output()
{
    [ $ntpstat_res -eq 0 ] && echo "Connect to NTP server $ntpstat_ip,ntpstat check success!" || echo "ntpstat check FAILURE!!!"
    [ $ntpdate_res -eq 0 ] && echo "Connect to NTP server $ntp_master,ntpdate check success!" || echo "ntpdate check FAILURE!!!"
    [ $ntpq_offset_res -eq 0 ] && echo "Current clock offset is $ntpq_offset ms!" || echo "Current clock offset is $ntpq_offset ms,synchronization FAILURE!!!" 
    [ $ntpq_clock_res -eq 1 ] && echo "Warning: Connect to local clock,please check whether this server is the OPS NTP server!!!"

    if [ $ntpstat_res -eq 0 ] && [ $ntpdate_res -eq 0 ] && [ $ntpq_clock_res -eq 0 ] && [ $ntpq_offset_res -eq 0 ];then
        echo ">>>>>>NTP client setup check success!!!"
    else
        echo ">>>>>>NTP client setup check FAILURE,please report to level 2 supporter!!!"   
    fi
}
usage()
{
    echo "sh ntp_check.sh -t <ip>"
    exit 1
}
main()
{
    ssh_check
    ping_check
    ntp_service_check
    get_ntp_info
    ntpstat_check
    ntpdate_check
    ntpq_check
    check_output
}
main
