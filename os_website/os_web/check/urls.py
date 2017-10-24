#coding=utf-8

from django.conf.urls import url

from . import views

urlpatterns = [
    #首页
    url(r'^$', views.handle_index, name='index'),
    #上传tarball  展示 下载check report
    url(r'^upload$', views.handle_upload_checktarball, name='upload_check_tarball'),
    #工具信息
    url(r'^script_tools/$', views.handle_script_tools, name='script_tools'),

]
