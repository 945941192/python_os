# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0005_auto_20171011_0835'),
    ]

    operations = [
        migrations.RenameField(
            model_name='uploadtarballinfo',
            old_name='status',
            new_name='check_status',
        ),
        migrations.AddField(
            model_name='uploadtarballinfo',
            name='up_status',
            field=models.IntegerField(default=0),
        ),
    ]
