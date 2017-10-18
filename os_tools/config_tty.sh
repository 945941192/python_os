#!/bin/sh


el5=`cat /etc/issue|grep " 5\."|wc -l`

if [ "$1" = "" ];then
    tty_num=$(cat /proc/tty/driver/serial | egrep -v 'unknow|serinfo' |head -n 1| awk '{print $1}' | sed 's/://g')
    tty="ttyS${tty_num}"
    bot=$(setserial -a "/dev/$tty" | grep Baud_base | awk '{print $2}' | sed 's/,//g')
else
    tty=$1
    bot=$2
fi

function usage()
{
    echo
    echo -ne "Usage:\n"
    echo -ne "\t$0 serial_name serial_speed\n"
    echo -ne "\t$0 ttyS0|ttyS1 9600|19200|38400|57600|115200\n"
    echo
    echo -ne "For example:\n"
    echo -ne "\t$0 ttyS0 115200"
    echo
}

if ! echo $tty |grep -q ttyS;then
    usage
    exit 1
fi

if ! echo $bot"X" |grep -qE "^9600X|^115200X|^38400X|^19200X|^57600X";then
    usage
    exit 1
fi

grubby --args="console=tty0 console=$tty,$bot" --update-kernel=ALL
sed -i "/ttyS/d" /etc/securetty
echo $tty >> /etc/securetty

if [ $el5 -eq 1 ];then
    sed -i "/agetty ttyS/d" /etc/inittab
    echo "S0:2345:respawn:/sbin/agetty $tty $bot vt100-nav" >> /etc/inittab
fi
sed -i "/kernel.printk/d" /etc/sysctl.conf
echo "5 4 1 5" >  /proc/sys/kernel/printk
echo "kernel.printk = 5 4 1 5" >> /etc/sysctl.conf
