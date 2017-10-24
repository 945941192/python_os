# -*- coding: utf-8 -*-
from django.db import models

# Create your models here.

class UploadTarBallInfo(models.Model):
    file_name = models.CharField(max_length=1000,default='')
    up_status = models.IntegerField(default=0)
    check_status = models.IntegerField(default=0)
    upload_time = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "upload_tarball_info"
        verbose_name_plural = "上传tarball"
    
    def __str__(self):
        return self.file_name

class ScriptToolsInfo(models.Model):
    tool_name = models.CharField(max_length=1000,default='')
    tool_instructions = models.CharField(max_length=1000,default='')
    creat_time = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "script_tools_info"
        verbose_name_plural = "系统工具说明"
