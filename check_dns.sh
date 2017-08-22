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
########### End Global Variable ##########


################################## Function ################################
error()
{
    local err=$1
    echo ""
    echo "$err"
    exit -1
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
        local domain_name=${dname}.${search_one}
        local ok=$(dig ${domain_name} @$dns_server | grep status | awk -F ',' '{print $(NF-1)}' | awk -F ':' '{print $NF}' | grep -ic "NOERROR")
        [ $ok -ne 0 ] && success=1
    done

    printf "%-75s" "DNS server $dns_server analysis"
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


############################### End Function ################################


########################### Main ################################
usage()
{
    cat << EOF
    Usage:
        $(basename $0) -t <test Domain name>        Check DNS server by Domain name
    Example:
        $(basename $0) -t ntp.aliyun.com
EOF
    exit 1
}


while getopts t: OPTION
do
    case $OPTION in
        t) domain_name="$OPTARG";;
        *) usage;;
    esac
done

check_dns_server

exit 0
########################### End Main ###########################
