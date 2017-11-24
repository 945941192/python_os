# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0011_uploadtarballinfo_remarks'),
    ]

    operations = [
        migrations.CreateModel(
            name='Class',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(default=b'', max_length=1000)),
                ('count', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'class',
                'verbose_name_plural': '\u6d4b\u8bd5\u7528 class',
            },
        ),
        migrations.CreateModel(
            name='student',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('s_name', models.CharField(default=b'', max_length=1000)),
                ('class_obj', models.OneToOneField(to='check.Class')),
            ],
            options={
                'db_table': 'student',
                'verbose_name_plural': '\u6d4b\u8bd5\u7528 student',
            },
        ),
    ]
