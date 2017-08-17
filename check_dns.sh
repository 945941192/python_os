#! /bin/bash

############# Global Variable ############

domain_name=''

########### End Global Variable ##########


################################## Function ################################
check_ping_dns_server()
{
    for server_name in $(cat /etc/resolv.conf | grep -v '^#' | grep nameserver | awk -F' '  '{print $NF}')
    do
        ping -c3 -W2  ${server_name} > /dev/null 2>&1
        if [ $? -ne 0 ];
        then
            printf "%-75s" "ping DNS server: ${server_name}" && printf "\t\E[1;31;33mFail\E[0m\n"
        else
            printf "%-75s" "ping DNS server: ${server_name}" && printf "\t\E[1;31;32mSuccess\E[0m\n"
            check_dig_admaim_name_cdn_server ${server_name}
        fi
    done
}


check_dig_admaim_name_cdn_server()
{
    status=$(dig ${domain_name} @$1| grep status | awk -F ',' '{print $(NF-1)}' | awk -F ':' '{print $NF}')
    if [ ${status} != "NOERROR" ];
    then
        printf "%-75s" "DNS server $1 analysis ${domain_name}" && printf "\t\E[1;31;33mFail\E[0m\n"
    else
        printf "%-75s" "DNS server $1 analysis "${domain_name} && printf "\t\E[1;31;32mSuccess\E[0m\n"
    fi
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

if [ $# -eq 0 ];
then
    usage
fi

while getopts t: OPTION
do
    case $OPTION in
        t) domain_name="$OPTARG";;
        *) usage;;
    esac
done

check_ping_dns_server

exit 0
########################### End Main ###########################
