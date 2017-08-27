#coding=utf-8

import getopt
import os,sys,csv



ip_info = ''
hostname_info = ''


def query_hostname_ip_service(ip,hostname):

    ip_info_dict = {}
    local_host_dict = {}

    with open('rtable.csv','rb',encoding='utf-8') as myFile:  
        lines = csv.reader(myFile)  
        for info in lines:
            if 'ServiceTag' in info:
                type_list = info
            if ip:
                if ip in info:
                    ip_list = info
    print type_list,len(type_list),ip_list,len(ip_list)

def usage():
    print "Usage:"
    print "*"*20
    os._exit(0) 

if __name__ == "__main__":

    try:
        opts,args = getopt.getopt(sys.argv[1:],"hi:n:")
        print sys.argv,'------',opts
        for op,value in opts:
            if op == '-h':
                usage()
            elif op == '-i':
                ip_info = value
                print 'ip_info' ,ip_info
            elif op == '-n':
                hostname_info = value
                print 'hostname',hostname_info
    except Exception as e:
        print "请输入正确命令行参数"
        usage()


    query_hostname_ip_service(ip=ip_info,hostname=hostname_info)
