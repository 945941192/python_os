#! /bin/bash

host_name='a.b.1.3'
ip_name='1.2.3.4'

re_ip_name="^[0-9]+.[0-9]+.[0-9]+.[0-9]*$"

if [[ ${ip_name} =~ ${re_ip_name} ]]
then 
    echo ok
else
    echo no ip
fi
