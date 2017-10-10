# -*- coding: utf-8 -*-
from django.db import models

# Create your models here.

class UploadTarBallInfo(models.Model):
    file_name = models.CharField(max_length=20,default='')
    status = models.IntegerField(default=0)
    upload_time = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "upload_tarball_info"
        verbose_name_plural = "上传tarball"
    
    def __str__(self):
        return self.file_name
