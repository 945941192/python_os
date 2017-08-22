#coding=utf-8

import sys
import os
import getopt
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


###################################### Main #########################################

if __name__ == "__main__":
    
    print 'hello'



#################################### End Main #######################################
