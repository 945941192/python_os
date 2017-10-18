#!/bin/bash
#########################################################################
# File Name: collection_process.sh
# Author: xiaoding
# Mail: wb-djl307738@alibaba-inc.com
# Description: Gather detailed information about a specific process.
# Created Time: 2017-7-28
#########################################################################
#########################################################################


LOGDATE=$(date "+%Y-%m-%d-%H-%M-%S")
TGDIR="/var/process_info.$LOGDATE"
PID=""

run_cmd()
{
    local cmd="$1"
    local log="$2"

    eval $cmd > ${TGDIR}/$PID/$log 2>&1
}

get_pid_info()
{	
    local printpid=$(ps -p $PID | grep -v PID | awk '{print $1}')
    
    if [ "$printpid" != "$PID" ];then	
        echo "The process id [$PID] is not correct, exit ..."
        exit 1
    else

        echo ""
        echo "Start to get $PID info ..."

        mkdir -p "$TGDIR/$PID"
     
        run_cmd "ps -L -wwo 'pid,spid,psr,pcpu,pmem,rsz,vsz,stime,user,stat,uid,wchan=WIDE-WCHAN-COLUMN,args' -p $PID" "ps_L_wwo" 
        run_cmd "pstree -l -H $PID" "pstree_l_H"
        run_cmd "top -b -n 1 -p $PID" "top_b_n"
        run_cmd "netstat -anp | grep $PID" "netstat_anp"
        run_cmd "pmap -x $PID" "pmap_x"
        run_cmd "pmap -d $PID" "pmap_d"
    fi					
}


get_pid_proc()
{
    local dir="$TGDIR/$PID"
    local files=$(ls "/proc/$PID")
    local exclude="task pagemap"

    echo ""
    echo "Start to get $PID proc files ..."
    
    mkdir -p "${TGDIR}/${PID}/proc/"
    for file in $files
    do
        echo "$exclude" | grep -qw "$file" && continue
        /bin/cp -r "/proc/${PID}/$file" "${TGDIR}/${PID}/proc/" 2>/dev/null
    done
}

cleanup()
{
    [ "$TGDIR" != "/" ] && rm --preserve-root -rf "$TGDIR"
}

tarball_pid()
{
    echo ""
    echo "Start to comparess $PID log ..."
    /bin/tar -czvf "${TGDIR}.${PID}.tar.gz" "$TGDIR"  >/dev/null 2>&1

    echo ""
    [ $? -eq 0 ] && echo "Tarball file: ${TGDIR}.${PID}.tar.gz"
}


usage()
{
    cat << EOF
    Usage:
        $(basename $0) -p <pid>			Execute the script after the process number
    Example:
        $(basename $0) -p 12345
EOF
    exit 1
}


while getopts p:h OPTION
do
    case $OPTION in
        h) usage;;
        p) PID="$OPTARG";;
        *) usage;;
    esac
done
[ "$PID" = "" ] && usage
trap cleanup EXIT
get_pid_info
get_pid_proc
tarball_pid
