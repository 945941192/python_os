#! /bin/bash
##########################################################################
# File Name: os_log.sh
# Author: weizhanbiao
# Mail: weizhanbiao.wc@alibaba-inc.com
# Description: collect privte cloud os log for system
#              faulty and kernel crash.
# Created Time: 2017/8/11
#########################################################################

############# Global Variable ############

domain_name=''
dns_master=''
dns_slave=''
master_file='/tmp/master.domain'
slave_file='/tmp/slave.domain'
named_file="/etc/named.conf"
chroot_dom_file_dir="/var/named/chroot/var/named"
dom_file_dir="/var/named"
########### End Global Variable ##########


################################## Function ################################
error()
{
    local err=$1
    echo ""
    echo "$err"
    exit -1
}
ssh_cmd()
{
    local node=$1
    local cmd="$2"

    ssh -o LogLevel=error -o ConnectTimeout=3 -o BatchMode=yes root@$node "$cmd"

    if [ "$?" != "0" ] && [ "$2" != "ignore" ];then
        error "cmd : $1 failed !"
    fi
}
dig_dns_server()
{
    local success=0
    local search_name=$(cat /etc/resolv.conf | grep search | sed 's/search//g')
    local dname="$(hostname)"
    local dns_server=$1
    [ "$domain_name" != "" ] && dname=$domain_name

    success=$(dig ${dname} @$dns_server| grep status | awk -F ',' '{print $(NF-1)}' | awk -F ':' '{print $NF}' | grep -ic "NOERROR")

    for search_one in $search_name
    do
        local fqdn=${dname}.${search_one}
        local ok=$(dig $fqdn @$dns_server | grep status | awk -F ',' '{print $(NF-1)}' | awk -F ':' '{print $NF}' | grep -ic "NOERROR")
        [ $ok -ne 0 ] && success=1 && break
    done

    printf "%-75s" "DNS server $dns_server analysis domain name $dname "
    if [ $success -ne 0 ];then
        printf "\t\E[1;31;32mSuccess\E[0m\n"
    else
        printf "\t\E[1;31;33mFail\E[0m\n"
    fi
}
check_dns_server()
{
    for server_name in $(cat /etc/resolv.conf | grep -v '^#' | grep nameserver | awk -F' '  '{print $NF}')
    do
        ping -c3 -W2  ${server_name} > /dev/null 2>&1
        if [ $? -ne 0 ];
        then
            printf "%-75s" "ping DNS server: ${server_name}" && printf "\t\E[1;31;33mFail\E[0m\n"
            error "Please fix the issue first !"
        else
            printf "%-75s" "ping DNS server: ${server_name}" && printf "\t\E[1;31;32mSuccess\E[0m\n"
            dig_dns_server $server_name
        fi
    done
}
check_dns_domain()
{
    local domain_file=$(ssh_cmd $dns_master "grep -E '^[ ]*file' $named_file"|awk '{print $2}'|awk -F\" '{print $2}')
    for dom_file in $domain_file
    do
        ssh_cmd $dns_master "grep -v NS ${chroot_dom_file_dir}/$dom_file" > $master_file
        ssh_cmd $dns_slave "grep -v NS ${dom_file_dir}/$dom_file" > $slave_file
        echo "Starting check domain file $dom_file"
        diff -Nurp $master_file $slave_file
        [ $? -eq 0 ] && echo "End check,it is ok!" && continue
        echo "End check,$dom_file is different in $dns_master and $dns_slave"
    done
}
ssh_check()
{
    ssh_cmd $dns_master true
    ssh_cmd $dns_slave true
    return 0
}
check_dns_file()
{
    if [[ $dns_master != "" ]] && [[ $dns_slave != "" ]];then
        ssh_check
        [ $? -eq 0 ] && check_dns_domain
    fi
    [ -e $master_file ] && rm -f $master_file
    [ -e $slave_file ] && rm -f $slave_file
    exit 0
}
############################### End Function ################################


########################### Main ################################
usage()
{
    cat << EOF
    Usage:
        $(basename $0) -t <test domain name>             Check DNS server by domain name.
        $(basename $0) -m <dns-master> -s <dns-slave>    Check all domain file for dns1,dns2.
    Example:
        $(basename $0) -t dnsapi1.tbsite.net
        $(basename $0) -m 10.0.0.1 -s 10.0.0.2
EOF
    exit 1
}


while getopts t:m:s: OPTION
do
    case $OPTION in
        t) domain_name="$OPTARG";;
        m) dns_master="$OPTARG";;
        s) dns_slave="$OPTARG";;
        *) usage;;
    esac
done

if [ "$domain_name" != "" ];then
    check_dns_server
else
    check_dns_file
fi
exit 0
########################### End Main ###########################
