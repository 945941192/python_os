# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aliyun', '0005_hostcheckdateinfo_2_hostcheckdateinfo_3'),
    ]

    operations = [
        migrations.CreateModel(
            name='HostCheckDateInfo_4',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_date_info_4',
                'verbose_name_plural': '<5.4> HostCheckDateInfo_4 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88684)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_5',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_date_info_5',
                'verbose_name_plural': '<5.5> HostCheckDateInfo_5 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88685)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_6',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_date_info_6',
                'verbose_name_plural': '<5.6> HostCheckDateInfo_6 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88686)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_7',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_date_info_7',
                'verbose_name_plural': '<5.7> HostCheckDateInfo_7 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88687)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_8',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_date_info_8',
                'verbose_name_plural': '<5.8> HostCheckDateInfo_8 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88688)',
            },
        ),
        migrations.CreateModel(
            name='HostCheckDateInfo_9',
            fields=[
                ('host_check_date_id', models.AutoField(max_length=24, serialize=False, verbose_name=b'ID', primary_key=True)),
                ('host_check_date', models.DateTimeField(auto_now=True, verbose_name=b'\xe6\xa3\x80\xe6\xb5\x8b\xe6\x97\xa5\xe6\x9c\x9f')),
                ('check_report_link', models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True)),
                ('health_index_num', models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0')),
                ('description', models.CharField(max_length=1000, null=True, verbose_name=b'\xe6\x8f\x8f\xe8\xbf\xb0', blank=True)),
                ('host_name_obj', models.ForeignKey(to='aliyun.HostNameInfo')),
            ],
            options={
                'abstract': False,
                'db_table': 'host_check_date_info_9',
                'verbose_name_plural': '<5.9> HostCheckDateInfo_9 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88689)',
            },
        ),
        migrations.AlterModelOptions(
            name='hostcheckdateinfo_3',
            options={'verbose_name_plural': '<5.3> HostCheckDateInfo_3 (\u4e3b\u673a\u68c0\u6d4b\u65e5\u671f\u4fe1\u606f\u88683)'},
        ),
        migrations.AlterField(
            model_name='hostcheckdateinfo_1',
            name='check_report_link',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True),
        ),
        migrations.AlterField(
            model_name='hostcheckdateinfo_2',
            name='check_report_link',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True),
        ),
        migrations.AlterField(
            model_name='hostcheckdateinfo_3',
            name='check_report_link',
            field=models.CharField(max_length=800, null=True, verbose_name=b'\xe6\xa3\x80\xe6\x9f\xa5\xe6\x8a\xa5\xe5\x91\x8a\xe8\xbf\x9e\xe6\x8e\xa5', blank=True),
        ),
    ]
