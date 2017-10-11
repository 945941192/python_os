#coding=utf-8

from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.handle_upload_checktarball, name='upload_check_tarball'),
    url(r'^test$', views.test, name='test'),
]
