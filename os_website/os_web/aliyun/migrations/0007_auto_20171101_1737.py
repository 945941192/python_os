# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aliyun', '0006_auto_20171101_1625'),
    ]

    operations = [
        migrations.CreateModel(
            name='HostCheckInfo_2',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_2')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_2',
                'verbose_name_plural': '<7.2> HostCheckInfo_2(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88682)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_3',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_3')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_3',
                'verbose_name_plural': '<7.3> HostCheckInfo_3(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88683)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_4',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_4')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_4',
                'verbose_name_plural': '<7.4> HostCheckInfo_4(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88684)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_5',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_5')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_5',
                'verbose_name_plural': '<7.5> HostCheckInfo_5(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88685)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_6',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_6')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_6',
                'verbose_name_plural': '<7.6> HostCheckInfo_6(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88686)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_7',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_7')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_7',
                'verbose_name_plural': '<7.7> HostCheckInfo_7(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88687)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_8',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_8')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_8',
                'verbose_name_plural': '<7.8> HostCheckInfo_8(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88688)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckInfo_9',
            fields=[
                ('host_check_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('name', models.CharField(max_length=24, null=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe9\xa1\xb9\xe5\x90\x8d\xe7\xa7\xb0', blank=True)),
                ('status', models.IntegerField(default=0, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe7\x8a\xb6\xe6\x80\x81')),
                ('reason', models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\x94\x99\xe8\xaf\xaf\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_9')),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_info_9',
                'verbose_name_plural': '<7.9> HostCheckInfo_9(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88689)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_2',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_2')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_2',
                'verbose_name_plural': '<6.2> HostInfo_2(\u4e3b\u673a\u4fe1\u606f\u88682)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_3',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_3')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_3',
                'verbose_name_plural': '<6.3> HostInfo_3(\u4e3b\u673a\u4fe1\u606f\u88683)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_4',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_4')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_4',
                'verbose_name_plural': '<6.4> HostInfo_4(\u4e3b\u673a\u4fe1\u606f\u88684)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_5',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_5')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_5',
                'verbose_name_plural': '<6.5> HostInfo_5(\u4e3b\u673a\u4fe1\u606f\u88685)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_6',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_6')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_6',
                'verbose_name_plural': '<6.6> HostInfo_1(\u4e3b\u673a\u4fe1\u606f\u88686)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_7',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_7')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_7',
                'verbose_name_plural': '<6.7> HostInfo_7(\u4e3b\u673a\u4fe1\u606f\u88687)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_8',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_8')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_8',
                'verbose_name_plural': '<6.8> HostInfo_8(\u4e3b\u673a\u4fe1\u606f\u88688)',
            },
        ),
        migrations.CreateModel(
            name='HostInfo_9',
            fields=[
                ('host_info_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('server', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('processors', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('memory', models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True)),
                ('disk_controller', models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('system_info', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True)),
                ('kernel_version', models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True)),
                ('bios_version', models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True)),
                ('host_check_date_obj', models.ForeignKey(to='aliyun.HostCheckDateInfo_9')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_info_9',
                'verbose_name_plural': '<6.9> HostInfo_9(\u4e3b\u673a\u4fe1\u606f\u88689)',
            },
        ),
        migrations.AlterModelOptions(
            name='hostcheckinfo_1',
            options={'verbose_name_plural': '<7.1> HostCheckInfo_1(\u88ab\u68c0\u6d4b\u4e3b\u673a\u5206\u6790\u4fe1\u606f\u88681)'},
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='bios_version',
            field=models.CharField(max_length=800, null=True, verbose_name=b'BIOS', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='disk_controller',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe7\xa3\x81\xe7\x9b\x98\xe6\x8e\xa7\xe5\x88\xb6\xe5\x99\xa8\xe7\x89\x88\xe6\x9c\xac', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='kernel_version',
            field=models.CharField(max_length=800, null=True, verbose_name=b'kernel\xe7\x89\x88\xe6\x9c\xac', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='memory',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe5\x86\x85\xe5\xad\x98\xe5\x9e\x8b\xe5\x8f\xb7', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='processors',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe5\xa4\x84\xe7\x90\x86\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='server',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x9c\x8d\xe5\x8a\xa1\xe5\x99\xa8\xe5\x9e\x8b\xe5\x8f\xb7', blank=True),
        ),
        migrations.AlterField(
            model_name='hostinfo_1',
            name='system_info',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\x93\x8d\xe4\xbd\x9c\xe7\xb3\xbb\xe7\xbb\x9f\xe4\xbf\xa1\xe6\x81\xaf', blank=True),
        ),
    ]
