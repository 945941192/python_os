# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0003_uploadtarballinfo_filename'),
    ]

    operations = [
        migrations.RenameField(
            model_name='uploadtarballinfo',
            old_name='filename',
            new_name='file_name',
        ),
    ]
