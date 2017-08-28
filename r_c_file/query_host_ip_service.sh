#! /bin/bash

in_info=''

##############  Function ########################

error()
{
    local err=$1
    echo ""
    echo "$err"
    exit -1
}

query_services()
{
#c file 
        host_or_ip_info=$1
        data1=$(grep -w $1 rtable.csv)
        #echo "$data1" 
        status1=$(echo ${data1} | wc -w) 
        echo "$status1"
        [ ${status1} -eq 0 ] && error "No query to the host"
        ip=$(echo ${data1} | awk -F ',' '{print $7}')
        new_appgroup=$(echo ${data1} | awk -F ',' '{print $3}')
        printf  "host ${ip} new_appgroup ${new_appgroup}\n"
       
#r file
        data2=$(grep -w $1 container_arrangement.csv)
        status2=$(echo ${data2} | wc -w)
        [ ${status2} -ne 0 ] && for info in ${data2}
        do
            service_instance=$(echo ${info} | awk -F ',' '{print $1}')
            printf  "        |\n"
            printf  "        |\n"
            printf  "        ----dockerservice:${service_instance}\n"
        done
}



################End Function#####################



################## Main #####################

usage()
{
    cat << EOF
    Usage:
        $(basename $0) -q <query hostname or ip>        Query hostname or ip 
    Example:
        $(basename $0) -q 10.1.7.32
        or
        $(basename $0) -q rc85c6128.cloud.nu17
EOF
    exit 1
}


[ $# -eq 0 ] && usage

while getopts q: OPTION
do
    case $OPTION in
        q) in_info="$OPTARG";;
        *) usage;;
    esac
done

query_services "${in_info}"
