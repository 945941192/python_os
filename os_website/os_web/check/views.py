#coding=utf-8

from django.shortcuts import render
from django.http import HttpResponse,HttpResponseRedirect,JsonResponse
from django.core.urlresolvers import reverse
from django.views.decorators.csrf import csrf_exempt

import os
import subprocess

from check.models import UploadTarBallInfo


@csrf_exempt
def test(request):
#    return render(request,"check/upload_check_tarball.html")
    return HttpResponse("nicai")
    
@csrf_exempt
def handle_upload_checktarball(request):
    if request.method == "GET":
        tarball_set = UploadTarBallInfo.objects.order_by("-upload_time").all()
        return render(request,"check/upload_check_tarball.html",{"tarball_set":tarball_set})
    if request.method == "POST":
        tarball = request.FILES.get("tarball",None)
 #保存tarball到/var/os_tarball       
        FilePath = "/var/log/"
        path_status = os.path.exists(FilePath)
        if not path_status:
            os.makedirs(FilePath)
        full_path_tarball = FilePath + tarball.name
        with open(full_path_tarball,"w") as pic:
            for c in tarball.chunks():
                pic.write(c)
######check tar_ball
        check_status = subprocess.call("sh /root/python_os/os/cld_check.sh -c -f  %s"%full_path_tarball,shell=True) 

######updown check report 
        tar_x_tarball = subprocess.call("cd %s && tar -zxf %s"%(FilePath,full_path_tarball),shell=True)


######将上传的ball信息保存
        tarball_obj = UploadTarBallInfo()
        tarball_obj.file_name = tarball.name
        tarball_obj.up_status = 1
        if check_status == 0:
            tarball_obj.check_status = 1
        tarball_obj.save()

        return HttpResponseRedirect(reverse("check:upload_check_tarball"))

@csrf_exempt
def handle_show_checkreport(request):
    tarball_name = request.GET.get("tarball")
    FilePath = "/var/log/"
    full_path_tarball = FilePath + tarball_name
    tar_x_tarball = subprocess.call("cd %s && tar -zxf %s"%(FilePath,full_path_tarball),shell=True)
    check_report_path = full_path_tarball.replace(".tar.gz","") + "/" + "check_report.html"
    f = open(check_report_path,"r")
    report_html_list = f.readlines()
    f.close()
    check_report_html = ''.join(report_html_list)
    return HttpResponse(check_report_html)

@csrf_exempt
def handle_down_check_report(request):
    tarball_name = request.GET.get("tarball")
    FilePath = "/var/log/"
    file_name = FilePath + tarball_name.replace(".tar.gz","") + "/" + "check_report.html"
    def readFile(fn, buf_size=262144): 
        f = open(fn, "rb")  
        while True: 
            c = f.read(buf_size)  
            if c:  
                yield c  
            else:  
                break  
        f.close() 
    response = HttpResponse(readFile(file_name), content_type='application/octet-stream')
    response['Content-Disposition'] = 'attachment;filename=%s' %(tarball_name + '_' + file_name.split("/")[-1]) 
    response['Content-Length'] = os.path.getsize(file_name)
    return response   
