#coding=utf-8

from __future__ import division
import sys
import os
import time
import getopt
import subprocess
from datetime import datetime
from types import FunctionType

from os_collection_type_info import TypeDataDict,SystemInfoData,copy_system_files_list


################################### Global Variable ################################

LOGDATE = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
MYSELF = "crash_log.%s"%LOGDATE
SLOGDIR = "/var/log"
LOCK_FILE = ""
LOGDIR = ""
CALLALL = 0

list_items = 0
target_cmd = ""
success = 0
fail = 1
warn = 2
skip = 3

file_name = sys.argv[0]

################################ End Global Varible ################################


################################ Utile function    #################################


def process_speed_decorator(num):
    def wrapp(fn):
        def test(*args, **kargs):
            data = fn(*args,**kargs)
            sys.stdout.write(' ' * 100 + '\r')
            sys.stdout.flush()
            if data:
                for i in data:
                    print i
            if num == 10:
                sys.stdout.write(str((num/10)*100)+ '% : '+'#'*10*num+'\n')
            else:
                sys.stdout.write(str((num/10)*100)+"% : "+'#'*10*num+'\r')
            sys.stdout.flush()
        return test
    return wrapp


def shell_cmd_out_fn(cmd,out_file_path=''):
    """
         if out_file_path not null 2>>out_file_path
    """
    cmd_status = subprocess.call('%s >>%s 2>&1'%(cmd,out_file_path),shell=True) if out_file_path else subprocess.call('%s >/dev/null 2>&1'%cmd,shell=True)

    if cmd_status == 0:
        out_data = subprocess.check_output('%s'%cmd,shell=True)
    else:
        data = subprocess.Popen('%s'%cmd,shell=True,stderr=subprocess.PIPE)
        out_data = data.stderr.read()
    return cmd_status,out_data



############################## End Utile function ################################






################################ Logic function ####################################

@process_speed_decorator(1)
def prepare_to_run():
    global LOCK_FILE
    global LOGDIR
    LOCK_FILE = "{}/{}.pid".format(SLOGDIR,MYSELF)
    LOGDIR = "{}/{}".format(SLOGDIR,MYSELF)
    shell_cmd_out_fn('rm -rf %s'%LOGDIR)
    shell_cmd_out_fn('mkdir -p %s'%LOGDIR)

@process_speed_decorator(2)
def check_free_space(LOGDIR,target):
    threshold = target*1024*1024
    status,out_data = shell_cmd_out_fn("df -P $(dirname %s) | grep -v Filesystem | awk '{print $(NF-2)}'"%LOGDIR)
    current = int(out_data.strip())
    if current < threshold:
        return ['错误----》磁盘空间不够']
        os._exit(0)
    else:
        return ["free_space_check is ok"]


def show_system_info():
    show_system_cmd = {"System:      ":"cat /etc/redhat-release",
                        "Hostname:    ":"hostname -f",
                        "Kernel:      ":"uname -r",
                        "Arch:        ":"uname -i",
}
    for info in show_system_cmd:
        out_data = subprocess.check_output(show_system_cmd[info],shell=True)
        print "%s %s"%(info,out_data)


############################### End Logic function #################################



###################################### Main #########################################

def usage():
    print "Usage:"
    print "         %s -h                                    display help information"%file_name
    print "         %s -V                                    debug mode."%file_name
    print "         %s -d <target dir>                       All log will be generated to target dir. "%file_name
    print "         %s -t <target dir>                       Call target item to get info."%file_name
    print "         %s -a                                    Collect all information."%file_name
    print "         %s -l                                    Just list items out"%file_name
    print "Example:"
    print "         %s -d /apsara -a"
    print "         %s -t disks_io_detail"
    os._exit(0)

def command_line_arguments():
    try:
        opts,args = getopt.getopt(sys.argv[1:],"d:t:ahlV")
        for op,value in opts:
            if op == '-h':
                usage()
            elif op == '-t':
                target_cmd = value
            elif op == '-a':
                CALLALL = 1
            elif op == '-d':
                SLOGDIR = value
            elif op == '-l':
                list_items = 1;
    except Exception as e:
        print "请输入正确命令行参数"
        usage()


if __name__ == "__main__":
    command_line_arguments()
    prepare_to_run()
    check_free_space(LOGDIR,5)
    show_system_info()
     
#################################### End Main #######################################
