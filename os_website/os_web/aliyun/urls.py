#!/usr/bin/env python
# coding=utf-8

from django.conf.urls import url

from . import views

urlpatterns = [
    #专有云对应所有版本信息
    url(r'^cloud_version$', views.handle_cloud_version, name='cloud_version'),
    #专有云项目版本对应-所有项目
    url(r'^version_project$', views.handle_version_project, name='version'),
    #专有云项目对应-所有主机
    url(r'^project_host$', views.handle_project_host, name='project'),
    #专有云项目主机-所有check信息
    url(r'^host_check_date$', views.handle_host_check_date, name='host'),
    #check信息对应的所有故障分析信息
    url(r'^host_analysis_info$', views.handle_host_analysis_info, name='host_analysis_info'),



    #添加项目
    url(r'^add_project$', views.handle_add_project, name='add_project'),
    #上传项目主机check tar ball
    url(r'^upload_host_check_log$', views.handle_upload_host_check_log, name='upload_host_check_log'),

#select2 ajax api
    #异步请求 项目列表
    url(r'^project_list$',views.handle_project_list,name='project_list'),

]
