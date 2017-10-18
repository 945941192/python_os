#!/bin/bash
######################################################################
# File Name: kdump_conman_check.sh
# Version: V1.1
# Author: Liushiyi
# Employee Number: WB303203
# Mail: wb-lsy303203@alibaba-inc.com
# Description: check the configuration of kdump and conman service
# Created Time: Fri Sep 15 11:22:06 CST 2017
######################################################################

#set -o pipefail
reboot_flag=''
el5=$(cat /etc/redhat-release|grep " 5\."|wc -l)
el6=$(cat /etc/redhat-release|grep " 6\."|wc -l)
el7=$(cat /etc/redhat-release|grep " 7\."|wc -l)
NO_FILE_EXIST=3
#el6_kernel=$(uname -r)

result()
{
    local res=$1
    local cmd_info=$2
    case $res in
        1)printf "%-60s" "$cmd_info"
        printf "\t\E[1;31;32mPASS\E[0m\n";;
        2)printf "%-60s" "$cmd_info"
        printf "\t\E[1;31;31mFAIL\E[0m\n";;
    esac
}

conman_grub_check()
{
    [ $el7 -eq 1 ] && local file_name="/etc/grub2.cfg" || local file_name="/etc/grub.conf"
    local flag=$(grep -c "ttyS" $file_name)
    [[ $flag -ge 1 ]] && result 1 "$file_name check is right!" || result 2 "$file_name check is wrong!"
}

conman_securetty_check()
{
    local file_name="/etc/securetty"
    local flag=$(grep -Ec "ttyS0|ttyS1" $file_name)
    [ $flag -eq 1 ] && result 1 "$file_name check is right!" || result 2 "$file_name check is wrong!"
}

conman_inittab_check()
{
    local file_name="/etc/inittab"
    local flag=$(grep -c "ttyS" $file_name)
    [ $flag -ge 1 ] && result 1 "$file_name check is right!" || result 2 "$file_name check is wrong!"
}

conman_printk_check()
{
    local file_name="/proc/sys/kernel/printk"
    [ "$(cat $file_name)" == "5	4	1	5" ] && result 1 "$file_name check is right!" || result 2 "$file_name check is wrong!"
}

conman_sysctl_check()
{
    local file_name="/etc/sysctl.conf"
    local flag=$(grep -c "kernel.printk = 5 4 1 5" $file_name)
    [ $flag -eq 1 ] && result 1 "$file_name check is right!" || result 2 "$file_name check is wrong!"
}

conman_agetty_check()
{
    local flag=$(ps -ef|grep -i agetty|grep -v grep|awk '{print $6}'|grep -Ec 'ttyS0|ttyS1')
    [ $flag -eq 1 ] && result 1 "The agetty check is right!" || result 2 "The agetty check is wrong!"
}

conman_cmdline_check()
{
    local file_name="/proc/cmdline"
    local flag=$(grep -c "ttyS" $file_name)
    [[ $flag -ge 1 ]] && result 1 "$file_name check is right!" || result 2 "$file_name check is wrong!"
}

conman_auth()
{
    if [[ "$reboot_flag" == "before_reboot" ]];then
            conman_grub_check
            conman_securetty_check
            conman_printk_check
            conman_sysctl_check
        [ $el5 = 1 ] && conman_inittab_check
    elif [[ "$reboot_flag" == "after_reboot" ]];then
        conman_cmdline_check
        conman_securetty_check
        conman_printk_check
        conman_sysctl_check
        conman_agetty_check
    fi
}

kdump_grub_check()
{
    if [ $el7 -eq 1 ];then
        local file_name="/etc/grub2.cfg"
        local flag=$(grep "crashkernel=auto" $file_name|head -1|wc -l)
    elif [ $el6 -eq 1 ];then
        local file_name="/etc/grub.conf"
        local flag=$(grep "crashkernel=256M" $file_name|head -1|wc -l)
    else
        local file_name="/etc/grub.conf"
        local flag=$(grep "crashkernel=256M@64M" $file_name|head -1|wc -l)
    fi
    
    [ $flag -eq 1 ] && result 1 "The value of crashkernel in $file_name is right!" || result 2 "The value of crashkernel in $file_name is wrong!"
}

kdump_cmdline_check()
{
    local file_name="/proc/cmdline"
    if [ $el7 -eq 1 ];then
        local flag=$(grep "crashkernel=auto" $file_name|head -1|wc -l)   
    elif [ $el6 -eq 1 ];then
        local flag=$(grep "crashkernel=256M" $file_name|head -1|wc -l)
    else
        local flag=$(grep "crashkernel=256M@64M" $file_name|head -1|wc -l)
    fi
     
    [ $flag -eq 1 ] && result 1 "The value of crashkernel in $file_name is right!" || result 2 "The value of crashkernel in $file_name is wrong!"
}

kdump_content_check()
{
    local device=`mount|awk '$3 ~ "^/$"{print $1}'`
    local filesystem=`mount|awk '$3 ~ "^/$"{print $5}'`
    local first_line="$device $filesystem"
    local second_line="path /var/crash"
    local third_line_el5="core_collector makedumpfile -c --message-level 1 -d 1"
    local third_line_el6_or_el7="core_collector makedumpfile -c --message-level 1 -d 31"
    local fourly_line="extra_modules mpt2sas mpt3sas megaraid_sas hpsa ahci"
    local five_line="default reboot"
    
    [ $el5 -eq 1 ] && third_line=$third_line_el5 || third_line=$third_line_el6_or_el7
    
    if [[ $(awk 'NR==1{print $1}' /etc/kdump.conf) == "$filesystem" ]] && \
        [[ $(awk 'NR==1{print $2}' /etc/kdump.conf) == "$device" ]] && \
        [[ $(awk 'NR==2{print}' /etc/kdump.conf) == "$second_line" ]] && \
        [[ $(awk 'NR==3{print}' /etc/kdump.conf) == "$third_line" ]] && \
        [[ $(awk 'NR==4{print}' /etc/kdump.conf) == "$fourly_line" ]] && \
        [[ $(awk 'NR==5{print}' /etc/kdump.conf) == "$five_line" ]]; \
    then
        result 1 "The content of /etc/kdump.conf is right!"
    else
        result 2 "The content of /etc/kdump.conf is wrong!"
    fi
}

kdump_service_auth()
{
    if [ -e /etc/kdump.conf ];then
        result 1 "The /etc/kdump.conf is exist"
        kdump_content_check    
    else
        result 2 "No /etc/kdump.conf exist"
        exit $NO_FILE_EXIST
    fi
    
    if [ $el7 -eq 1 ];then
        service_flag=$(systemctl status kdump|grep Active|awk '{print $2}')
        enable_flag=$(systemctl status kdump|grep Loaded|awk '{print $4}'|awk -F';' '{print $1}')
        
        [[ "$service_flag" == "active" ]] && result 1 "Kdump service is running!" || result 2 "Please try to execute <systemctl start kdump>!"
        
        [[ "$enable_flag" == "enabled" ]] && result 1 "Kdump service is enabled!" || result 2 "Please try to execute <systemctl enable kdump>!"
    else
        enable_flag1=$(chkconfig --list kdump|awk '{print $5}'|awk -F: '{print $2}')
        enable_flag2=$(chkconfig --list kdump|awk '{print $7}'|awk -F: '{print $2}')
        service kdump status > /dev/null 2>&1
        [ $? -eq 0 ] && result 1 "Kdump service is running!" || result 2 "Please try to execute <service kdump start>!"
        
        [[ "$enable_flag1" == "on" ]] && [[ "$enable_flag2" == "on" ]] && result 1 "Kdump service is enabled!" || result 2 "Please try to execute <chkconfig --level 2345 kdump on>！"   
    fi
}

usage()
{
    cat << 'EOF'
    Usage:
        kdump_conman_check.sh -c before_reboot    check conman configuration before reboot    
        kdump_conman_check.sh -c after_reboot     check conman configuration after reboot
        kdump_conman_check.sh -k                  check kdump configuration
EOF
    exit 1
}

[ $# -lt 1 ] && usage

while getopts c:kh OPTION
do
    case $OPTION in
        c)
            reboot_flag=$OPTARG
            echo -e ">>>>>>>>>>>>Check the conman setup<<<<<<<<<<<"
            conman_auth;;
        k)
            echo -e ">>>>>>>>>>>>Check the kdump setup<<<<<<<<<<<"
            kdump_service_auth
            kdump_cmdline_check
            kdump_grub_check;;
        h)  usage;;
        *)  usage;;
    esac
done
