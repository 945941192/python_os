# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('check', '0012_class_student'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='student',
            name='class_obj',
        ),
        migrations.DeleteModel(
            name='Class',
        ),
        migrations.DeleteModel(
            name='student',
        ),
    ]
