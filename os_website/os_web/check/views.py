#coding=utf-8

from django.shortcuts import render
from django.http import HttpResponse,HttpResponseRedirect,JsonResponse
from django.core.urlresolvers import reverse
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def test(request):
#    return render(request,"check/upload_check_tarball.html")
    return HttpResponse("nicai")
    
@csrf_exempt
def handle_upload_checktarball(request):
#    return HttpResponse("hello,world,you are very niubi!!!")
    if request.method == "GET":
        return render(request,"check/upload_check_tarball.html")
    elif request.method == "POST":
        print "*"*9
        return HttpResponse("nicai")



