#coding=utf-8

from django.contrib import admin
from .models import *

admin.site.site_header = "扁鹊后台数据管理"
admin.site.site_title = "扁鹊后台数据管理"


@admin.register(CloudType)
class CloudTypeAdmin(admin.ModelAdmin):
    list_display = ("cloud_id","cloud_type","cloud_description","creat_time")
    list_display_links = ('cloud_type','cloud_description')
    list_per_page = 10
    ordering = ('cloud_id',)
   # list_editable = ['cloud_type']
    list_filter = ['cloud_type']
    actions = ['delete_selected']

@admin.register(CloudVersion)
class CloudVersionAdmin(admin.ModelAdmin):
    list_display = ("version_id","version_type","cloud_obj","version_description")
    ordering = ("version_id",)
    radio_fields = {"cloud_obj": admin.VERTICAL}
    search_fields = ['version_type']
    list_filter = ['version_type']
    list_per_page = 20
    actions = ['delete_selected']

@admin.register(ProjectInfo)
class ProjectInfoAdmin(admin.ModelAdmin):
    list_display = ("project_id","project_name","project_version_obj","project_description","project_start_date")
    ordering = ("project_id",)
    radio_fields = {"project_version_obj": admin.VERTICAL}
    search_fields = ['project_name']
    list_filter = ['project_name']
    list_per_page = 20
    actions = ['delete_selected']

@admin.register(HostNameInfo)
class HostNameInfoAdmin(admin.ModelAdmin):
    list_display = ("host_id","host_address","host_project_obj","host_description")
    ordering = ("host_id",)
    search_fields = ['host_address']
    list_filter = ['host_address']
    list_per_page = 20
    actions = ['delete_selected']

class HostCheckDateInfoAdmin(admin.ModelAdmin):
    list_display = ("host_check_date_id","host_check_date","host_name_obj","check_report_link","health_index_num","description")
    ordering = ("host_check_date_id",)
    search_fields = ['host_check_date']
    list_filter = ['host_check_date']
    list_per_page = 20
    actions = ['delete_selected']
    

@admin.register(HostCheckDateInfo_0)
class HostCheckDateInfo_0Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_1)
class HostCheckDateInfo_1Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_2)
class HostCheckDateInfo_2Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_3)
class HostCheckDateInfo_3Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_4)
class HostCheckDateInfo_4Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_5)
class HostCheckDateInfo_5Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_6)
class HostCheckDateInfo_6Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_7)
class HostCheckDateInfo_7Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_8)
class HostCheckDateInfo_8Admin(HostCheckDateInfoAdmin):
    pass

@admin.register(HostCheckDateInfo_9)
class HostCheckDateInfo_9Admin(HostCheckDateInfoAdmin):
    pass


class HostInfoAdmin(admin.ModelAdmin):
    list_display = ("host_info_id","host_check_date_obj","server","processors","memory","disk_controller","system_info","kernel_version","bios_version")
    ordering = ("host_info_id",)
    search_fields = ['host_info_id',"server","processors","memory","disk_controller","system_info","kernel_version","bios_version"]
    list_filter = ['host_check_date_obj']
    list_per_page = 20
    actions = ['delete_selected']
    

@admin.register(HostInfo_0)
class HostInfo_0Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_1)
class HostInfo_1Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_2)
class HostInfo_2Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_3)
class HostInfo_3Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_4)
class HostInfo_4Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_5)
class HostInfo_5Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_6)
class HostInfo_6Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_7)
class HostInfo_7Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_8)
class HostInfo_8Admin(HostInfoAdmin):
    pass

@admin.register(HostInfo_9)
class HostInfo_9Admin(HostInfoAdmin):
    pass

class HostCheckInfoAdmin(admin.ModelAdmin):
    list_display = ("host_check_info_id","name","status","reason","host_check_date_obj","host_name_obj")
    ordering = ("host_check_info_id",)
    search_fields = ["host_check_info_id","name","status","reason"]
    list_filter = ["name"]
    list_per_page = 20
    actions = ['delete_selected']


@admin.register(HostCheckInfo_0)
class HostCheckInfo_0Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_1)
class HostCheckInfo_1Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_2)
class HostCheckInfo_2Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_3)
class HostCheckInfo_3Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_4)
class HostCheckInfo_4Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_5)
class HostCheckInfo_5Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_6)
class HostCheckInfo_6Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_7)
class HostCheckInfo_7Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_8)
class HostCheckInfo_8Admin(HostCheckInfoAdmin):
    pass

@admin.register(HostCheckInfo_9)
class HostCheckInfo_9Admin(HostCheckInfoAdmin):
    pass

