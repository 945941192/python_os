#coding=utf-8

r_file_f = open('/root/weizhanbiao/r_c_file/rtable.csv','r')
r_list = r_file_f.readlines()

print r_list[0],len(r_list[0].split(','))

print r_list[1],len(r_list[0].split(","))
print r_list[-1],len(r_list[0].split(","))
