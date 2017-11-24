
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
from aliyun.models import CloudType,CloudVersion,ProjectInfo,HostNameInfo,HostCheckDateInfo_0,HostCheckDateInfo_1,HostCheckDateInfo_2,HostCheckDateInfo_3,HostCheckDateInfo_4,HostCheckDateInfo_5,HostCheckDateInfo_6,HostCheckDateInfo_7,HostCheckDateInfo_8,HostCheckDateInfo_9,HostInfo_0,HostInfo_1,HostInfo_2,HostInfo_3,HostInfo_4,HostInfo_5,HostInfo_6,HostInfo_7,HostInfo_8,HostInfo_9,HostCheckInfo_0,HostCheckInfo_1,HostCheckInfo_2,HostCheckInfo_3,HostCheckInfo_4,HostCheckInfo_5,HostCheckInfo_6,HostCheckInfo_7,HostCheckInfo_8,HostCheckInfo_9
from tools.util import pull_gitlab

################################# select2 ajax #######################################
@csrf_exempt
def handle_project_list(request):
    #only cloud_version_id can find  cloud-version-project info
    #    cloud_type_id = request.GET.get('cloud_type_id')
    cloud_version_id = request.GET.get('cloud_version_id')
    key = request.GET.get('q')
    project_version_obj = CloudVersion.objects.get(version_id=int(cloud_version_id))
    #project_objs = ProjectInfo.objects.only("project_name").all()
    project_objs = ProjectInfo.objects.filter(project_version_obj=project_version_obj)
    if key:
        project_objs = project_objs.filter(project_name__contains=key)
    return JsonResponse({"results":[{"id":obj.project_id,"text":obj.project_name} for obj in project_objs]})


################################# select2 ajax end #######################################

@csrf_exempt
def handle_cloud_version(request):
    version_set = CloudVersion.objects.filter(cloud_obj__cloud_type="专有云")
    return render(request,"aliyun/cloud_version.html",{"version_set":version_set})


@csrf_exempt
def handle_version_project(request):
    version_id = request.GET.get('version_id')
    version = request.GET.get('version')
    project_set = ProjectInfo.objects.filter(project_version_obj__version_id=int(version_id))
    return render(request,"aliyun/version_project.html",{"project_sets":project_set,"type_info":version})

@csrf_exempt
def handle_project_host(request):
    version = request.GET.get('version')
    project_id = int(request.GET.get('project_id'))
    project_name = request.GET.get('project_name')
    project_host_set = HostNameInfo.objects.filter(host_project_obj__project_id=project_id)
    return render(request,"aliyun/project_host.html",{"project_host_set":project_host_set,"version":version,"project_name":project_name})

@csrf_exempt
def handle_host_check_date(request):
    version = request.GET.get('version')
    project_name = request.GET.get('project_name')
    host_name = request.GET.get('host_name')
    host_id = request.GET.get('host_id')
    #获取 一次检查主机对应的 主机信息表名称
    check_date_table_name = HostNameInfo.objects.get(host_id=host_id).storage_check_date_table_name
    check_date_host_table_name = "HostInfo_{}".format(check_date_table_name.split('_')[-1])
    host_check_date_set = eval(check_date_table_name).objects.filter(host_name_obj__host_id=host_id)
    for check_date_obj in host_check_date_set:
        try:
            query_host_info_obj = eval(check_date_host_table_name).objects.get(host_check_date_obj__host_check_date_id = check_date_obj.host_check_date_id)
        except Exception as e:
            query_host_info_obj = ''
        check_date_obj.host_info_obj = query_host_info_obj
    return render(request,"aliyun/host_check_date.html",{"host_check_date_set":host_check_date_set,"version":version,"project_name":project_name,"host_name":host_name,"host_id":host_id})

@csrf_exempt
def handle_host_analysis_info(request):
    version = request.GET.get('version')
    project_name = request.GET.get('project_name')
    host_name = request.GET.get('host_name')
    #根据主机id  和  check日期中对象id 确定 故障分析表中所要查询对象
    host_id = request.GET.get('host_id')
    check_date_id = request.GET.get('check_date_id')
    #根据 主机id 找到 check_date 表  ---》找到故障分析表
    check_date_table_name = HostNameInfo.objects.get(host_id=int(host_id)).storage_check_date_table_name
    host_check_info_table_name = "HostCheckInfo_{}".format(check_date_table_name.split('_')[-1])
    host_check_info_set = eval(host_check_info_table_name).objects.filter(host_name_obj__host_id=host_id,host_check_date_obj__host_check_date_id=check_date_id)
    print "*"*10,host_check_info_set
    return render(request,"aliyun/check_host_info.html",{"host_check_info_set":host_check_info_set,"version":version,"project_name":project_name,"host_name":host_name,})

    

############################################### 项目管理 #######################################################

@csrf_exempt
def handle_add_project(request):
    if request.method == "GET":
        cloud_type_set = CloudType.objects.all()
        version_set = CloudVersion.objects.all()
        response_data = {
                "cloud_type_set" : cloud_type_set,
                "version_set"    : version_set,
                        }
        return render(request,"aliyun/add_project.html",response_data)
    elif request.method == "POST":
        cloud_type_id = request.POST.get('cloud_type_id')
        cloud_version_id = int(request.POST.get("cloud_version_id"))
        project_name = request.POST.get("project_name")
        project_description = request.POST.get("project_instructions")
        project_start_date = request.POST.get("project_start_date")
        project_obj = ProjectInfo()
        project_obj.project_name = project_name
        project_obj.project_version_obj_id = cloud_version_id
        project_obj.project_description = project_description
        project_obj.project_start_date = project_start_date
        project_obj.save()
        return JsonResponse({"msg":"ok"})

@csrf_exempt
def handle_upload_host_check_log(request):
    if request.method == "GET":
        #cloud_type_id = request.GET.get('cloud_type_id')
        #cloud_version_id = request.GET.get('cloud_version_id')
        #cloud_type_set = CloudType.objects.all()
        #pre_cloud_type_id 用于前端初始化下拉菜单选项
        #pre_cloud_type_id = CloudType.objects.filter(cloud_type="专有云")[0].cloud_id
        version_set = CloudVersion.objects.filter(cloud_obj__cloud_type="专有云")
        response_data = {
                "version_set"    : version_set,
                            }
        return render(request,"aliyun/upload_host_check_log.html",response_data)

    elif request.method == "POST":
        #analysis post data
        tarball = request.FILES.get("host_check_log")
        cloud_type_id = request.POST.get('cloud_type_id')
        cloud_version_id = request.POST.get("cloud_version_id")
        project_id = request.POST.get("project_id")
        host_check_description = request.POST.get("host_check_description")
        #save

        return HttpResponse("未完待续、、、、")
    
