# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aliyun', '0004_projectinfo_project_description'),
    ]

    operations = [
        migrations.CreateModel(
            name='HostCheckDateInfo_2',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe9\x93\xbe\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'db_table': 'host_check_date_info_2',
                'verbose_name_plural': '<5.2> HostCheckDateInfo_2 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88682)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_3',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe9\x93\xbe\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'db_table': 'host_check_date_info_3',
                'verbose_name_plural': '<5.3> HostCheckDateInfo_1 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88683)',
            },
        ),
    ]
