#coding=utf-8

import subprocess

def cmd_out_fn(cmd,out_file_path=''):
   
    cmd_status = subprocess.call('%s >>%s 2>&1'%(cmd,out_file_path),shell=True) if out_file_path else subprocess.call('%s >/dev/null 2>&1'%cmd,shell=True)
    
    if cmd_status == 0:
        out_data = subprocess.check_output('%s'%cmd,shell=True)
    else:
        data = subprocess.Popen('%s'%cmd,shell=True,stderr=subprocess.PIPE)
        out_data = data.stderr.read()
    return cmd_status,out_data

if __name__ == '__main__':
    print("start-------")
    res,data = cmd_out_fn('ls ~/weizhanbiao','/var/log/haha')
    print res,data
