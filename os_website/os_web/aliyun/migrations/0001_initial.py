# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CloudType',
            fields=[
                ('cloud_id', models.AutoField(max_length=8, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('cloud_type', models.CharField(max_length=8, null=True, verbose_name=b'\xe4\xba\x91\xe7\xb1\xbb\xe5\x9e\x8b', blank=True)),
                ('cloud_description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('creat_time', models.DateTimeField(auto_now=True, verbose_name=b'\xe5\x88\x9b\xe5\xbb\xba\xe6\x97\xa5\xe6\x9c\x9f')),
            ],
            options={
                'db_table': 'cloud_type',
                'verbose_name_plural': '<1>  CloudType(\u4e13\u6709\u4e91\u6216\u516c\u6709\u4e91\u4fe1\u606f)',
            },
        ),
        migrations.CreateModel(
            name='CloudVersion',
            fields=[
                ('version_id', models.AutoField(max_length=8, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('version_type', models.CharField(max_length=8, verbose_name=b'\xe7\x89\x88\xe6\x9c\xac\xe4\xbf\xa1\xe6\x81\xaf')),
                ('version_description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe7\x89\x88\xe6\x9c\xac\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('cloud_obj', models.ForeignKey(to='aliyun.CloudType')),
            ],
            options={
                'db_table': 'cloud_version',
                'verbose_name_plural': '<2>  CloudVersion(\u4e91\u7248\u672c\u4fe1\u606f)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_0',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
            ],
            options={
                'db_table': 'host_check_date_info_0',
                'verbose_name_plural': '<5.0> HostCheckDateInfo_0 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88680)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_1',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe9\x93\xbe\xe6\x8e\xa5', blank=True)),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
            ],
            options={
                'db_table': 'host_check_date_info_1',
                'verbose_name_plural': '<5.1> HostCheckDateInfo_1 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88681)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_0',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_0')),
            ],
            options={
                'db_table': 'host_check_info_0',
                'verbose_name_plural': '<7.0> HostCheckInfo_0(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88680)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_1',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_1')),
            ],
            options={
                'db_table': 'host_check_info_1',
                'verbose_name_plural': '<7.1> HostCheckInfo_0(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88681)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_0',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=24, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=24, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=24, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=24, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=24, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_0')),
            ],
            options={
                'db_table': 'host_info_0',
                'verbose_name_plural': '<6.0> HostInfo_0(\u4e3b\u673a\u4fe1\u606f\u88680)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_1',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=24, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=24, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=24, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=24, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=24, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_1')),
            ],
            options={
                'db_table': 'host_info_1',
                'verbose_name_plural': '<6.1> HostInfo_1(\u4e3b\u673a\u4fe1\u606f\u88681)',
            },
        ),
        migrations.CreateModel(
            name='HostNameInfo',
            fields=[
                ('host_id', models.AutoField(max_length=8, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_address', models.CharField(max_length=24, null=True, verbose_name=b'\xe4\xb8\xbb\xe6\x9c\xba\xe5\x9c\xb0\xe5\x9d\x80', blank=True)),
                ('host_description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
            ],
            options={
                'db_table': 'host_name_info',
                'verbose_name_plural': '<4>  HostNameInfo(\u9879\u76ee\u4e3b\u673a\u540d\u8868)',
            },
        ),
        migrations.CreateModel(
            name='ProjectInfo',
            fields=[
                ('project_id', models.AutoField(max_length=8, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('project_name', models.CharField(max_length=24, null=True, verbose_name=b'\xe9\xa1\xb9\xe7\x9b\xae\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('project_start_date', models.CharField(max_length=24, null=True, verbose_name=b'\xe9\xa1\xb9\xe7\x9b\xae\xe5\xbc\x80\xe5\xa7\x8b\xe6\x97\xb6\xe9\x97\xb4', blank=True)),
                ('project_version_obj', models.ForeignKey(to='aliyun.CloudVersion')),
            ],
            options={
                'db_table': 'project_info',
                'verbose_name_plural': '<3>  ProjectInfo(\u9879\u76ee\u8868)',
            },
        ),
        migrations.AddField(
            model_name='hostnameinfo',
            name='host_project_obj',
            field=models.ForeignKey(to='aliyun.ProjectInfo'),
        ),
        migrations.AddField(
            model_name='hostcheckinfo_1',
            name='host_name_obj',
            field=models.ForeignKey(to='aliyun.HostNameInfo'),
        ),
        migrations.AddField(
            model_name='hostcheckinfo_0',
            name='host_name_obj',
            field=models.ForeignKey(to='aliyun.HostNameInfo'),
        ),
        migrations.AddField(
            model_name='hostcheckdateinfo_1',
            name='host_name_obj',
            field=models.ForeignKey(to='aliyun.HostNameInfo'),
        ),
        migrations.AddField(
            model_name='hostcheckdateinfo_0',
            name='host_name_obj',
            field=models.ForeignKey(to='aliyun.HostNameInfo'),
        ),
    ]
