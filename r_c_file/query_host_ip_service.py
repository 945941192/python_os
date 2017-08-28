#coding=utf-8

import getopt
import os,sys,csv

in_info = None
file_name = sys.argv[0]


def query_ip_hostname_service(in_info):

#r file

    in_info_dict = ''
    with open('rtable.csv','rb') as myFile:  
        lines = csv.DictReader(myFile)
        for info in lines:
            in_info_dict = info if in_info in info.values() else ''
            if in_info_dict:
                print "The host %s -----new_appgroup(%s)"%(in_info_dict['hostname'],in_info_dict['new_appgroup'])
                break

    if in_info_dict == '':
        print 'No query to this %s  host'%in_info
        os._exit(1)
    

#c file

    docker_service_list = []
    with open('container_arrangement.csv','rb') as myFile:
        lines = csv.DictReader(myFile)
        for info in lines:
            if in_info in info.values():
                docker_service_list.append(info)
                print "     |"
                print "     |"
                print "     ----docker_ip(%s) service_instance(%s)"%(info['ip'],info['service_instance'])
    print len(docker_service_list)
    


def usage():
    print "Usage:"
    print "    %s -q <query hostname or ip>        Query hostname or ip "%file_name
    print "Example:"
    print "    %s -q 10.1.7.32"%file_name
    print "    or:"
    print "    %s -q rc85c6128.cloud.nu17"%file_name

    os._exit(0) 

if __name__ == "__main__":

    try:
        opts,args = getopt.getopt(sys.argv[1:],"hq:")
        for op,value in opts:
            if op == '-h':
                usage()
            elif op == '-q':
                in_info = value
        
        if len(opts) == 0:
            usage()

    except Exception as e:
        print "请输入正确命令行参数"
        usage()


    query_ip_hostname_service(in_info)
