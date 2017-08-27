#coding=utf-8
import re

r_file_f = open('rtable.csv','r')
r_list = r_file_f.readlines()


print len(r_list[0].split(",")),r_list[0].split(",")
re_list1 = re.sub(r"\"\",\"\"","+",r_list[1])
print len(re_list1.split(",")),re_list1.split(",")


dict1 = {}
for index,item in enumerate(r_list[0].split(",")):
     #dict1[re_list1.split(',')[index]] = item
    print index,item
print '*'*90

for index,item in enumerate(re_list1.split(",")):
    print index,item

import csv
with open("r_test.csv","r") as f:
    reader = csv.reader(f)
    for row in reader:
        print type(row),len(row)
