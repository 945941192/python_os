#! /bin/bash

in_info=''
r_file_path="rtable.csv"
c_file_path="container_arrangement.csv"

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
        local r_success=0
        local c_success=0
        local data_r=$(grep -w $1 ${r_file_path})
        local data_c=$(grep -w $1 ${c_file_path})
        local status_r=$(echo ${data_r} | wc -w) 
        local status_c=$(echo ${data_c} | wc -w)
        [ ${status_r} -ne 0 ] && r_success=1
        [ ${status_c} -ne 0 ] && c_success=1
        [ ${r_success} -ne 1 ] && [ ${c_success} -ne 1 ] && error "No query to the host"
        [ ${r_success} -ne 1 ] && [ ${c_success} -eq 1 ] && data_r=$(grep -w $(grep -w $1 ${c_file_path} | head -1 | awk -F ',' '{print $9}') ${r_file_path})
        output_host_info "${data_r}" "${data_c}"
}


output_host_info()
{
        local ip=$(echo $1 | awk -F ',' '{print $7}')
        local hostname=$(echo $1 | awk -F ',' '{print $6}')
        local product=$(echo $1 | awk -F ',' '{print $2}')
        local new_appgroup=$(echo $1 | awk -F ',' '{print $3}')
        local node=$(echo $1 | awk -F ',' '{print $4}')
        local OS=$(echo $1 | awk -F ',' '{print $8}')
        local new_appgroup=$(echo $1 | awk -F ',' '{print $3}')
        printf  "hostnam(\E[1;31;33m${hostname}\E[0m) IP(\E[1;31;33m${ip}\E[0m) OS(${OS}) \n"
        printf  "product(\E[1;31;33m${product}\E[0m) new_appgroup(\E[1;31;33m${new_appgrop}\E[0m) node(\E[1;31;33m${node}\E[0m) \n"
        for info in $2
        do
            local service_instance=$(echo ${info} | awk -F ',' '{print $1}')
            local docker_hostname=$(echo ${info} | awk -F ',' '{print $5}')
            local docker_ip=$(echo ${info} | awk -F ',' '{print $4}')
            printf  "        ---Docker hostname(\E[1;31;32m${docker_hostname}\E[0m) IP(${docker_ip})  service(${service_instance})\n"
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
