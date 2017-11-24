# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aliyun', '0002_auto_20171031_2031'),
    ]

    operations = [
        migrations.AlterField(
            model_name='hostinfo_0',
            name='bios_version',
            field=models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_0',
            name='disk_controller',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_0',
            name='kernel_version',
            field=models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_0',
            name='memory',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_0',
            name='processors',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_0',
            name='server',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_0',
            name='system_info',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True),
        ),
    ]
