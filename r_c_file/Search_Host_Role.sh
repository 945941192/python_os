#!/bin/bash


Path=`docker ps -a | grep tianmu | grep api | awk '{print $1}' | xargs docker inspect | grep -i source | grep "L1root/L1tools/main/config" | awk -F '"' '{print $4}'`

Rtable=rtable.csv
Container=container_arrangement.csv


Usage(){
cat <<!
Usage: $0 [-h] [-s search]
-h print this message
-s Hostname or IP search parameter
!
}


while getopts "hs:" opt
do
    case "$opt" in
        h) Usage
            exit 3;;
        s) Retrieval="$OPTARG";;
        ?) Usage
            exit 3;;
    esac
done






if [[ -z $Retrieval ]];then
    Usage
    exit 1
fi



function Search_R(){

    R_Source=$(cat $Rtable | grep -i $Retrieval | awk -F , '{print $3,$6,$7}')
    R_Array=($R_Source)
	for (( i=0;i<${#R_Array[@]};i=i+3))
    do
        echo -e "Appgroup:\033[36m${R_Array[$i]}\033[0m"
        echo -e "Hostname:\033[36m${R_Array[$i+1]}\033[0m"
        echo -e "HostIp:\033[36m${R_Array[$i+2]}\033[0m"
    done
}


function Search_C(){

    C_Source=$(cat $Container | grep -i $Retrieval | awk -F , '{print $2,$4,$5}')
    C_Array=($C_Source)
	for (( i=0;i<${#C_Array[@]};i=i+3))
    do
        echo -e "Docker_Application:\033[36m${C_Array[$i]},${C_Array[$i+1]},${C_Array[$i+2]}\033[0m"

    done
}










#main
Search_R
Search_C

