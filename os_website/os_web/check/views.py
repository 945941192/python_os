#coding=utf-8

from django.shortcuts import render
from django.http import HttpResponse,HttpResponseRedirect,JsonResponse
from django.core.urlresolvers import reverse
from django.views.decorators.csrf import csrf_exempt

import os
import subprocess
import time
import base64

from os_web.settings import OSSBUCKET  
from os_web.settings import PROJEKT_DIR,FilePath
from check.models import UploadTarBallInfo,ScriptToolsInfo
from tools.util import pull_gitlab


@csrf_exempt
def handle_index(request):
    return render(request,"index/index.html")

@csrf_exempt
def handle_upload_checktarball(request):
    if request.method == "GET":
        tarball_set = UploadTarBallInfo.objects.order_by("-upload_time").all()
        return render(request,"check/upload_check_tarball.html",{"tarball_set":tarball_set})
    elif request.method == "POST":
        tarball = request.FILES.get("tarball")
        remarks = request.POST.get("remarks")
        path_status = os.path.exists(FilePath)
        if not path_status:
            os.makedirs(FilePath)
        full_path_tarball = FilePath + tarball.name
#save /var/log
        with open(full_path_tarball,"w") as pic:
            for c in tarball.chunks():
                pic.write(c)
#check tar_ball
        pull_gitlab()
        cld_check_script_path = subprocess.check_output("find {PROJEKT_DIR} -name cld_check.sh".format(PROJEKT_DIR=PROJEKT_DIR),shell=True).strip()
        check_status = subprocess.call("sh {cld_check_script_path} -c -f  {full_path_tarball}".format(cld_check_script_path=cld_check_script_path,full_path_tarball=full_path_tarball),shell=True) 
#tar -zxf tarball 
        tar_x_tarball = subprocess.call("cd {FilePath} && tar -zxf {full_path_tarball}".format(FilePath=FilePath,full_path_tarball=full_path_tarball),shell=True)
#upload oss bucket  *.tar.gz  and check_report.html
        HOST = base64.b64decode(OSSBUCKET.get('HOST'))
        ID = base64.b64decode(OSSBUCKET.get('ID'))
        KEY = base64.b64decode(OSSBUCKET.get('KEY'))
        BUCKETNAME = OSSBUCKET.get('BUCKETNAME')
        try:
            upload_oss_back_info = subprocess.check_output("osscmd put {full_path_tarball} oss:{BUCKETNAME} --host {HOST} --id {ID} --key {KEY}".format(BUCKETNAME=BUCKETNAME,full_path_tarball=full_path_tarball,HOST=HOST,ID=ID,KEY=KEY),shell=True)
        except Exception as e:
            print e
            return HttpResponse("{tarball_name}上传oss失败".format(tarball_name=tarball.name))
        tarball_url = upload_oss_back_info.split("URL is: ")[1].split('\n')[0].replace("%2F","/")
        time_data = tarball.name.replace(".tar.gz","")
        check_report_html_path = full_path_tarball.replace(".tar.gz","") + "/" + "check_report_" + time_data + ".html"
        try:
            upload_check_report_html_oss_back_info = subprocess.check_output("osscmd put {check_report_html_path} oss:{BUCKETNAME} --host {HOST} --id {ID} --key {KEY}".format(BUCKETNAME=BUCKETNAME,check_report_html_path=check_report_html_path,HOST=HOST,ID=ID,KEY=KEY),shell=True)
        except Exception as e:
            tarball_base_path = full_path_tarball.replace(".tar.gz","")
            subprocess.call("cd {FilePath} && rm -rf {tarball_base_path}".format(FilePath=FilePath,tarball_base_path=tarball_base_path+"*"),shell=True)
            return HttpResponse("检查 {tarball_name} 没有生成check report，请输入正确的tarball".format(tarball_name=tarball.name))
        check_report_url = upload_check_report_html_oss_back_info.split("URL is: ")[1].split('\n')[0].replace("%2F","/")
#rm local tarball*
        tarball_base_path = full_path_tarball.replace(".tar.gz","")
        res = subprocess.call("cd {FilePath} && rm -rf {tarball_base_path}".format(FilePath=FilePath,tarball_base_path=tarball_base_path+"*"),shell=True)
#save
        tarball_obj = UploadTarBallInfo()
        tarball_obj.file_name = tarball.name
        tarball_obj.remarks = remarks
        tarball_obj.up_status = 1
        tarball_obj.tarball_url = tarball_url 
        if check_status == 0:
            tarball_obj.check_status = 1
        tarball_obj.check_report_url = check_report_url
        tarball_obj.save()

        return HttpResponseRedirect(reverse("check:upload_check_tarball"))

@csrf_exempt
def handle_script_tools(request):
    if request.method == "GET":
        tool_id = request.GET.get("tool_id")
        tool_name = request.GET.get("tool_name","").strip()
        down = int(request.GET.get("down",0))
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
        elif dele == 1:
            ScriptToolsInfo.objects.filter(tool_name=tool_name).delete()
            return HttpResponseRedirect(reverse("check:script_tools"))
        else:
            script_tools_set = ScriptToolsInfo.objects.all()
            return render(request,"check/script_tools.html",{"script_tools_set":script_tools_set})
    elif request.method == "POST":
        add = request.POST.get("add")
        modify = request.POST.get("modify")
        tool_id = request.POST.get("tool_id")
        tool_name = request.POST.get("tool_name")
        tool_instructions = request.POST.get("tool_instructions")
        if add == "1":
            tool_obj = ScriptToolsInfo()
            tool_obj.tool_name = tool_name
            tool_obj.tool_instructions = tool_instructions
            tool_obj.save()
            return JsonResponse({"msg":"ok"})
        elif modify == "1":
            tool_obj = ScriptToolsInfo.objects.get(id=int(tool_id))
            tool_obj.tool_name = tool_name
            tool_obj.tool_instructions = tool_instructions
            tool_obj.save()
            return JsonResponse({"msg":"ok"}) 

