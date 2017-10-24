# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0007_scripttoolsinfo'),
    ]

    operations = [
        migrations.AddField(
            model_name='uploadtarballinfo',
            name='check_report_url',
            field=models.CharField(default=b'', max_length=1000),
        ),
        migrations.AddField(
            model_name='uploadtarballinfo',
            name='tarball_url',
            field=models.CharField(default=b'', max_length=1000),
        ),
    ]
