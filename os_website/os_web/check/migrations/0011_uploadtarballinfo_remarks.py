# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0010_remove_uploadtarballinfo_remarks'),
    ]

    operations = [
        migrations.AddField(
            model_name='uploadtarballinfo',
            name='remarks',
            field=models.CharField(default=b'', max_length=1000),
        ),
    ]
