#! /bin/bash

in_info=''
re_ip_name="^[0-9]+.[0-9]+.[0-9]+.[0-9]*$"

##############  Function ########################

query_services()
{ 
    if [ $1 =~ re_ip_name ];then
        local ip_info=$1 
        ip_info=$(cat rtable.csv | grep $1 | awk -F ',' '{print $7}')
    else
        local host_name_info=$1
        host_name=$
}



################End Function#####################



################## Main #####################

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


[ $# -eq 0 ] && usage

while getopts t: OPTION
do
    case $OPTION in
        t) in_info="$OPTARG";;
        *) usage;;
    esac
done

query_services "${in_info}"
