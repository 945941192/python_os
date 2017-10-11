#coding=utf-8

from django.shortcuts import render
from django.http import HttpResponse,HttpResponseRedirect,JsonResponse
from django.core.urlresolvers import reverse
from django.views.decorators.csrf import csrf_exempt

import os

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
        
        FilePath = "/var/os_tarball/"
        path_status = os.path.exists(FilePath)
        if not path_status:
            os.makedirs(FilePath)
        full_path_tarball = FilePath + tarball.name
        
        with open(full_path_tarball,"w") as pic:
            for c in tarball.chunks():
                pic.write(c)

        tarball_obj = UploadTarBallInfo()
        tarball_obj.file_name = tarball.name
        tarball_obj.status = 1
        tarball_obj.save()

        #return JsonResponse({'a':'b'})
        return HttpResponseRedirect("/check/")



