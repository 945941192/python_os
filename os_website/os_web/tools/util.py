#!/usr/bin/env python
# coding=utf-8

import subprocess

from os_web.settings import PROJEKT_DIR,FilePath
from check.models import UploadTarBallInfo,ScriptToolsInfo


def pull_gitlab():
    res = subprocess.call("cd %s && git pull origin master"%PROJEKT_DIR,shell=True)

