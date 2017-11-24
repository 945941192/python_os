#coding=utf-8

from django.shortcuts import render
from django.http import HttpResponse,HttpResponseRedirect,JsonResponse
from django.core.urlresolvers import reverse
from django.views.decorators.csrf import csrf_exempt

import os
import subprocess
import time

from os_web.settings import PROJEKT_DIR,FilePath
from check.models import UploadTarBallInfo,ScriptToolsInfo


def pull_gitlab():
    res = subprocess.call("cd %s && git pull origin master"%PROJEKT_DIR,shell=True)


@csrf_exempt
def handle_index(request):
    return render(request,"index/index.html")


@csrf_exempt
def handle_upload_checktarball(request):
    if request.method == "GET":
        tarball_set = UploadTarBallInfo.objects.order_by("-upload_time").all()
        return render(request,"check/upload_check_tarball.html",{"tarball_set":tarball_set})
    if request.method == "POST":
        tarball = request.FILES.get("tarball",None)
        path_status = os.path.exists(FilePath)
        if not path_status:
            os.makedirs(FilePath)
        full_path_tarball = FilePath + tarball.name
        with open(full_path_tarball,"w") as pic:
            for c in tarball.chunks():
                pic.write(c)
#check tar_ball
        pull_gitlab()
        cld_check_script_path = subprocess.check_output("find %s -name cld_check.sh"%PROJEKT_DIR,shell=True).strip()
        check_status = subprocess.call("sh %s -c -f  %s"%(cld_check_script_path,full_path_tarball),shell=True) 
#updown check report 
        tar_x_tarball = subprocess.call("cd %s && tar -zxf %s"%(FilePath,full_path_tarball),shell=True)
#save
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

@csrf_exempt
def handle_script_tools(request):
    if request.method == "GET":
        tool_id = request.GET.get("tool_id")
        tool_name = request.GET.get("tool_name","").strip()
        tool_instructions = request.GET.get("tool_instructions","")
        down = int(request.GET.get("down",0))
        save = int(request.GET.get("save",0))
        mod = int(request.GET.get("mod",0))
        dele = int(request.GET.get("del",0))
        if down == 1:
            pull_gitlab()
            file_name = subprocess.check_output("find %s -name %s"%(PROJEKT_DIR,tool_name),shell=True).strip()
            gzexe_status = subprocess.call("gzexe %s"%file_name,shell=True)
            def readFile(fn,buf_size=262144):
                f = open(fn,"rb")
                while True:
                    c = f.read(buf_size)
                    if c:
                        yield c
                    else:
                        break
                f.close()
            response = HttpResponse(readFile(file_name),content_type="application/octet-stream")
            response['Content-Disposition'] = 'attachment;filename=%s'%tool_name
            response['Content-Length'] = os.path.getsize(file_name)
            subprocess.call("cd %s"%(file_name.replace(tool_name,"")),shell=True)
            subprocess.call("rm -f %s"%file_name,shell=True)
            gzexe_file = file_name.replace(tool_name,"")+tool_name + "~"
            subprocess.call("mv %s %s"%(gzexe_file,file_name),shell=True)
            return response
        elif save == 1:
            tool_obj = ScriptToolsInfo()
            tool_obj.tool_name = tool_name
            tool_obj.tool_instructions = tool_instructions
            tool_obj.save()
            return HttpResponseRedirect(reverse("check:script_tools"))
        elif dele == 1:
            ScriptToolsInfo.objects.filter(tool_name=tool_name).delete()
            return HttpResponseRedirect(reverse("check:script_tools"))
        elif mod == 1:
            tool_obj = ScriptToolsInfo.objects.get(id=int(tool_id))
            tool_obj.tool_name = tool_name
            tool_obj.tool_instructions = tool_instructions
            tool_obj.save()
            return HttpResponseRedirect(reverse("check:script_tools"))
        else:
            script_tools_set = ScriptToolsInfo.objects.all()
            return render(request,"check/script_tools.html",{"script_tools_set":script_tools_set})