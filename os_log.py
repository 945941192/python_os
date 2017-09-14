#coding=utf-8
from __future__ import division
import os
import sys
import getopt
import subprocess
from datetime import datetime
from types import FunctionType
############# Global Variable ############

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
########### End Global Variable ##########

TypeDataList = [
'SystemInfoData:system_info:Start collecting system information ...',
'NetworkInfoData:network_info:Start collecting network information ...',
'BMCInfoData:bmc_info:Start collecting bmc information ...',
#'Dom0InfoData:dom0_info:Start collecting dom0 information ...',
#'DiskInfoData:disk_info:Start collecting disk information ...',
]
SystemInfoData = [
'history:cat $HOME/.bash_history::history:',
'uname:uname -a::uname_a:',
'df:df -h::df_h:',
"ps:ps -Le -wwo 'pid,psr,pcpu,pmem,rsz,vsz,stime,user,stat,uid,wchan=WIDE-WCHAN-COLUMN,args' --sort rsz::ps_Le_wwo_rsz:2:",
'free:free -m::free_m:',
'last:last reboot::last_reboot:2:',
'chkconfig:chkconfig --list::chkconfig__list:2:',
'runlevel:runlevel::runlevel:2:',
'uptime:uptime::uptime:2:',
'mount:mount::mount:2:',
'top_thread:top -H -b -n 1::top_H_b:2:',
'top:top -b -n 1::top_b:2:',
'kdump:/etc/init.d/kdump status::kdump_status:2:',
'lsmod:lsmod::lsmod:2:',
'cmdline:cat /proc/cmdline::cat_proc_cmdline:2:',
'meminfo:cat /proc/meminfo::cat_proc_meminfo:2:',
'slabinfo:cat /proc/slabinfo::cat_proc_slabinfo:2:',
'vmallocinfo:cat /proc/vmallocinfo::cat_vmallocinfo:2:',
'swaps:cat /proc/swaps::cat_proc_swaps:2:',
'cpuinfo:cat /proc/cpuinfo::cat_proc_cpuinfo:2:',
'dmidecode:dmidecode::dmidecode:2:',
'dmesg:dmesg::dmesg:2:',
'ulimit:ulimit -a::ulimit_a:2:',
'crontab:crontab -l::crontab_l:2:',
'mpstat:mpstat -P ALL -I ALL::mpstat_A:2:',
'iostat:iostat -xm 1 6::iostat_xm:2:',
'vmstat:vmstat 1 6::vmstat:2:',
'tsar:tsar -n 6:check:tsar_n6:2:',
'blkid:blkid::blkid:2:',
'lsscsi:lsscsi::lsscsi:2:',
'mdadm:mdadm --detail::mdadm__detail:2:',
'lvs_detail:lvs -vv::lvs_vv:2:',
'lvs:lvs -v::lvs_v:2:',
'vgs:vgs::vgs:2:',
'pvs:pvs::pvs:2:',
'journalctl:journalctl -xn:check:journalctl_xn:2:',
'cp_system_files:copy_system_files:path:copy_system_files:2:',
'mpstat:mpstat -P ALL -I ALL::mpstat_A:2:',
'top10_mem:get_top10_mem_process_info:path:top_mem_order:2:',
'top10_cpu:get_top10_cpu_process_info:path:top_cpu_order:2:',
]
NetworkInfoData = [
'sarnet:sar -n DEV 1 5::sar_n_dev:',
'ss:ss -anpei::ss_anpei:',
'ipaddr:ip addr show::ip_addr_show:',
'iproute:ip route show::ip_route_show:',
'ifconfig:ifconfig::ifconfig:',
'ifconfig_all:ifconfig -a::ifconfig_a:',
'route_cache:route -Cn::route_Cn:',
'route:route -n::route_n:',
'netstat:netstat -anpo::netstat_anpo:',
'netstat_pro:netstat -s::netstat_s:',
'netstat_dev:netstat -i::netstat_i:',
'bonding_info:get_bonding_info:path:bonding_info:',
'netcard_info:get_netcard_info:path:netcard_info:',
]

BMCInfoData = [
'ipmifru:ipmitool fru list::ipmitool_fru_list:2:',
'ipmilan:ipmitool lan print 1::ipmitool_lan_print_1:2:',
'ipmimc:ipmitool mc info::ipmitool_mc_info:2:',
'ipmisensor:ipmitool sensor list::ipmitool_senso_list:2:',
'ipmisdr:ipmitool sdr list::ipmitool_sdr_list:2:',
'ipmisel:ipmitool sel elist::ipmitool_sel_elist:2:',
]


############# decorator ####################
def func_output_redirection(func_name,log_dir):
    origin = sys.stdout
    f = open(log_dir,'w')
    sys.stdout = f
    try:
        eval(func_name)(log_dir)
    except Exception as e:
        print e
    sys.stdout = origin
    f.close()

def func_output_redirection2(fun):
    def wrap(log_dir):
        origin = sys.stdout
        f = open(log_dir,'w')
        sys.stdout = f
        try:
            fun(log_dir)
        except Exception as e:
            print e
        sys.stdout = origin
        f.close()
    return wrap

def progress_speed_decorator(num):
    def wrapp(fn):
        def test(*args, **kw):
            fn(*args,**kw)
            sys.stdout.write(' ' * 10 + '\r')
            sys.stdout.write(fn.__name__+"finished\n")
            sys.stdout.flush()
            sys.stdout.write(' ' * 10 + '\r')
            sys.stdout.flush()
            if num == 7:
                sys.stdout.write(str((num/10)*100)+"%\n")
            else:
                sys.stdout.write(str((num/10)*100)+"%")
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


########### decorator end ##################

#########SystemInfoData function#########
#@func_output_redirection2
def copy_system_files(path):
    file_dir = subprocess.check_output('dirname %s'%path,shell=True).strip()
    #system_files_list = ['/etc/kdump.conf','/boot/grub/','/etc/sysctl.conf','/var/log/kern','/etc/security/limits.conf','/var/log/secure','/var/log/secure-*','/var/log/messages','/var/log/messages-*',]
    system_files_list = ['/var/log/kern','/var/log/messages']
    for system_file in system_files_list:
        copy_files(system_file,file_dir)
    return success
def copy_files(sys_file,file_dir,arg=''):
    if arg == 'ignore':
        res = subprocess.call('cp -r %s %s 2>/dev/null'%(sys_file,file_dir),shell=True)
    else:
#        import pdb;pdb.set_trace()
        res = subprocess.Popen('cp -r %s %s'%(sys_file,file_dir),stderr=subprocess.PIPE,shell=True)
        #if res != '':
         #   print res.stderr.read()

#@func_output_redirection2        
def get_top10_mem_process_info(path):
    dir = subprocess.check_output('dirname %s'%path,shell=True).strip()
    custom_field = 'pid,comm,psr,pmem,rsz,vsz,stime,user,stat,uid,args'
    #不加装饰器的原因
    subprocess.call('ps -e -wwo %s --sort rsz >> %s'%(custom_field,path),shell=True)
    top10_mem = subprocess.check_output("tail -10 %s | awk '{print $1}'"%path,shell=True)
    #print "top10_mem--------------------------->",top10_mem
    get_top10_process_info(top10_mem,dir,path)
    return success
    

def get_top10_process_info(top10,log_dir,path):
    #print top10.split('\n')
    for pid in top10.split('\n')[:-1]:
        p_dir = "{}/{}".format(log_dir,pid)
        res = subprocess.call("ls /proc/%s 1>/dev/null 2>>%s"%(pid,path),shell=True)
        if res != 0:
			continue
        files = subprocess.check_output('ls /proc/%s 2>>%s'%(pid,path),shell=True).split('\n')[:-1]
        dir_exis = subprocess.call('[ -d %s ]'%p_dir,shell=True)
        file_exclude = ['task','pagemap']
        if dir_exis == 0:
            continue
        else:
            subprocess.call('mkdir -p %s'%p_dir,shell=True)
            subprocess.call('pmap -x  %s > %s/pmap_x 2>&1'%(pid,p_dir),shell=True)
            subprocess.call('pmap -d  %s > %s/pmap_d 2>&1'%(pid,p_dir),shell=True)
            for file in files:
                if file in file_exclude:
                    continue
                else:
                    sys_file = "/proc/%s/%s"%(pid,file)
                    file_dir = "{}/{}".format(log_dir,pid)
                    copy_files(sys_file,file_dir,arg='ignore')     


def get_top10_cpu_process_info(path):
    dir = subprocess.check_output('dirname %s'%path,shell=True).strip()
    custom_field = 'pid,comm,psr,pmem,rsz,vsz,stime,user,stat,uid,args'
    subprocess.call('ps -e -wwo %s --sort pcpu >> %s'%(custom_field,path),shell=True)
    top10_cpu = subprocess.check_output("tail -10 %s | awk '{print $1}'"%path,shell=True)
    get_top10_process_info(top10_cpu,dir,path)
    return success

#########SystemInfoData functin end######





#########NetworkInfoData function#########
def get_bonding_info(path):
    status =  subprocess.call("ls /proc/net/bonding/ 1>/dev/null 2>>%s"%path,shell=True)
    if status != 0:
        return fail
    bonds = subprocess.check_output("ls /proc/net/bonding/",shell=True).split('\n')[:-1]
    for bond in bonds:
        bond_path = path+"_"+bond
        subprocess.call("cat /proc/net/bonding/%s >> %s"%(bond,bond_path),shell=True)
    return sucess    

def get_netcard_info(path):
    log_temp = subprocess.check_output("dirname %s"%path,shell=True).strip()
    nic_devices = subprocess.check_output("ls /sys/class/net",shell=True).split('\n')[:-1]
    subprocess.call("echo 'nice_list='%s >> %s"%(' '.join(nic_devices),path),shell=True)
    for device in nic_devices:
        if device != 'lo' and os.path.isdir("/sys/class/net/%s"%device):
            ndir = log_temp + '/' + device
            #os.makedirs(ndir)
            #os.system("/bin/cp -r /sys/calss/net/%s/* %s"%(device,ndir))
            res = subprocess.call("mkdir -p %s"%ndir,shell=True)
            subprocess.call("/bin/cp -r /sys/class/net/%s/* %s 2>>%s"%(device,ndir,path),shell=True)
    return success

########NetworkInfoData function end#####

def result(res):
    if res == 0:
        sys.stdout.write("\033[1;32;40m OK \033[0m\n")
    elif res == 2:
        sys.stdout.write("\033[1;33;40m WARNING \033[0m\n")
    elif res == 3:
        sys.stdout.write("\033[1;33;40m SKIP \033[0m\n")
    else:
        sys.stdout.write("\033[1;31;40m FAIL \033[0m\n")    

def compress_log():

    print "Start compressing log dir ..."
    log_dir = "%s/%s"%(SLOGDIR,MYSELF)
    os.chdir(SLOGDIR)
    cmd_list = [
                "rm -f %s.tar.gz"%(log_dir),
                "tar -Pzcf %s.tar.gz %s"%(log_dir,MYSELF),
                "md5sum %s.tar.gz > %s.tar.gz.md5sum"%(log_dir,MYSELF)
               ]
    list1 = map(lambda cmd : subprocess.call(cmd,shell=True),cmd_list)
   # for cmd in cmd_list:
    #    data = subprocess.call(cmd,shell=True)
     #   print data,cmd



def list_flags():
    for info_type in TypeDataList:
        for i in eval(info_type.split(':')[0]):
            print i.split(':')[0]

def collection_all():
    for info_type in TypeDataList:
        type_info  = info_type.split(':')[0]
        dir_info = info_type.split(':')[1]
        output_info = info_type.split(':')[2]
        full_path = '{}/{}'.format(LOGDIR,dir_info)
  #      print 'type_info--->%s'%type_info
 #       print 'dir_info---->%s'%dir_info
#        print 'full_path--->%s'%full_path
        collection_items(type_info,output_info,full_path)
            
def collection_items(type_info,output_info,full_path):
    print " "
    print "\033[1;32;40m %s \033[0m\n"%output_info
    print " "
    mkdir_status = subprocess.call('mkdir -p %s'%full_path,shell=True)    
    
    for info in eval(type_info):
        flag = info.split(':')[0]
        cmd = info.split(':')[1]
        action = info.split(':')[2]
        file_name = info.split(':')[3]
        default = info.split(':')[4]
        log_dir = "{}/{}".format(full_path,file_name)
        if target_cmd != '' and target_cmd == flag:
            cmd_log(cmd,log_dir,action)
            continue
        if CALLALL == 1:
            cmd_log(cmd,log_dir,action)
        else:
            if default != 'no':
                cmd_log(cmd,log_dir,action)


def cmd_log(cmd,log_dir,action):
    sys.stdout.write('%-85s'%cmd[:80])  
    cmd_exit_status = if_command_not_exit(cmd)
    if cmd_exit_status == fail:
       # print '命令或者函数不存在'
       sys.stdout.write("\033[1;33;40m SKIP \033[0m\n")
       pass
    elif cmd_exit_status == success:
    #    sys.stdout.write('%-85s'%cmd[:80])
        subprocess.call('echo Command:%s >> %s'%(cmd,log_dir),shell=True)
        if action == 'path':
            #func_output_redirection(cmd,log_dir)                
           res =  eval(cmd)(log_dir)
           result(res)
        else:
            res = subprocess.call('eval %s >> %s 2>&1'%(cmd,log_dir),shell=True)
            if res == 0:
                sys.stdout.write("\033[1;32;40m OK \033[0m\n")
            else:
                sys.stdout.write("\033[1;31;40m FAIL \033[0m\n")

def if_command_not_exit(cmd):
    if if_command_exist(cmd) == success:
        return success
    else:
        return fail

def if_command_exist(cmd):
    res = subprocess.call('%s > /dev/null 2>&1'%cmd,shell=True)
    if res == 0:
        return success
    else:
        try:
           if isinstance(eval(cmd),FunctionType):
                #eval(cmd).__call__()
           #     print "Function %s 存在---------》%s"%(cmd,cmd)
                return success
        except Exception as e:
            #print e
            return fail
 


#@progress_speed_decorator(7)
def start_collection():
    if list_items == 1:
        list_flags()
    else:
        collection_all()


#@progress_speed_decorator(4)
def check_single_instance():
    lock_status = subprocess.call('[ -f %s ]'%LOCK_FILE,shell=True)
#    print "LOCK_FILE %d"%lock_status
    if lock_status == 0:
        print '%s 正在运行，请等待文件运行完毕再重试'
        os._exit(0)
    

#@progress_speed_decorator(3)
def show_system_info():
    print "System:       %s"%(subprocess.check_output('cat /etc/redhat-release',shell=True))
    print "Hostname:     %s"%(subprocess.check_output('hostname -f',shell=True))
    print "Kernel:       %s"%(subprocess.check_output('uname -r',shell=True))
    print "Arch:         %s"%(subprocess.check_output('uname -i',shell=True))


#@progress_speed_decorator(2)
def free_space_check(LOGDIR,target):
    threshold = target*1024*1024
    current = int(subprocess.check_output("df -P $(dirname %s) | egrep -v 'Used|Filesystem' | awk '{print $(NF-2)}'"%LOGDIR,shell=True).strip())
    if current < threshold:
        print '错误----》磁盘空间不够'
        os._exit(0)

#@progress_speed_decorator(1)
def prepare_to_run():
    global LOCK_FILE
    global LOGDIR
    LOCK_FILE = "{}/{}.pid".format(SLOGDIR,MYSELF)
    LOGDIR = "{}/{}".format(SLOGDIR,MYSELF)
    ret1 = subprocess.call("rm -rf %s"%LOGDIR,shell=True)
    ret2 = subprocess.call("mkdir -p %s"%LOGDIR,shell=True)

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

 

if __name__ == "__main__":

#    print "所有参数",sys.argv
    try:
        opts,args = getopt.getopt(sys.argv[1:],"d:t:ahlV")
#        print sys.argv,'------',opts
        for op,value in opts:
            if op == '-h':
                usage()
            elif op == '-t':
                target_cmd = value
#                print 'hello' ,target_cmd
            elif op == '-a':
                CALLALL = 1
            elif op == '-d':
                SLOGDIR = value
            elif op == '-l':
                list_items = 1;
            else:
                usage()
    except Exception as e:
        print "请输入正确命令行参数"
        usage()

    prepare_to_run()
    free_space_check(LOGDIR,5) 
    show_system_info()
    check_single_instance()
    start_collection()
    compress_log()

