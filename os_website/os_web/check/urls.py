#coding=utf-8

from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.upload_check_tarball, name='upload_check_tarball'),
]
