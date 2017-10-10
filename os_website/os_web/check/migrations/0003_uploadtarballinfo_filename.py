# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0002_remove_uploadtarballinfo_filename'),
    ]

    operations = [
        migrations.AddField(
            model_name='uploadtarballinfo',
            name='filename',
            field=models.CharField(default=b'', max_length=20),
        ),
    ]
