#coding=utf-8

from django.db import models
from django.utils.timezone import localtime
from datetime import datetime

class CloudType(models.Model):
    cloud_id = models.AutoField("ID",primary_key=True,max_length=8)
    cloud_type = models.CharField("云类型",blank=True, null=True,max_length=8)
    cloud_description = models.CharField("描述",blank=True, null=True,max_length=1000)
    creat_time = models.DateTimeField("创建日期",auto_now=True)

    class Meta:
        db_table = "cloud_type"
        verbose_name_plural = "<1>  CloudType(专有云或公有云信息)"
      
    def __unicode__(self):         
        return self.cloud_type 

class CloudVersion(models.Model):
    version_id = models.AutoField("ID",primary_key=True,max_length=8)
    version_type = models.CharField("版本信息",max_length=8)
    cloud_obj = models.ForeignKey(CloudType) 
    version_description = models.CharField("版本描述",blank=True, null=True,max_length=1000)

    class Meta:
        db_table = "cloud_version"
        verbose_name_plural = "<2>  CloudVersion(云版本信息)"
    
    def __unicode__(self):
        obj_name = self.cloud_obj.cloud_type + '/' + self.version_type
        return obj_name

    @property
    def project_count(self):
        project_count = ProjectInfo.objects.filter(project_version_obj__version_id=self.version_id).count()
        return project_count

    @property
    def host_count(self):
        host_count = HostNameInfo.objects.filter(host_project_obj__project_version_obj__version_id=self.version_id).count()
        return host_count

    @property
    def av_health_index_num(self):
        host_health_list =  [_.av_health_index_num for _ in  ProjectInfo.objects.filter(project_version_obj__version_id=self.version_id)] 
        try: 
            av_health_index_num = sum(host_health_list) / len(host_health_list)
        except Exception as e:
            av_health_index_num = 0
        return av_health_index_num

class ProjectInfo(models.Model):
    project_id = models.AutoField("ID",primary_key=True,max_length=8)
    project_name = models.CharField("项目名称",blank=True, null=True, max_length=24)
    project_version_obj = models.ForeignKey(CloudVersion)
    project_start_date = models.CharField("项目开始时间",blank=True, null=True, max_length=24)
    project_description = models.CharField("项目描述",blank=True, null=True, max_length=1000)
    
    class Meta:
        db_table = "project_info"
        verbose_name_plural = "<3>  ProjectInfo(项目表)"

    def __unicode__(self):
        obj_name = self.project_version_obj.cloud_obj.cloud_type + "/" + self.project_version_obj.version_type + "/" + self.project_name
        return obj_name

    @property
    def host_count(self):
        return HostNameInfo.objects.filter(host_project_obj__project_id=self.project_id).count()

    @property
    def av_health_index_num(self):
        host_health_list =  [_.av_health_index_num for _ in  HostNameInfo.objects.filter(host_project_obj__project_id=self.project_id)] 
        try: 
            av_health_index_num = sum(host_health_list) / len(host_health_list)
        except Exception as e:
            av_health_index_num = 0
        return av_health_index_num

class HostNameInfo(models.Model):
    host_id = models.AutoField("ID",primary_key=True, max_length=8)
    host_address = models.CharField("主机地址",blank=True, null=True, max_length=24)
    host_project_obj = models.ForeignKey(ProjectInfo)
    host_description = models.CharField("描述",blank=True, null=True, max_length=1000)

    class Meta:
        db_table = "host_name_info"
        verbose_name_plural = "<4>  HostNameInfo(项目主机名表)"

    def __unicode__(self):
        obj_name = self.host_project_obj.project_version_obj.cloud_obj.cloud_type + "/" + self.host_project_obj.project_version_obj.version_type + "/" + self.host_project_obj.project_name + "/" + self.host_address
        return obj_name

    @property
    def storage_check_date_table_name(self):
        hash_result = self.host_id % 10 
        return "HostCheckDateInfo_{hash_result}".format(hash_result=hash_result)
    
    @property
    def av_health_index_num(self):
        host_checkdate_info_health_list = [_.health_index_num for _ in eval(self.storage_check_date_table_name).objects.filter(host_name_obj__host_id=self.host_id)]
        try:
            av_health_index_num = sum(host_checkdate_info_health_list) / len(host_checkdate_info_health_list)
        except Exception as e:
            av_health_index_num = 0
        return av_health_index_num
    
    @property
    def check_host_count(self):
        check_count = eval(self.storage_check_date_table_name).objects.filter(host_name_obj__host_id=self.host_id).count()
        return check_count

class HostCheckDateInfo(models.Model):
    host_check_date_id = models.AutoField("ID",primary_key=True, max_length=24)
    host_check_date = models.DateTimeField("检测日期",auto_now=True)
    host_name_obj = models.ForeignKey(HostNameInfo)
    check_report_link = models.CharField("检查报告连接",blank=True, null=True, max_length=800)
    health_index_num = models.IntegerField("健康指数",default=0) 
    description = models.CharField("描述",blank=True, null=True, max_length=1000)
    
    class Meta:
        abstract = True

    def __unicode__(self):
        local_time_utc8 = localtime(self.host_check_date)
        obj_name = self.host_name_obj.host_project_obj.project_version_obj.cloud_obj.cloud_type + "/" + self.host_name_obj.host_project_obj.project_version_obj.version_type + "/" + self.host_name_obj.host_project_obj.project_name + "/" + self.host_name_obj.host_address + "/" + local_time_utc8.strftime("%Y-%m-%d %H:%M:%S")
        return obj_name


class HostCheckDateInfo_0(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_0"
        verbose_name_plural = "<5.0> HostCheckDateInfo_0 (主机检测日期信息表0)"

class HostCheckDateInfo_1(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_1"
        verbose_name_plural = "<5.1> HostCheckDateInfo_1 (主机检测日期信息表1)"

class HostCheckDateInfo_2(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_2"
        verbose_name_plural = "<5.2> HostCheckDateInfo_2 (主机检测日期信息表2)"

class HostCheckDateInfo_3(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_3"
        verbose_name_plural = "<5.3> HostCheckDateInfo_3 (主机检测日期信息表3)"

class HostCheckDateInfo_4(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_4"
        verbose_name_plural = "<5.4> HostCheckDateInfo_4 (主机检测日期信息表4)"

class HostCheckDateInfo_5(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_5"
        verbose_name_plural = "<5.5> HostCheckDateInfo_5 (主机检测日期信息表5)"

class HostCheckDateInfo_6(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_6"
        verbose_name_plural = "<5.6> HostCheckDateInfo_6 (主机检测日期信息表6)"

class HostCheckDateInfo_7(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_7"
        verbose_name_plural = "<5.7> HostCheckDateInfo_7 (主机检测日期信息表7)"

class HostCheckDateInfo_8(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_8"
        verbose_name_plural = "<5.8> HostCheckDateInfo_8 (主机检测日期信息表8)"

class HostCheckDateInfo_9(HostCheckDateInfo):
    class Meta(HostCheckDateInfo.Meta):
        abstract = False
        db_table = "host_check_date_info_9"
        verbose_name_plural = "<5.9> HostCheckDateInfo_9 (主机检测日期信息表9)"

class HostInfo(models.Model):
    host_info_id = models.AutoField("ID",primary_key=True, max_length=24)
    server = models.CharField("服务器型号",blank=True, null=True, max_length=800)
    processors = models.CharField("处理器型号",blank=True, null=True, max_length=800)
    memory = models.CharField("内存型号",blank=True, null=True, max_length=800)
    disk_controller = models.CharField("磁盘控制器版本",blank=True, null=True, max_length=800)
    system_info = models.CharField("操作系统信息",blank=True, null=True, max_length=800)
    kernel_version = models.CharField("kernel版本",blank=True, null=True, max_length=800)
    bios_version = models.CharField("BIOS",blank=True, null=True, max_length=800)

    class Meta:
        abstract = True
    def __unicode__(self):
        return self.server            


class HostInfo_0(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_0)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_0"
        verbose_name_plural = "<6.0> HostInfo_0(主机信息表0)"

class HostInfo_1(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_1)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_1"
        verbose_name_plural = "<6.1> HostInfo_1(主机信息表1)"

class HostInfo_2(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_2)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_2"
        verbose_name_plural = "<6.2> HostInfo_2(主机信息表2)"

class HostInfo_3(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_3)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_3"
        verbose_name_plural = "<6.3> HostInfo_3(主机信息表3)"

class HostInfo_4(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_4)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_4"
        verbose_name_plural = "<6.4> HostInfo_4(主机信息表4)"

class HostInfo_5(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_5)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_5"
        verbose_name_plural = "<6.5> HostInfo_5(主机信息表5)"

class HostInfo_6(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_6)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_6"
        verbose_name_plural = "<6.6> HostInfo_6(主机信息表6)"

class HostInfo_7(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_7)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_7"
        verbose_name_plural = "<6.7> HostInfo_7(主机信息表7)"

class HostInfo_8(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_8)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_8"
        verbose_name_plural = "<6.8> HostInfo_8(主机信息表8)"

class HostInfo_9(HostInfo):
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_9)
    class Meta(HostInfo.Meta):
        abstract = False
        db_table = "host_info_9"
        verbose_name_plural = "<6.9> HostInfo_9(主机信息表9)"

class HostCheckInfo(models.Model):
    host_check_info_id = models.AutoField("ID",primary_key=True, max_length=24)
    name = models.CharField("检测项名称",blank=True, null=True, max_length=24)
    status = models.IntegerField("检查状态",default=0)
    reason = models.CharField("错误信息",blank=True, null=True, max_length=1000)
    
    class Meta:
        abstract = True
    def __unicode__(self):
        return self.name            

class HostCheckInfo_0(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_0)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_0"
        verbose_name_plural = "<7.0> HostCheckInfo_0(被检测主机分析信息表0)"

class HostCheckInfo_1(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_1)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_1"
        verbose_name_plural = "<7.1> HostCheckInfo_1(被检测主机分析信息表1)"

class HostCheckInfo_2(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_2)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_2"
        verbose_name_plural = "<7.2> HostCheckInfo_2(被检测主机分析信息表2)"

class HostCheckInfo_3(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_3)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_3"
        verbose_name_plural = "<7.3> HostCheckInfo_3(被检测主机分析信息表3)"

class HostCheckInfo_4(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_4)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_4"
        verbose_name_plural = "<7.4> HostCheckInfo_4(被检测主机分析信息表4)"

class HostCheckInfo_5(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_5)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_5"
        verbose_name_plural = "<7.5> HostCheckInfo_5(被检测主机分析信息表5)"

class HostCheckInfo_6(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_6)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_6"
        verbose_name_plural = "<7.6> HostCheckInfo_6(被检测主机分析信息表6)"

class HostCheckInfo_7(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_7)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_7"
        verbose_name_plural = "<7.7> HostCheckInfo_7(被检测主机分析信息表7)"

class HostCheckInfo_8(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_8)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_8"
        verbose_name_plural = "<7.8> HostCheckInfo_8(被检测主机分析信息表8)"

class HostCheckInfo_9(HostCheckInfo):
    host_name_obj = models.ForeignKey(HostNameInfo)
    host_check_date_obj = models.ForeignKey(HostCheckDateInfo_9)

    class Meta(HostCheckInfo.Meta):
        abstract = False
        db_table = "host_check_info_9"
        verbose_name_plural = "<7.9> HostCheckInfo_9(被检测主机分析信息表9)"



