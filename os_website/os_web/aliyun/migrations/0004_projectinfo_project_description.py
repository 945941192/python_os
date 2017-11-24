# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aliyun', '0003_auto_20171101_1434'),
    ]

    operations = [
        migrations.AddField(
            model_name='projectinfo',
            name='project_description',
            field=models.CharField(max_length=1000, null=True, verbose_name=b'\xe9\xa1\xb9\xe7\x9b\xae\xe6\x8f\x8f\xe8\xbf\xb0', blank=True),
        ),
    ]
