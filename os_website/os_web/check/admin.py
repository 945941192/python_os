#coding=utf-8

from django.contrib import admin
from .models import UploadTarBallInfo,ScriptToolsInfo
import subprocess
import base64

from os_web.settings import OSSBUCKET  


#取消全局的select删除
admin.site.disable_action('delete_selected')

@admin.register(UploadTarBallInfo)
class UploadTarBarllInfoAdmin(admin.ModelAdmin):
    list_display = ("file_name","check_report_url","tarball_url","remarks")
    list_display_links = ('file_name',)
    list_per_page = 10
    ordering = ('-id',)
    list_filter = ['file_name']
    actions = ['delete_mysql_oss_obj']
    def delete_mysql_oss_obj(modeladmin,request,queryset):
        for i in queryset:
            file_name = i.file_name
            check_report = i.check_report_url.split('/')[-1]
            BUCKETNAME = OSSBUCKET.get('BUCKETNAME')
            HOST = base64.b64decode(OSSBUCKET.get('HOST'))
            ID = base64.b64decode(OSSBUCKET.get('ID'))
            KEY = base64.b64decode(OSSBUCKET.get('KEY'))
            subprocess.call("osscmd rm oss:{BUCKETNAME}{file_name} --host {HOST} --id {ID} --key {KEY}".format(BUCKETNAME=BUCKETNAME,file_name=file_name,HOST=HOST,ID=ID,KEY=KEY),shell=True)
            subprocess.call("osscmd rm oss:{BUCKETNAME}{check_report} --host {HOST} --id {ID} --key {KEY}".format(BUCKETNAME=BUCKETNAME,check_report=check_report,HOST=HOST,ID=ID,KEY=KEY),shell=True)
        queryset.delete()
    delete_mysql_oss_obj.short_description = "删除所选的tarball(数据库及其oss对象)"
    

@admin.register(ScriptToolsInfo)
class ScriptToolInfoAdmin(admin.ModelAdmin):
    list_display = ("tool_name","tool_instructions")
    list_display_links = ('tool_name',)
    list_per_page = 10
    ordering = ('-id',)
    list_filter = ['tool_name']
    actions = ['delete_selected']


