# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='UploadTarBallInfo',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('filename', models.CharField(default=b'', max_length=20)),
                ('status', models.IntegerField(default=0)),
                ('upload_time', models.DateTimeField(auto_now=True)),
            ],
            options={
                'db_table': 'upload_tarball_info',
                'verbose_name_plural': '\u4e0a\u4f20tarball',
            },
        ),
    ]
