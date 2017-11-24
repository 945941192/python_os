# -*- coding: utf-8 -*-
from django.db import models

# Create your models here.

class UploadTarBallInfo(models.Model):
    file_name = models.CharField("压缩包文件名",max_length=1000,default='')
    up_status = models.IntegerField("上传状态",default=0)
    tarball_url = models.CharField("压缩包下载地址",max_length=1000,default='')
    check_status = models.IntegerField("检查状态",default=0)
    check_report_url = models.CharField("检查报告下载地址",max_length=1000,default='')
    remarks = models.TextField("备注",max_length=1000,default='') 
    upload_time = models.DateTimeField("上传时间",auto_now=True)

    class Meta:
        db_table = "upload_tarball_info"
        verbose_name_plural = "UploadTarBarllInfo(上传tarball信息)"
    
    def __unicode__(self):         
        return self.file_name

class ScriptToolsInfo(models.Model):
    tool_name = models.CharField("工具名称",max_length=1000,default='')
    tool_instructions = models.TextField("工具使用说明",max_length=1000,default='')
    creat_time = models.DateTimeField("创建时间",auto_now=True)

    class Meta:
        db_table = "script_tools_info"
        verbose_name_plural = "ScriptToolsInfo(系统工具说明)"
    
    def __unicode__(self):
        return self.tool_name
