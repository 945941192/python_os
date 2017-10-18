#!/bin/bash
#########################################################################
# File Name: config_kdump.sh
# Author: PeiYuan
# Mail: peiyuan.wc@alibaba-inc.com
# Description:
# Created Time: Wed Jul 26 13:12:59 2017
#########################################################################
el5=$(cat /etc/redhat-release | grep -c '5\.')
el6=$(cat /etc/redhat-release | grep -c '6\.')
el7=$(cat /etc/redhat-release | grep -c '7\.')
# el6_kernel=$(uname -r)
device=$(df -lh /var |tail -1 |awk '{print $1}')
filesystem=$(mount|grep -w $device|awk '{print $(NF-1)}')

> /etc/kdump.conf
echo "$filesystem $device" >> /etc/kdump.conf
echo "path /var/crash" >> /etc/kdump.conf
echo "core_collector makedumpfile -c --message-level 1 -d 31" >> /etc/kdump.conf
echo "extra_modules mpt2sas mpt3sas megaraid_sas hpsa ahci" >> /etc/kdump.conf
echo "default reboot" >> /etc/kdump.conf

if [ $el7 -eq 1 ];then
    systemctl enable kdump
else
    sed -i "s/mkdumprd -d/mkdumprd --allow-missing -d/" /etc/init.d/kdump
    chkconfig --level 2345 kdump on
fi

if [ $el7 -eq 1 ];then
    grubby --args='crashkernel=auto' --update-kernel=ALL
elif [ $el6 -eq 1 ];then
    grubby --args='crashkernel=256M' --update-kernel=ALL
else
    grubby --args='crashkernel=256M@64M' --update-kernel=ALL
fi
