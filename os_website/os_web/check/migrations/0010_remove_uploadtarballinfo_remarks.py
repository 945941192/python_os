# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0009_uploadtarballinfo_remarks'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='uploadtarballinfo',
            name='remarks',
        ),
    ]
