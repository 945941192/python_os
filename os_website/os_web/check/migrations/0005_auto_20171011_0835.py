# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0004_auto_20171010_0942'),
    ]

    operations = [
        migrations.AlterField(
            model_name='uploadtarballinfo',
            name='file_name',
            field=models.CharField(default=b'', max_length=1000),
        ),
    ]
