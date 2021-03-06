#! /bin/bash

in_info=''
re_opt="^-.*"
arg_status=0
Path=$(docker ps -a 2>/dev/null | grep tianmu | grep api | awk '{print $1}' | xargs docker inspect 2>/dev/null | grep -i source | grep "L1root/L1tools/main/config" | awk -F '"' '{print $4}')
r_file_path="${Path}/rtable.csv"
c_file_path="${Path}/container_arrangement.csv"



#############################  Function ###########################

error()
{
    local err=$1
    echo ""
    echo "$err"
    exit -1
}

query_r_services()
{
        local data_r=$(grep $1 ${r_file_path})
        local line_num_r=$(grep $1 ${r_file_path} | wc -l)
        [ ${line_num_r} -eq 0 ] && printf "Not find data about $1 from ${r_file_path} \n" 
        [ ${line_num_r} -ne 0 ] && printf "Host computer query num \033[31m${line_num_r} \033[0m from ${r_file_path} \n"  && for info in ${data_r}
        do  
            output_host_info "${info}"
        done
}

query_c_services()
{
    local data_c=$(grep $1 ${c_file_path})
    local line_num_c=$(grep $1 ${c_file_path} | wc -l)
    local hostname_array=()
    local n=0
    [ ${line_num_c} -eq 0 ] && error  "Not find data about $1 from ${c_file_path}" 
    [ ${line_num_c} -ne 0 ] && printf "Docker info query num \033[31m${line_num_c} \033[0m from ${c_file_path}\n"  && for info in ${data_c}
    do
        local host_name=$(echo ${info} | awk -F ',' '{print $9}')
        hostname_array[$n]=${host_name}
        n=$(($n+1))
    done
    local hostname_array=($(awk -vRS=' ' '!a[$1]++' <<< ${hostname_array[@]}))

    hostname_array_handle "${hostname_array[*]}"
}

hostname_array_handle()
{
    local hostname_array=$1
    for hostname in ${hostname_array[*]}
    do
        local data_r=$(grep -w ${hostname} ${r_file_path})
        local data_c_filter=$(grep ${in_info} ${c_file_path} | grep -w ${hostname})
        output_host_info "${data_r}" "${data_c_filter}"
    done

}



output_host_info()
{
        local ip=$(echo $1 | awk -F ',' '{print $7}')
        local hostname=$(echo $1 | awk -F ',' '{print $6}')
        local OS=$(echo $1 | awk -F ',' '{print $8}')
        local product=$(echo $1 | awk -F ',' '{print $2}')
        local service=$(echo $(echo $(echo $(echo $1 | awk -F '[' '{print $2}') | awk -F ']' '{print $2}')) | awk -F ',' '{print $2}')
        [ ${hostname} ] || [ ${ip} ] && printf  "\E[1;31;33mHost computer:\E[0m  hostname(\E[1;31;33m${hostname}\E[0m) IP(\E[1;31;33m${ip}\E[0m) OS(\E[1;31;33m${OS}\E[0m) Service(\E[1;31;33m${service}\E[0m) Product(\E[1;31;33m${product}\E[0m)\n"
        for info in $2
        do
            local service_instance=$(echo ${info} | awk -F ',' '{print $1}')
            local docker_hostname=$(echo ${info} | awk -F ',' '{print $5}')
            local docker_ip=$(echo ${info} | awk -F ',' '{print $4}')
            local application=$(echo ${info} | awk -F ',' '{print $2}')
            printf  "       ---\E[1;31;32mDocker\E[0m Name(\E[1;31;32m${docker_hostname}\E[0m) IP(\E[1;31;32m${docker_ip}\E[0m)  service(\E[1;31;32m${service_instance}\E[0m) Application(\E[1;31;32m${application}\E[0m)\n"
        done

}

usage()
{
    cat << EOF
    Usage:
        $(basename $0) -q <query keyword>        Query Keyword about Host computer or docker info; 
    Example:
        $(basename $0) -q 10.1.7.32
        or
        $(basename $0) -q docker010001040185
        or 
        $(basename $0) -q tianji.master
EOF
    exit 1
}

#############################################End Function#############################################


############################################# Main ##############################################


[[ $1 =~ ${re_opt} ]] && arg_status=1
[ $# -eq 0 ] || [ ${arg_status} -eq 0 ] && usage

while getopts q:h OPTION 2>/dev/null
do
    case $OPTION in
        h) usage;;
        q) in_info="$OPTARG";;
        *) usage;;
    esac
done

[ -z ${Path} ] && error "NO Docker service!"
query_r_services "${in_info}"
query_c_services "${in_info}"


########################################### End Main ############################################
