#!/bin/bash

#调用函数检测项
tarball_status_fn()
{
    local res=0
    local tarball_name=$1
    [ -e ${tarball_name} ] && res=1
    echo  $res
}


# sh cld_check.sh -c 
check_one()
{
    local check_arg_status="运行 sh cld_check.sh -c 结果错误!!!"
#运行脚本 添加参数
    echo "正在测试cld_check.sh 运行参数 -c  "
    local time_tag=$(date "+%Y-%m-%d-%H-%M-%S")
    sh ~/python_os/os/cld_check.sh -c  >/dev/null  2>&1
    if [ $? -eq 0 ]; 
    then
        echo "Time : ${time_tag}  Script  runing ok!!!!"
    else
        echo "Time : ${time_tag}  Script  runing fail!!!!"
    fi
#检查运行结果
    echo "正在检测 脚本运行参数 -c 执行结果......."
    local tarball_name="/var/log/cloud_log.${time_tag}.tar.gz"
    local tarball_status=$(tarball_status_fn $tarball_name)
#下边是检查项  脚本运行结果的每个特点写一个写函数 eg:检查tarball在不在函数 tarball_status_fn 
    [ ${tarball_status} -eq 1 ] &&  local check_arg_status="运行 sh cld_check.sh -c 结果无误!!!"
    echo $check_arg_status
}

#sh cld_check.sh -d
check_two()
{
    local check_arg_status="运行 sh cld_check.sh -d 结果错误!!!"
    echo "正在测试 cld_check.sh 运行参数 -d"
    local time_tag=$(date "+%Y-%m-%d-%H-%M-%S")
    sh ~/python_os/os/cld_check.sh -d /root >/dev/null
    if [ $? -eq 0 ]; 
    then
        echo "Time : ${time_tag}  Script  runing ok!!!!"
    else
        echo "Time : ${time_tag}  Script  runing fail!!!!"
    fi
#检查运行结果
    echo "正在检测 脚本运行参数 -d 执行结果......."
    local tarball_name="/root/cloud_log.${time_tag}.tar.gz"
    local tarball_status=$(tarball_status_fn $tarball_name)
#
    echo "=================${tarball_status}"
    [[ ${tarball_status} -eq 1 ]] &&  local check_arg_status="运行 sh cld_check.sh -d 结果无误!!!"
    echo $check_arg_status
}

#check_one
check_two
