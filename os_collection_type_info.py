#coding=utf-8

"""
    defind the os collection data type 

"""

TypeDataDict = {
"SystemInfoData:system_info:Start collecting system information ...":"SystemInfoData",
#'NetworkInfoData:network_info:Start collecting network information ...',
#'BMCInfoData:bmc_info:Start collecting bmc information ...',
#'Dom0InfoData:dom0_info:Start collecting dom0 information ...',
#'DiskInfoData:disk_info:Start collecting disk information ...',
}

SystemInfoData = [
"history:cat $HOME/.bash_history::history:",
"uname:uname -a::uname_a:",
"df:df -h::df_h:",
"free:free -m::free_m:",
"cp_system_files:copy_system_files:path:copy_system_files:2:",
#"mpstat:mpstat -P ALL -I ALL::mpstat_A:2:",
#"top10_mem:get_top10_mem_process_info:path:top_mem_order:2:",
]

copy_system_files_list = [

]

######################################################################
