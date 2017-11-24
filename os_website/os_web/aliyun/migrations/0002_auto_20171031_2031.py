# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('aliyun', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='hostcheckdateinfo_0',
            name='health_index_num',
            field=models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0'),
        ),
        migrations.AddField(
            model_name='hostcheckdateinfo_1',
            name='health_index_num',
            field=models.IntegerField(default=0, verbose_name=b'\xe5\x81\xa5\xe5\xba\xb7\xe6\x8c\x87\xe6\x95\xb0'),
        ),
    ]
