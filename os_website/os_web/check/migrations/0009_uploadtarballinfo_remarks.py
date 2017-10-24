# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0008_auto_20171020_1600'),
    ]

    operations = [
        migrations.AddField(
            model_name='uploadtarballinfo',
            name='remarks',
            field=models.CharField(default=b'', max_length=1000),
        ),
    ]
