#coding=utf-8

from django.shortcuts import render
from django.http import HttpResponse


def upload_check_tarball(request):
#    return HttpResponse("hello,world,you are very niubi!!!")
    return render(request,"check/upload_check_tarball.html")



