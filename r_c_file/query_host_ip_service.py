#coding=utf-8

import getopt
import os,sys,csv

in_info = None

file_list = ['rtable.csv','container_arrangement.csv']

def query_ip_hostname_service(in_info):
    in_info_dict = ''
    for file_name in file_list:
        with open(file_name,'rb') as myFile:  
            lines = csv.DictReader(myFile)
            for info in lines:
                in_info_dict = info if in_info in info.values() else ''
        #    if in_info in info.values():
         #       print info
                if in_info_dict:
                    print in_info_dict
                    break 
                else:
                    continue

def usage():
    print "Usage:"
    print "*"*20
    os._exit(0) 

if __name__ == "__main__":

    try:
        opts,args = getopt.getopt(sys.argv[1:],"hi:")
        print sys.argv,'------',opts
        for op,value in opts:
            if op == '-h':
                usage()
            elif op == '-i':
                in_info = value
                print 'ip_info' ,in_info
    except Exception as e:
        print "请输入正确命令行参数"
        usage()


    query_ip_hostname_service(in_info)
