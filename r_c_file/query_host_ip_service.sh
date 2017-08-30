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
        #[ ${status1} -eq 0 ] && error "No query to the host"
        [ ${status_r} -ne 0 ] && r_success=1
        [ ${status_c} -ne 0 ] && c_success=1
        
######## data true or fals ########
        [ ${r_success} -ne 1 ] && [ ${c_success} -ne 1 ] && error "No query to the host"
        [ ${r_success} -ne 1 ] && [ ${c_success} -eq 1 ] && data_r=$(grep -w $(grep -w $1 ${c_file_path} | head -1 | awk -F ',' '{print $9}') ${r_file_path})
        
######print r
        local ip=$(echo ${data_r} | awk -F ',' '{print $7}')
        local hostname=$(echo ${data_r} | awk -F ',' '{print $6}')
        local product=$(echo ${data_r} | awk -F ',' '{print $2}')
        local new_appgroup=$(echo ${data_r} | awk -F ',' '{print $3}')
        local node=$(echo ${data_r} | awk -F ',' '{print $4}')
        local OS=$(echo ${data_r} | awk -F ',' '{print $8}')
        local new_appgroup=$(echo ${data_r} | awk -F ',' '{print $3}')
        printf  "hostnam(\t\E[1;31;33m${hostname}\E[0m) IP(\t\E[1;31;33m${ip}\E[0m) OS(${OS}) product(${product}) new_appgroup(${new_appgroup}) node(${node})     \n"
   
######print c
        for info in ${data_c}
        do
            local service_instance=$(echo ${info} | awk -F ',' '{print $1}')
            local docker_hostname=$(echo ${info} | awk -F ',' '{print $5}')
            local docker_ip=$(echo ${info} | awk -F ',' '{print $4}')
            
            printf  "        |\n"
            printf  "        ----docker_hostname(\t\E[1;31;32m${docker_hostname}\E[0m) docker_ip(${docker_ip})  dockerservice(${service_instance})\n"
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
