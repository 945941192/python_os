#coding=utf-8

from django.conf.urls import url

from . import views

urlpatterns = [
    #上传tarball  展示 下载check report
    url(r'^$', views.handle_upload_checktarball, name='upload_check_tarball'),
    url(r'^show_check_report/$', views.handle_show_checkreport, name='show_check_report'),
    url(r'^down_check_report/$', views.handle_down_check_report, name='down_check_report'),

    #工具信息
    url(r'^script_tools/$', views.handle_script_tools, name='script_tools'),

]
