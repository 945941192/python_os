# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0006_auto_20171012_1134'),
    ]

    operations = [
        migrations.CreateModel(
            name='ScriptToolsInfo',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('tool_name', models.CharField(default=b'', max_length=1000)),
                ('tool_instructions', models.CharField(default=b'', max_length=1000)),
                ('creat_time', models.DateTimeField(auto_now=True)),
            ],
            options={
                'db_table': 'script_tools_info',
                'verbose_name_plural': '\u7cfb\u7edf\u5de5\u5177\u8bf4\u660e',
            },
        ),
    ]
