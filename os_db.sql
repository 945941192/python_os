-- MySQL dump 10.13  Distrib 5.6.37, for Linux (x86_64)
--
-- Host: localhost    Database: os_db
-- ------------------------------------------------------
-- Server version	5.6.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permission_group_id_689710a9a73b7457_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  CONSTRAINT `auth__content_type_id_508cf46651277a81_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add permission',2,'add_permission'),(5,'Can change permission',2,'change_permission'),(6,'Can delete permission',2,'delete_permission'),(7,'Can add group',3,'add_group'),(8,'Can change group',3,'change_group'),(9,'Can delete group',3,'delete_group'),(10,'Can add user',4,'add_user'),(11,'Can change user',4,'change_user'),(12,'Can delete user',4,'delete_user'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session'),(19,'Can add upload tar ball info',7,'add_uploadtarballinfo'),(20,'Can change upload tar ball info',7,'change_uploadtarballinfo'),(21,'Can delete upload tar ball info',7,'delete_uploadtarballinfo'),(22,'Can add script tools info',8,'add_scripttoolsinfo'),(23,'Can change script tools info',8,'change_scripttoolsinfo'),(24,'Can delete script tools info',8,'delete_scripttoolsinfo'),(25,'Can add cloud type',9,'add_cloudtype'),(26,'Can change cloud type',9,'change_cloudtype'),(27,'Can delete cloud type',9,'delete_cloudtype'),(28,'Can add cloud version',10,'add_cloudversion'),(29,'Can change cloud version',10,'change_cloudversion'),(30,'Can delete cloud version',10,'delete_cloudversion'),(31,'Can add project info',11,'add_projectinfo'),(32,'Can change project info',11,'change_projectinfo'),(33,'Can delete project info',11,'delete_projectinfo'),(34,'Can add host name info',12,'add_hostnameinfo'),(35,'Can change host name info',12,'change_hostnameinfo'),(36,'Can delete host name info',12,'delete_hostnameinfo'),(37,'Can add host check date info_0',13,'add_hostcheckdateinfo_0'),(38,'Can change host check date info_0',13,'change_hostcheckdateinfo_0'),(39,'Can delete host check date info_0',13,'delete_hostcheckdateinfo_0'),(40,'Can add host check date info_1',14,'add_hostcheckdateinfo_1'),(41,'Can change host check date info_1',14,'change_hostcheckdateinfo_1'),(42,'Can delete host check date info_1',14,'delete_hostcheckdateinfo_1'),(43,'Can add host info_0',15,'add_hostinfo_0'),(44,'Can change host info_0',15,'change_hostinfo_0'),(45,'Can delete host info_0',15,'delete_hostinfo_0'),(46,'Can add host info_1',16,'add_hostinfo_1'),(47,'Can change host info_1',16,'change_hostinfo_1'),(48,'Can delete host info_1',16,'delete_hostinfo_1'),(49,'Can add host check info_0',17,'add_hostcheckinfo_0'),(50,'Can change host check info_0',17,'change_hostcheckinfo_0'),(51,'Can delete host check info_0',17,'delete_hostcheckinfo_0'),(52,'Can add host check info_1',18,'add_hostcheckinfo_1'),(53,'Can change host check info_1',18,'change_hostcheckinfo_1'),(54,'Can delete host check info_1',18,'delete_hostcheckinfo_1'),(55,'Can add host check date info_2',19,'add_hostcheckdateinfo_2'),(56,'Can change host check date info_2',19,'change_hostcheckdateinfo_2'),(57,'Can delete host check date info_2',19,'delete_hostcheckdateinfo_2'),(58,'Can add host check date info_3',20,'add_hostcheckdateinfo_3'),(59,'Can change host check date info_3',20,'change_hostcheckdateinfo_3'),(60,'Can delete host check date info_3',20,'delete_hostcheckdateinfo_3'),(61,'Can add host check date info_4',21,'add_hostcheckdateinfo_4'),(62,'Can change host check date info_4',21,'change_hostcheckdateinfo_4'),(63,'Can delete host check date info_4',21,'delete_hostcheckdateinfo_4'),(64,'Can add host check date info_5',22,'add_hostcheckdateinfo_5'),(65,'Can change host check date info_5',22,'change_hostcheckdateinfo_5'),(66,'Can delete host check date info_5',22,'delete_hostcheckdateinfo_5'),(67,'Can add host check date info_6',23,'add_hostcheckdateinfo_6'),(68,'Can change host check date info_6',23,'change_hostcheckdateinfo_6'),(69,'Can delete host check date info_6',23,'delete_hostcheckdateinfo_6'),(70,'Can add host check date info_7',24,'add_hostcheckdateinfo_7'),(71,'Can change host check date info_7',24,'change_hostcheckdateinfo_7'),(72,'Can delete host check date info_7',24,'delete_hostcheckdateinfo_7'),(73,'Can add host check date info_8',25,'add_hostcheckdateinfo_8'),(74,'Can change host check date info_8',25,'change_hostcheckdateinfo_8'),(75,'Can delete host check date info_8',25,'delete_hostcheckdateinfo_8'),(76,'Can add host check date info_9',26,'add_hostcheckdateinfo_9'),(77,'Can change host check date info_9',26,'change_hostcheckdateinfo_9'),(78,'Can delete host check date info_9',26,'delete_hostcheckdateinfo_9'),(79,'Can add host info_2',27,'add_hostinfo_2'),(80,'Can change host info_2',27,'change_hostinfo_2'),(81,'Can delete host info_2',27,'delete_hostinfo_2'),(82,'Can add host info_3',28,'add_hostinfo_3'),(83,'Can change host info_3',28,'change_hostinfo_3'),(84,'Can delete host info_3',28,'delete_hostinfo_3'),(85,'Can add host info_4',29,'add_hostinfo_4'),(86,'Can change host info_4',29,'change_hostinfo_4'),(87,'Can delete host info_4',29,'delete_hostinfo_4'),(88,'Can add host info_5',30,'add_hostinfo_5'),(89,'Can change host info_5',30,'change_hostinfo_5'),(90,'Can delete host info_5',30,'delete_hostinfo_5'),(91,'Can add host info_6',31,'add_hostinfo_6'),(92,'Can change host info_6',31,'change_hostinfo_6'),(93,'Can delete host info_6',31,'delete_hostinfo_6'),(94,'Can add host info_7',32,'add_hostinfo_7'),(95,'Can change host info_7',32,'change_hostinfo_7'),(96,'Can delete host info_7',32,'delete_hostinfo_7'),(97,'Can add host info_8',33,'add_hostinfo_8'),(98,'Can change host info_8',33,'change_hostinfo_8'),(99,'Can delete host info_8',33,'delete_hostinfo_8'),(100,'Can add host info_9',34,'add_hostinfo_9'),(101,'Can change host info_9',34,'change_hostinfo_9'),(102,'Can delete host info_9',34,'delete_hostinfo_9'),(103,'Can add host check info_2',35,'add_hostcheckinfo_2'),(104,'Can change host check info_2',35,'change_hostcheckinfo_2'),(105,'Can delete host check info_2',35,'delete_hostcheckinfo_2'),(106,'Can add host check info_3',36,'add_hostcheckinfo_3'),(107,'Can change host check info_3',36,'change_hostcheckinfo_3'),(108,'Can delete host check info_3',36,'delete_hostcheckinfo_3'),(109,'Can add host check info_4',37,'add_hostcheckinfo_4'),(110,'Can change host check info_4',37,'change_hostcheckinfo_4'),(111,'Can delete host check info_4',37,'delete_hostcheckinfo_4'),(112,'Can add host check info_5',38,'add_hostcheckinfo_5'),(113,'Can change host check info_5',38,'change_hostcheckinfo_5'),(114,'Can delete host check info_5',38,'delete_hostcheckinfo_5'),(115,'Can add host check info_6',39,'add_hostcheckinfo_6'),(116,'Can change host check info_6',39,'change_hostcheckinfo_6'),(117,'Can delete host check info_6',39,'delete_hostcheckinfo_6'),(118,'Can add host check info_7',40,'add_hostcheckinfo_7'),(119,'Can change host check info_7',40,'change_hostcheckinfo_7'),(120,'Can delete host check info_7',40,'delete_hostcheckinfo_7'),(121,'Can add host check info_8',41,'add_hostcheckinfo_8'),(122,'Can change host check info_8',41,'change_hostcheckinfo_8'),(123,'Can delete host check info_8',41,'delete_hostcheckinfo_8'),(124,'Can add host check info_9',42,'add_hostcheckinfo_9'),(125,'Can change host check info_9',42,'change_hostcheckinfo_9'),(126,'Can delete host check info_9',42,'delete_hostcheckinfo_9');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$20000$qjoNblWGWTBX$1YgBO+iP7xFtY/s7BLC8HnMxYYwhBubBd54DDdlk2Gk=','2017-11-14 08:35:22',1,'admin','','','wzb@163.com',1,1,'2017-10-31 10:47:26');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_u_permission_id_384b62483d7071f0_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_user_u_permission_id_384b62483d7071f0_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissi_user_id_7f0938558328534a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_type`
--

DROP TABLE IF EXISTS `cloud_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_type` (
  `cloud_id` int(11) NOT NULL AUTO_INCREMENT,
  `cloud_type` varchar(8) DEFAULT NULL,
  `cloud_description` varchar(1000) DEFAULT NULL,
  `creat_time` datetime NOT NULL,
  PRIMARY KEY (`cloud_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_type`
--

LOCK TABLES `cloud_type` WRITE;
/*!40000 ALTER TABLE `cloud_type` DISABLE KEYS */;
INSERT INTO `cloud_type` VALUES (1,'公有云','在公网提供服务','2017-11-01 09:44:08'),(2,'专有云','为阿里内部提供服务','2017-11-01 09:44:20');
/*!40000 ALTER TABLE `cloud_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_version`
--

DROP TABLE IF EXISTS `cloud_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cloud_version` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_type` varchar(8) NOT NULL,
  `version_description` varchar(1000) DEFAULT NULL,
  `cloud_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `cloud_versi_cloud_obj_id_510f5e51d2927db1_fk_cloud_type_cloud_id` (`cloud_obj_id`),
  CONSTRAINT `cloud_versi_cloud_obj_id_510f5e51d2927db1_fk_cloud_type_cloud_id` FOREIGN KEY (`cloud_obj_id`) REFERENCES `cloud_type` (`cloud_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_version`
--

LOCK TABLES `cloud_version` WRITE;
/*!40000 ALTER TABLE `cloud_version` DISABLE KEYS */;
INSERT INTO `cloud_version` VALUES (1,'v1','v1版本信息',2),(2,'v2','v2版本信息',2),(3,'v3','dfef ',2);
/*!40000 ALTER TABLE `cloud_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `djang_content_type_id_697914295151027a_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id` (`user_id`),
  CONSTRAINT `djang_content_type_id_697914295151027a_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2017-11-01 09:44:08','1','公有云',1,'',9,1),(2,'2017-11-01 09:44:20','2','专有云',1,'',9,1),(3,'2017-11-01 09:45:44','1','专有云/v1',1,'',10,1),(4,'2017-11-01 09:46:03','2','专有云/v2',1,'',10,1),(5,'2017-11-01 09:57:43','1','专有云/v1/中国邮政',1,'',11,1),(6,'2017-11-01 09:58:13','2','专有云/v2/小河山',1,'',11,1),(7,'2017-11-01 09:59:31','3','专有云/v2/g20项目',1,'',11,1),(8,'2017-11-01 09:59:44','1','专有云/v1/中国邮政',2,'已修改 project_start_date 。',11,1),(9,'2017-11-01 09:59:51','3','专有云/v2/g20项目',2,'已修改 project_start_date 。',11,1),(10,'2017-11-01 10:00:50','1','专有云/v1/中国邮政/zhongguoyouzheng_host1',1,'',12,1),(11,'2017-11-01 10:01:22','2','专有云/v1/中国邮政/zhongguoyouzheng_host2',1,'',12,1),(12,'2017-11-01 10:01:42','3','专有云/v1/中国邮政/zhongguoyouzheng_host3',1,'',12,1),(13,'2017-11-01 10:02:07','4','专有云/v2/小河山/xiaoheshan_host_1',1,'',12,1),(14,'2017-11-01 10:02:31','5','专有云/v2/小河山/xiaoheshan_host_2',1,'',12,1),(15,'2017-11-01 10:02:51','6','专有云/v2/小河山/xiaoheshan_host_3',1,'',12,1),(16,'2017-11-01 10:03:28','7','专有云/v2/g20项目/g20_host_1',1,'',12,1),(17,'2017-11-01 10:03:45','8','专有云/v2/g20项目/g20_host_2',1,'',12,1),(18,'2017-11-01 10:04:09','9','专有云/v2/g20项目/g20_host_3',1,'',12,1),(19,'2017-11-01 10:04:37','10','专有云/v2/g20项目/g20_host_4',1,'',12,1),(20,'2017-11-01 10:18:12','1','专有云/v1/中国邮政/zhongguoyouzheng_host1/2017-11-01 10:18',1,'',13,1),(21,'2017-11-01 10:18:37','1','专有云/v1/中国邮政/zhongguoyouzheng_host2/2017-11-01 10:18',1,'',14,1),(22,'2017-11-01 10:19:01','1','专有云/v1/中国邮政/zhongguoyouzheng_host3/2017-11-01 10:19',1,'',19,1),(23,'2017-11-01 10:19:40','1','专有云/v2/小河山/xiaoheshan_host_1/2017-11-01 10:19',1,'',20,1),(24,'2017-11-01 10:19:58','1','专有云/v2/小河山/xiaoheshan_host_2/2017-11-01 10:19',1,'',21,1),(25,'2017-11-01 10:20:30','1','专有云/v2/小河山/xiaoheshan_host_3/2017-11-01 10:20',1,'',22,1),(26,'2017-11-01 10:20:48','1','专有云/v2/g20项目/g20_host_1/2017-11-01 10:20',1,'',23,1),(27,'2017-11-01 10:21:09','1','专有云/v2/g20项目/g20_host_2/2017-11-01 10:21',1,'',24,1),(28,'2017-11-01 10:21:26','1','专有云/v2/g20项目/g20_host_3/2017-11-01 10:21',1,'',25,1),(29,'2017-11-01 10:21:47','1','专有云/v2/g20项目/g20_host_4/2017-11-01 10:21',1,'',26,1),(30,'2017-11-01 10:23:59','1','Inspur SA5212M4 (Inspur YZMB-00370-102)',1,'',15,1),(31,'2017-11-01 10:25:32','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',16,1),(32,'2017-11-01 10:26:23','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',28,1),(33,'2017-11-01 10:26:55','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',29,1),(34,'2017-11-01 10:27:18','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',30,1),(35,'2017-11-01 10:29:35','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',31,1),(36,'2017-11-01 10:29:57','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',32,1),(37,'2017-11-01 10:30:16','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',33,1),(38,'2017-11-01 10:30:37','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',34,1),(39,'2017-11-01 10:31:30','1','history',1,'',17,1),(40,'2017-11-01 10:31:50','1','history',1,'',18,1),(41,'2017-11-01 10:32:11','1','history',1,'',35,1),(42,'2017-11-01 10:32:49','1','history',1,'',36,1),(43,'2017-11-01 10:33:15','1','netstat -an',1,'',37,1),(44,'2017-11-01 10:33:51','1','netstat -an',1,'',38,1),(45,'2017-11-01 10:34:16','1','netstat -an',1,'',39,1),(46,'2017-11-01 10:34:35','1','netstat -an',1,'',40,1),(47,'2017-11-01 10:34:49','1','netstat -an',1,'',41,1),(48,'2017-11-01 10:35:22','1','history',1,'',42,1),(49,'2017-11-01 10:35:57','2','netstat -an',1,'',17,1),(50,'2017-11-03 07:42:43','14','cld_check.sh',3,'',8,1),(51,'2017-11-03 07:45:27','56','cloud_log.2017-11-03-15-18-49.tar.gz',3,'',7,1),(52,'2017-11-03 07:45:27','55','cloud_log.2017-11-03-15-18-49.tar.gz',3,'',7,1),(53,'2017-11-03 07:54:20','2','check_dns.sh',2,'已修改 tool_instructions 。',8,1),(54,'2017-11-03 13:03:51','48','cloud_log.2017-10-25-14-27-20.tar.gz',3,'',7,1),(55,'2017-11-03 13:03:51','47','cloud_log.2017-10-25-14-24-43.tar.gz',3,'',7,1),(56,'2017-11-03 13:03:51','46','cloud_log.2017-10-20-16-54-51.tar.gz',3,'',7,1),(57,'2017-11-03 13:03:51','45','cloud_log.2017-10-20-16-44-59.tar.gz',3,'',7,1),(58,'2017-11-03 13:04:36','49','cloud_log.2017-10-25-22-27-07.tar.gz',3,'',7,1),(59,'2017-11-03 13:04:36','44','cloud_log.2017-10-23-10-11-22.tar.gz',3,'',7,1),(60,'2017-11-03 13:04:36','43','cloud_log.2017-10-20-16-54-51.tar.gz',3,'',7,1),(61,'2017-11-03 13:04:36','42','cloud_log.2017-10-23-10-11-22.tar.gz',3,'',7,1),(62,'2017-11-03 13:04:36','41','cloud_log.2017-10-20-16-54-51.tar.gz',3,'',7,1),(63,'2017-11-08 09:43:17','5','config_kdump.sh',3,'',8,1),(64,'2017-11-08 09:48:12','13','kc_config.sh',2,'已修改 tool_name 和 tool_instructions 。',8,1),(65,'2017-11-08 09:48:46','6','config_tty.sh',3,'',8,1),(66,'2017-11-14 07:48:38','1','专有云/v1/中国邮政/zhongguoyouzheng_host1/2017-11-01 10:18',3,'',13,1),(67,'2017-11-14 07:49:07','1','专有云/v1/中国邮政/zhongguoyouzheng_host2/2017-11-01 10:18',3,'',14,1),(68,'2017-11-14 07:49:17','1','专有云/v1/中国邮政/zhongguoyouzheng_host3/2017-11-01 10:19',3,'',19,1),(69,'2017-11-14 07:49:26','1','专有云/v2/小河山/xiaoheshan_host_1/2017-11-01 10:19',3,'',20,1),(70,'2017-11-14 07:49:38','1','专有云/v2/小河山/xiaoheshan_host_2/2017-11-01 10:19',3,'',21,1),(71,'2017-11-14 07:49:46','1','专有云/v2/小河山/xiaoheshan_host_3/2017-11-01 10:20',3,'',22,1),(72,'2017-11-14 07:50:00','1','专有云/v2/g20项目/g20_host_1/2017-11-01 10:20',3,'',23,1),(73,'2017-11-14 07:50:14','1','专有云/v2/g20项目/g20_host_2/2017-11-01 10:21',3,'',24,1),(74,'2017-11-14 07:50:22','1','专有云/v2/g20项目/g20_host_3/2017-11-01 10:21',3,'',25,1),(75,'2017-11-14 07:50:31','1','专有云/v2/g20项目/g20_host_4/2017-11-01 10:21',3,'',26,1),(76,'2017-11-14 08:04:15','2','专有云/v2/g20项目/g20_host_4/2017-11-14 08:04',1,'',13,1),(77,'2017-11-14 08:04:37','2','专有云/v1/中国邮政/zhongguoyouzheng_host1/2017-11-14 08:04',1,'',14,1),(78,'2017-11-14 08:04:58','2','专有云/v1/中国邮政/zhongguoyouzheng_host2/2017-11-14 08:04',1,'',19,1),(79,'2017-11-14 08:05:18','2','专有云/v1/中国邮政/zhongguoyouzheng_host3/2017-11-14 08:05',1,'',20,1),(80,'2017-11-14 08:05:35','2','专有云/v2/小河山/xiaoheshan_host_1/2017-11-14 08:05',1,'',21,1),(81,'2017-11-14 08:05:59','2','专有云/v2/小河山/xiaoheshan_host_2/2017-11-14 08:05',1,'',22,1),(82,'2017-11-14 08:06:28','2','专有云/v2/小河山/xiaoheshan_host_3/2017-11-14 08:06',1,'',23,1),(83,'2017-11-14 08:06:49','2','专有云/v2/g20项目/g20_host_1/2017-11-14 08:06',1,'',24,1),(84,'2017-11-14 08:07:10','2','专有云/v2/g20项目/g20_host_2/2017-11-14 08:07',1,'',25,1),(85,'2017-11-14 08:07:25','2','专有云/v2/g20项目/g20_host_3/2017-11-14 08:07',1,'',26,1),(86,'2017-11-14 08:07:59','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',15,1),(87,'2017-11-14 08:12:54','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',16,1),(88,'2017-11-14 08:13:23','1','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',27,1),(89,'2017-11-14 08:13:42','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',28,1),(90,'2017-11-14 08:13:57','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',29,1),(91,'2017-11-14 08:14:16','2','server',1,'',30,1),(92,'2017-11-14 08:14:32','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',31,1),(93,'2017-11-14 08:14:52','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',32,1),(94,'2017-11-14 08:15:13','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',33,1),(95,'2017-11-14 08:15:33','2','Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz',1,'',34,1),(96,'2017-11-14 08:15:56','3','history',1,'',17,1),(97,'2017-11-14 08:16:14','2','history',1,'',18,1),(98,'2017-11-14 08:16:33','2','kernel-3',1,'',35,1),(99,'2017-11-14 08:16:53','2','netstat -an',1,'',36,1),(100,'2017-11-14 08:17:14','2','histor',1,'',37,1),(101,'2017-11-14 08:17:35','2','kernel',1,'',38,1),(102,'2017-11-14 08:17:54','2','kernel',1,'',39,1),(103,'2017-11-14 08:18:12','2','kernel',1,'',40,1),(104,'2017-11-14 08:18:28','2','kernel',1,'',41,1),(105,'2017-11-14 08:18:45','2','netstat -an',1,'',42,1),(106,'2017-11-14 08:35:49','3','专有云/v2/g20项目/g20_host_4/2017-11-14 08:35',1,'',13,1),(107,'2017-11-14 09:00:25','3','专有云/v3',1,'',10,1),(108,'2017-11-14 09:01:08','4','专有云/v3/小小鸟',1,'',11,1),(109,'2017-11-14 09:43:07','5','专有云/v3/小小鸟',1,'',11,1),(110,'2017-11-14 09:43:36','5','专有云/v3/小小鸟',3,'',11,1),(111,'2017-11-14 09:44:30','11','专有云/v3/小小鸟/小小鸟host_1',1,'',12,1),(112,'2017-11-14 09:45:18','3','专有云/v3/小小鸟/小小鸟host_1/2017-11-14 09:45',1,'',14,1),(113,'2017-11-14 09:46:00','4','专有云/v3/小小鸟/小小鸟host_1/2017-11-14 09:45',1,'',14,1),(114,'2017-11-14 09:46:51','12','专有云/v3/小小鸟/xiaoxiaoniao_host2',1,'',12,1),(115,'2017-11-15 06:09:24','4','专有云/v2/g20项目/g20_host_4/2017-11-15 06:09',1,'',13,1),(116,'2017-11-15 06:09:48','3','专有云/v2/g20项目/g20_host_4/2017-11-15 06:09',2,'已修改 health_index_num 。',13,1),(117,'2017-11-15 07:46:47','2','专有云/v2/g20项目/g20_host_1/2017-11-15 07:46',2,'已修改 health_index_num 。',24,1),(118,'2017-11-15 07:47:01','2','专有云/v2/g20项目/g20_host_1/2017-11-15 07:47',2,'已修改 health_index_num 。',24,1),(119,'2017-11-15 07:47:11','2','专有云/v2/g20项目/g20_host_1/2017-11-15 07:47',2,'已修改 health_index_num 。',24,1),(120,'2017-11-20 11:32:08','13','专有云/v1/小虾米/小虾米主机1',1,'',12,1),(121,'2017-11-20 11:32:16','13','专有云/v1/小虾米/小虾米主机2',2,'已修改 host_address 。',12,1),(122,'2017-11-20 11:32:19','13','专有云/v1/小虾米/小虾米主机3',2,'已修改 host_address 。',12,1),(123,'2017-11-20 11:34:40','14','专有云/v3/小虾米2/小虾米主机1',1,'',12,1),(124,'2017-11-20 11:34:44','14','专有云/v3/小虾米2/小虾米主机2',2,'已修改 host_address 。',12,1),(125,'2017-11-20 11:35:34','15','专有云/v3/小虾米2/小虾米主机1',1,'',12,1),(126,'2017-11-23 12:08:59','2','你好',2,'已修改 server 。',15,1),(127,'2017-11-23 12:12:40','3','a',1,'',15,1),(128,'2017-11-23 12:59:50','5','专有云/v2/小河山/xiaoheshan_host_3/2017-11-23 12:59:50',1,'',14,1),(129,'2017-11-23 13:02:13','3','专有云/v2/小河山/xiaoheshan_host_3/2017-11-23 13:02:12',1,'',23,1),(130,'2017-11-24 03:37:23','4','14:09:48',1,'',15,1),(131,'2017-11-24 03:40:37','3','专有云/v2/g20项目/g20_host_3/2017-11-24 11:40:37',1,'',26,1),(132,'2017-11-24 03:41:32','3','11：40:37',1,'',34,1),(133,'2017-11-24 03:42:31','4','专有云/v2/g20项目/g20_host_3/2017-11-24 11:42:31',1,'',26,1),(134,'2017-11-24 03:42:53','4','11:42:31',1,'',34,1),(135,'2017-11-24 04:24:38','4','专有云/v2/g20项目/g20_host_4/2017-11-15 14:09:24',3,'',13,1),(136,'2017-11-24 04:26:12','4','14:09:48',2,'没有字段被修改。',15,1),(137,'2017-11-24 08:47:10','4','a',1,'',17,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_45f3b1d93ec8c61c_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(9,'aliyun','cloudtype'),(10,'aliyun','cloudversion'),(13,'aliyun','hostcheckdateinfo_0'),(14,'aliyun','hostcheckdateinfo_1'),(19,'aliyun','hostcheckdateinfo_2'),(20,'aliyun','hostcheckdateinfo_3'),(21,'aliyun','hostcheckdateinfo_4'),(22,'aliyun','hostcheckdateinfo_5'),(23,'aliyun','hostcheckdateinfo_6'),(24,'aliyun','hostcheckdateinfo_7'),(25,'aliyun','hostcheckdateinfo_8'),(26,'aliyun','hostcheckdateinfo_9'),(17,'aliyun','hostcheckinfo_0'),(18,'aliyun','hostcheckinfo_1'),(35,'aliyun','hostcheckinfo_2'),(36,'aliyun','hostcheckinfo_3'),(37,'aliyun','hostcheckinfo_4'),(38,'aliyun','hostcheckinfo_5'),(39,'aliyun','hostcheckinfo_6'),(40,'aliyun','hostcheckinfo_7'),(41,'aliyun','hostcheckinfo_8'),(42,'aliyun','hostcheckinfo_9'),(15,'aliyun','hostinfo_0'),(16,'aliyun','hostinfo_1'),(27,'aliyun','hostinfo_2'),(28,'aliyun','hostinfo_3'),(29,'aliyun','hostinfo_4'),(30,'aliyun','hostinfo_5'),(31,'aliyun','hostinfo_6'),(32,'aliyun','hostinfo_7'),(33,'aliyun','hostinfo_8'),(34,'aliyun','hostinfo_9'),(12,'aliyun','hostnameinfo'),(11,'aliyun','projectinfo'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(8,'check','scripttoolsinfo'),(7,'check','uploadtarballinfo'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2017-10-16 10:12:50'),(2,'auth','0001_initial','2017-10-16 10:12:50'),(3,'admin','0001_initial','2017-10-16 10:12:50'),(4,'contenttypes','0002_remove_content_type_name','2017-10-16 10:12:50'),(5,'auth','0002_alter_permission_name_max_length','2017-10-16 10:12:51'),(6,'auth','0003_alter_user_email_max_length','2017-10-16 10:12:51'),(7,'auth','0004_alter_user_username_opts','2017-10-16 10:12:51'),(8,'auth','0005_alter_user_last_login_null','2017-10-16 10:12:51'),(9,'auth','0006_require_contenttypes_0002','2017-10-16 10:12:51'),(10,'check','0001_initial','2017-10-16 10:12:51'),(11,'check','0002_remove_uploadtarballinfo_filename','2017-10-16 10:12:51'),(12,'check','0003_uploadtarballinfo_filename','2017-10-16 10:12:51'),(13,'check','0004_auto_20171010_0942','2017-10-16 10:12:51'),(14,'check','0005_auto_20171011_0835','2017-10-16 10:12:51'),(15,'check','0006_auto_20171012_1134','2017-10-16 10:12:51'),(16,'check','0007_scripttoolsinfo','2017-10-16 10:12:51'),(17,'sessions','0001_initial','2017-10-16 10:12:51'),(18,'check','0008_auto_20171020_1600','2017-10-20 10:35:14'),(19,'check','0009_uploadtarballinfo_remarks','2017-10-24 09:33:16'),(20,'check','0010_remove_uploadtarballinfo_remarks','2017-10-24 09:33:16'),(21,'check','0011_uploadtarballinfo_remarks','2017-10-24 09:33:16'),(22,'aliyun','0001_initial','2017-10-31 10:46:32'),(23,'check','0012_class_student','2017-10-31 10:46:32'),(24,'check','0013_auto_20171030_1428','2017-10-31 10:46:32'),(25,'aliyun','0002_auto_20171031_2031','2017-10-31 12:32:04'),(26,'aliyun','0003_auto_20171101_1434','2017-11-01 09:40:28'),(27,'aliyun','0004_projectinfo_project_description','2017-11-01 09:40:28'),(28,'aliyun','0005_hostcheckdateinfo_2_hostcheckdateinfo_3','2017-11-01 09:40:28'),(29,'aliyun','0006_auto_20171101_1625','2017-11-01 09:40:29'),(30,'aliyun','0007_auto_20171101_1737','2017-11-01 09:40:32');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('3cquf194y99ayj6y3dss3rr1xeyqzdtz','MDdiMzA3YzYyOTQ3MDcwM2E2NzM0NmZiNTJkYjM4ZGFlNzIwNDg4Yzp7Il9hdXRoX3VzZXJfaGFzaCI6ImQ5YWZmNDY2MWM2YThjMDgyYjAyNmIxMjZkNmJmODgxOWUwZjkyNzIiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2017-11-22 09:38:40'),('74s37lfntlt10oa8lfb0np0ugwxhjm27','MDdiMzA3YzYyOTQ3MDcwM2E2NzM0NmZiNTJkYjM4ZGFlNzIwNDg4Yzp7Il9hdXRoX3VzZXJfaGFzaCI6ImQ5YWZmNDY2MWM2YThjMDgyYjAyNmIxMjZkNmJmODgxOWUwZjkyNzIiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2017-11-17 09:09:59'),('qnmr3qzwhofis9mtqyss8ni1aj2wtvh1','MDdiMzA3YzYyOTQ3MDcwM2E2NzM0NmZiNTJkYjM4ZGFlNzIwNDg4Yzp7Il9hdXRoX3VzZXJfaGFzaCI6ImQ5YWZmNDY2MWM2YThjMDgyYjAyNmIxMjZkNmJmODgxOWUwZjkyNzIiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2017-11-28 08:35:22'),('sicxtig6w78oyj9vmkjy0jpo5bovt12p','MDdiMzA3YzYyOTQ3MDcwM2E2NzM0NmZiNTJkYjM4ZGFlNzIwNDg4Yzp7Il9hdXRoX3VzZXJfaGFzaCI6ImQ5YWZmNDY2MWM2YThjMDgyYjAyNmIxMjZkNmJmODgxOWUwZjkyNzIiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2017-11-14 10:52:07');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_0`
--

DROP TABLE IF EXISTS `host_check_date_info_0`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_0` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  `health_index_num` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_check_date_info_0_844f626f` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_77164b1cde214343_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_0`
--

LOCK TABLES `host_check_date_info_0` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_0` DISABLE KEYS */;
INSERT INTO `host_check_date_info_0` VALUES (2,'2017-11-14 08:04:15','check_report_url','描述信息',10,100),(3,'2017-11-15 06:09:48','check_report_url','是的丰富',10,80);
/*!40000 ALTER TABLE `host_check_date_info_0` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_1`
--

DROP TABLE IF EXISTS `host_check_date_info_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_1` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  `health_index_num` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_check_date_info_1_844f626f` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_771649be3344dbce_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_1`
--

LOCK TABLES `host_check_date_info_1` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_1` DISABLE KEYS */;
INSERT INTO `host_check_date_info_1` VALUES (2,'2017-11-14 08:04:37','check_report_url','描述信息',1,100),(3,'2017-11-14 09:45:18','check_report_url','小小鸟主机描述',11,50),(4,'2017-11-14 09:46:00','check_report_url','描述信息',11,100),(5,'2017-11-23 12:59:50','jj','aa',6,50);
/*!40000 ALTER TABLE `host_check_date_info_1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_2`
--

DROP TABLE IF EXISTS `host_check_date_info_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_2` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_77164d42e5de2489_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_77164d42e5de2489_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_2`
--

LOCK TABLES `host_check_date_info_2` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_2` DISABLE KEYS */;
INSERT INTO `host_check_date_info_2` VALUES (2,'2017-11-14 08:04:58','check_report_url',100,'描述信息',2);
/*!40000 ALTER TABLE `host_check_date_info_2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_3`
--

DROP TABLE IF EXISTS `host_check_date_info_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_3` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_77164c2965cf082c_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_77164c2965cf082c_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_3`
--

LOCK TABLES `host_check_date_info_3` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_3` DISABLE KEYS */;
INSERT INTO `host_check_date_info_3` VALUES (2,'2017-11-14 08:05:18','check_report_url',100,'描述信息',3);
/*!40000 ALTER TABLE `host_check_date_info_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_4`
--

DROP TABLE IF EXISTS `host_check_date_info_4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_4` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_77164f29f38050e7_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_77164f29f38050e7_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_4`
--

LOCK TABLES `host_check_date_info_4` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_4` DISABLE KEYS */;
INSERT INTO `host_check_date_info_4` VALUES (2,'2017-11-14 08:05:35','check_report_url',100,'描述信息',4);
/*!40000 ALTER TABLE `host_check_date_info_4` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_5`
--

DROP TABLE IF EXISTS `host_check_date_info_5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_5` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_77164e0d5b17e972_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_77164e0d5b17e972_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_5`
--

LOCK TABLES `host_check_date_info_5` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_5` DISABLE KEYS */;
INSERT INTO `host_check_date_info_5` VALUES (2,'2017-11-14 08:05:59','check_report_url',100,'描述信息',5);
/*!40000 ALTER TABLE `host_check_date_info_5` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_6`
--

DROP TABLE IF EXISTS `host_check_date_info_6`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_6` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_7716508de508722d_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_7716508de508722d_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_6`
--

LOCK TABLES `host_check_date_info_6` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_6` DISABLE KEYS */;
INSERT INTO `host_check_date_info_6` VALUES (2,'2017-11-14 08:06:28','check_report_url',100,'描述信息',6),(3,'2017-11-23 13:02:13','a',50,'记录时间 21:02',6);
/*!40000 ALTER TABLE `host_check_date_info_6` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_7`
--

DROP TABLE IF EXISTS `host_check_date_info_7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_7` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_771650367b2e15d0_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_771650367b2e15d0_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_7`
--

LOCK TABLES `host_check_date_info_7` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_7` DISABLE KEYS */;
INSERT INTO `host_check_date_info_7` VALUES (2,'2017-11-15 07:47:11','check_report_url',81,'描述信息',7);
/*!40000 ALTER TABLE `host_check_date_info_7` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_8`
--

DROP TABLE IF EXISTS `host_check_date_info_8`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_8` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_771641f055aa9e8b_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_771641f055aa9e8b_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_8`
--

LOCK TABLES `host_check_date_info_8` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_8` DISABLE KEYS */;
INSERT INTO `host_check_date_info_8` VALUES (2,'2017-11-14 08:07:10','check_report_url',100,'描述信息',8);
/*!40000 ALTER TABLE `host_check_date_info_8` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_date_info_9`
--

DROP TABLE IF EXISTS `host_check_date_info_9`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_date_info_9` (
  `host_check_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_check_date` datetime NOT NULL,
  `check_report_link` varchar(800) DEFAULT NULL,
  `health_index_num` int(11) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_date_id`),
  KEY `host_host_name_obj_id_77165199e8914f16_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `host_host_name_obj_id_77165199e8914f16_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_date_info_9`
--

LOCK TABLES `host_check_date_info_9` WRITE;
/*!40000 ALTER TABLE `host_check_date_info_9` DISABLE KEYS */;
INSERT INTO `host_check_date_info_9` VALUES (2,'2017-11-14 08:07:25','check_report_url',100,'描述信息',9),(3,'2017-11-24 03:40:37','a',0,'啊',9),(4,'2017-11-24 03:42:31','啊',80,'11:42',9);
/*!40000 ALTER TABLE `host_check_date_info_9` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_0`
--

DROP TABLE IF EXISTS `host_check_info_0`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_0` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D2f4817a19ec3ea6147061a0db1c76d3` (`host_check_date_obj_id`),
  KEY `host_check_info_0_844f626f` (`host_name_obj_id`),
  CONSTRAINT `D2f4817a19ec3ea6147061a0db1c76d3` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_0` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0bae2fa3be5585_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_0`
--

LOCK TABLES `host_check_info_0` WRITE;
/*!40000 ALTER TABLE `host_check_info_0` DISABLE KEYS */;
INSERT INTO `host_check_info_0` VALUES (3,'history',0,'网卡未启动',2,10),(4,'a',2,'a',2,10);
/*!40000 ALTER TABLE `host_check_info_0` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_1`
--

DROP TABLE IF EXISTS `host_check_info_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_1` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D711c60f5648171ba3de47d64dcf86a8` (`host_check_date_obj_id`),
  KEY `host_check_info_1_844f626f` (`host_name_obj_id`),
  CONSTRAINT `D711c60f5648171ba3de47d64dcf86a8` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_1` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0baf3c2b2a07fa_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_1`
--

LOCK TABLES `host_check_info_1` WRITE;
/*!40000 ALTER TABLE `host_check_info_1` DISABLE KEYS */;
INSERT INTO `host_check_info_1` VALUES (2,'history',0,'pass',2,1);
/*!40000 ALTER TABLE `host_check_info_1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_2`
--

DROP TABLE IF EXISTS `host_check_info_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_2` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `b5917ba770bbfe0ba1f540a811e6472d` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0baccc25d67f3f_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `b5917ba770bbfe0ba1f540a811e6472d` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_2` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0baccc25d67f3f_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_2`
--

LOCK TABLES `host_check_info_2` WRITE;
/*!40000 ALTER TABLE `host_check_info_2` DISABLE KEYS */;
INSERT INTO `host_check_info_2` VALUES (2,'kernel-3',0,'网卡未启动',2,2);
/*!40000 ALTER TABLE `host_check_info_2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_3`
--

DROP TABLE IF EXISTS `host_check_info_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_3` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D2565958f9ee2a5f691d8f9a91719500` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0badd83a260b9c_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D2565958f9ee2a5f691d8f9a91719500` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_3` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0badd83a260b9c_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_3`
--

LOCK TABLES `host_check_info_3` WRITE;
/*!40000 ALTER TABLE `host_check_info_3` DISABLE KEYS */;
INSERT INTO `host_check_info_3` VALUES (2,'netstat -an',0,'have rm -rf  /*',2,3);
/*!40000 ALTER TABLE `host_check_info_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_4`
--

DROP TABLE IF EXISTS `host_check_info_4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_4` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D7494cc66fa6a57d7dadc584a064fbfc` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0baae40fea82e1_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D7494cc66fa6a57d7dadc584a064fbfc` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_4` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0baae40fea82e1_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_4`
--

LOCK TABLES `host_check_info_4` WRITE;
/*!40000 ALTER TABLE `host_check_info_4` DISABLE KEYS */;
INSERT INTO `host_check_info_4` VALUES (2,'histor',0,'pass',2,4);
/*!40000 ALTER TABLE `host_check_info_4` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_5`
--

DROP TABLE IF EXISTS `host_check_info_5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_5` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D79e0ae2a3b959cf1d828f3cac2a1535` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0babf12bffba56_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D79e0ae2a3b959cf1d828f3cac2a1535` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_5` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0babf12bffba56_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_5`
--

LOCK TABLES `host_check_info_5` WRITE;
/*!40000 ALTER TABLE `host_check_info_5` DISABLE KEYS */;
INSERT INTO `host_check_info_5` VALUES (2,'kernel',0,'have rm -rf  /*',2,5);
/*!40000 ALTER TABLE `host_check_info_5` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_6`
--

DROP TABLE IF EXISTS `host_check_info_6`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_6` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D2a31ee68d5036d280e19834514af1c0` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0b97f43fdc319b_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D2a31ee68d5036d280e19834514af1c0` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_6` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0b97f43fdc319b_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_6`
--

LOCK TABLES `host_check_info_6` WRITE;
/*!40000 ALTER TABLE `host_check_info_6` DISABLE KEYS */;
INSERT INTO `host_check_info_6` VALUES (2,'kernel',0,'pass',2,6);
/*!40000 ALTER TABLE `host_check_info_6` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_7`
--

DROP TABLE IF EXISTS `host_check_info_7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_7` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D7ee8c538ce7fcde3b4f008a0e981582` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0b9942669fbdf8_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D7ee8c538ce7fcde3b4f008a0e981582` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_7` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0b9942669fbdf8_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_7`
--

LOCK TABLES `host_check_info_7` WRITE;
/*!40000 ALTER TABLE `host_check_info_7` DISABLE KEYS */;
INSERT INTO `host_check_info_7` VALUES (2,'kernel',0,'网卡未启动',2,7);
/*!40000 ALTER TABLE `host_check_info_7` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_8`
--

DROP TABLE IF EXISTS `host_check_info_8`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_8` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D6c96f664b22bb5bc95c86d93fd52068` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0ba645353d30cd_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D6c96f664b22bb5bc95c86d93fd52068` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_8` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0ba645353d30cd_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_8`
--

LOCK TABLES `host_check_info_8` WRITE;
/*!40000 ALTER TABLE `host_check_info_8` DISABLE KEYS */;
INSERT INTO `host_check_info_8` VALUES (2,'kernel',0,'have rm -rf  /*',2,8);
/*!40000 ALTER TABLE `host_check_info_8` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_check_info_9`
--

DROP TABLE IF EXISTS `host_check_info_9`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_check_info_9` (
  `host_check_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) DEFAULT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(1000) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  `host_name_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_check_info_id`),
  KEY `D4eb8ac3ecc091d1f6e81ac5e2b5101f` (`host_check_date_obj_id`),
  KEY `host_host_name_obj_id_7c0ba71faaacfb42_fk_host_name_info_host_id` (`host_name_obj_id`),
  CONSTRAINT `D4eb8ac3ecc091d1f6e81ac5e2b5101f` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_9` (`host_check_date_id`),
  CONSTRAINT `host_host_name_obj_id_7c0ba71faaacfb42_fk_host_name_info_host_id` FOREIGN KEY (`host_name_obj_id`) REFERENCES `host_name_info` (`host_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_check_info_9`
--

LOCK TABLES `host_check_info_9` WRITE;
/*!40000 ALTER TABLE `host_check_info_9` DISABLE KEYS */;
INSERT INTO `host_check_info_9` VALUES (2,'netstat -an',0,'pass',2,9);
/*!40000 ALTER TABLE `host_check_info_9` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_0`
--

DROP TABLE IF EXISTS `host_info_0`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_0` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `D28f48759c659cd4fd0842ade0f908e8` (`host_check_date_obj_id`),
  CONSTRAINT `D28f48759c659cd4fd0842ade0f908e8` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_0` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_0`
--

LOCK TABLES `host_info_0` WRITE;
/*!40000 ALTER TABLE `host_info_0` DISABLE KEYS */;
INSERT INTO `host_info_0` VALUES (2,'你好','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2),(4,'14:09:48','14:09:48','14:09:48','14:09:48','14:09:48','14:09:48','14:09:48',3);
/*!40000 ALTER TABLE `host_info_0` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_1`
--

DROP TABLE IF EXISTS `host_info_1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_1` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `cdc5743b7110fc4d0de84cd268683eb0` (`host_check_date_obj_id`),
  CONSTRAINT `cdc5743b7110fc4d0de84cd268683eb0` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_1` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_1`
--

LOCK TABLES `host_info_1` WRITE;
/*!40000 ALTER TABLE `host_info_1` DISABLE KEYS */;
INSERT INTO `host_info_1` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_2`
--

DROP TABLE IF EXISTS `host_info_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_2` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `a37bc47844138c8b27f44d0edd1ea632` (`host_check_date_obj_id`),
  CONSTRAINT `a37bc47844138c8b27f44d0edd1ea632` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_2` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_2`
--

LOCK TABLES `host_info_2` WRITE;
/*!40000 ALTER TABLE `host_info_2` DISABLE KEYS */;
INSERT INTO `host_info_2` VALUES (1,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_3`
--

DROP TABLE IF EXISTS `host_info_3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_3` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `f8af7bd93286728774a5477ea76193c0` (`host_check_date_obj_id`),
  CONSTRAINT `f8af7bd93286728774a5477ea76193c0` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_3` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_3`
--

LOCK TABLES `host_info_3` WRITE;
/*!40000 ALTER TABLE `host_info_3` DISABLE KEYS */;
INSERT INTO `host_info_3` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_4`
--

DROP TABLE IF EXISTS `host_info_4`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_4` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `e551b4772c19fb0e1315caf6e595db6b` (`host_check_date_obj_id`),
  CONSTRAINT `e551b4772c19fb0e1315caf6e595db6b` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_4` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_4`
--

LOCK TABLES `host_info_4` WRITE;
/*!40000 ALTER TABLE `host_info_4` DISABLE KEYS */;
INSERT INTO `host_info_4` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_4` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_5`
--

DROP TABLE IF EXISTS `host_info_5`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_5` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `D08ac48cb10957fe454bfbfd67955ed7` (`host_check_date_obj_id`),
  CONSTRAINT `D08ac48cb10957fe454bfbfd67955ed7` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_5` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_5`
--

LOCK TABLES `host_info_5` WRITE;
/*!40000 ALTER TABLE `host_info_5` DISABLE KEYS */;
INSERT INTO `host_info_5` VALUES (2,'server','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_5` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_6`
--

DROP TABLE IF EXISTS `host_info_6`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_6` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `D59bb4a95b357a0e236000e3fd665cc7` (`host_check_date_obj_id`),
  CONSTRAINT `D59bb4a95b357a0e236000e3fd665cc7` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_6` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_6`
--

LOCK TABLES `host_info_6` WRITE;
/*!40000 ALTER TABLE `host_info_6` DISABLE KEYS */;
INSERT INTO `host_info_6` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_6` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_7`
--

DROP TABLE IF EXISTS `host_info_7`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_7` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `d2f951fab7af7e6b97a5928f14fa5736` (`host_check_date_obj_id`),
  CONSTRAINT `d2f951fab7af7e6b97a5928f14fa5736` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_7` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_7`
--

LOCK TABLES `host_info_7` WRITE;
/*!40000 ALTER TABLE `host_info_7` DISABLE KEYS */;
INSERT INTO `host_info_7` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_7` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_8`
--

DROP TABLE IF EXISTS `host_info_8`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_8` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `D6bd849a55d800959b8636bb9a138f0f` (`host_check_date_obj_id`),
  CONSTRAINT `D6bd849a55d800959b8636bb9a138f0f` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_8` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_8`
--

LOCK TABLES `host_info_8` WRITE;
/*!40000 ALTER TABLE `host_info_8` DISABLE KEYS */;
INSERT INTO `host_info_8` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','mpt2sas0: LSI Logic / Symbios Logic SAS2308 PCI-Express Fusion-MPT ','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2);
/*!40000 ALTER TABLE `host_info_8` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_info_9`
--

DROP TABLE IF EXISTS `host_info_9`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_info_9` (
  `host_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `server` varchar(800) DEFAULT NULL,
  `processors` varchar(800) DEFAULT NULL,
  `memory` varchar(800) DEFAULT NULL,
  `disk_controller` varchar(800) DEFAULT NULL,
  `system_info` varchar(800) DEFAULT NULL,
  `kernel_version` varchar(800) DEFAULT NULL,
  `bios_version` varchar(800) DEFAULT NULL,
  `host_check_date_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_info_id`),
  KEY `D6428d6918f931626d5c9d2886d5f5c8` (`host_check_date_obj_id`),
  CONSTRAINT `D6428d6918f931626d5c9d2886d5f5c8` FOREIGN KEY (`host_check_date_obj_id`) REFERENCES `host_check_date_info_9` (`host_check_date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_info_9`
--

LOCK TABLES `host_info_9` WRITE;
/*!40000 ALTER TABLE `host_info_9` DISABLE KEYS */;
INSERT INTO `host_info_9` VALUES (2,'Huawei Technologies Tecal RH2285, 2 x Xeon E5620 2.40GHz, 23.5GB / 24GB 1066MHz','2 x Xeon E5-2680 v3 2.50GHz 100MHz FSB (48 cores)','252.1GB / 256GB 2133MHz Other == 16 x 16GB','disk controller','Alibaba Group Enterprise Linux Server 5.7 (CatFeces)','2.6.32-220.23.2.ali1113.el5.x86_64 x86_64, 64-bit','AMI 4.10 09/22/201',2),(3,'11：40:37','11：40:37','11：40:37','11：40:37','11：40:37','11：40:37','11：40:37',3),(4,'11:42:31','11:42:31','11:42:31','11:42:31','11:42:31','11:42:31','11:42:31',4);
/*!40000 ALTER TABLE `host_info_9` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_name_info`
--

DROP TABLE IF EXISTS `host_name_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_name_info` (
  `host_id` int(11) NOT NULL AUTO_INCREMENT,
  `host_address` varchar(24) DEFAULT NULL,
  `host_description` varchar(1000) DEFAULT NULL,
  `host_project_obj_id` int(11) NOT NULL,
  PRIMARY KEY (`host_id`),
  KEY `host_name_info_78eeb7f7` (`host_project_obj_id`),
  CONSTRAINT `host_project_obj_id_282098054994b3a1_fk_project_info_project_id` FOREIGN KEY (`host_project_obj_id`) REFERENCES `project_info` (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_name_info`
--

LOCK TABLES `host_name_info` WRITE;
/*!40000 ALTER TABLE `host_name_info` DISABLE KEYS */;
INSERT INTO `host_name_info` VALUES (1,'zhongguoyouzheng_host1','zhongguoyouzheng_host1 description',1),(2,'zhongguoyouzheng_host2','zhongguoyouzheng_host2 description',1),(3,'zhongguoyouzheng_host3','zhongguoyouzheng_host3 description',1),(4,'xiaoheshan_host_1','xiaoheshan_host_1 description',2),(5,'xiaoheshan_host_2','xiaoheshan_host_2 description',2),(6,'xiaoheshan_host_3','xiaoheshan_host_3 description',2),(7,'g20_host_1','g20_host_1 description',3),(8,'g20_host_2','g20_host_2 description',3),(9,'g20_host_3','g20_host_3 description',3),(10,'g20_host_4','g20_host_4 description',3),(11,'小小鸟host_1','xiaoxiao鸟第一台主机',4),(12,'xiaoxiaoniao_host2','xiaoxiaoniao第2台主机',4),(13,'小虾米主机3','小虾米主机描述',12),(14,'小虾米主机2','小虾米主机描述',13),(15,'小虾米主机1','小虾米主机描述',13);
/*!40000 ALTER TABLE `host_name_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_info`
--

DROP TABLE IF EXISTS `project_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_info` (
  `project_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_name` varchar(24) DEFAULT NULL,
  `project_start_date` varchar(24) DEFAULT NULL,
  `project_version_obj_id` int(11) NOT NULL,
  `project_description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`project_id`),
  KEY `D7a1726c0d7392bbf7549020b7a044f6` (`project_version_obj_id`),
  CONSTRAINT `D7a1726c0d7392bbf7549020b7a044f6` FOREIGN KEY (`project_version_obj_id`) REFERENCES `cloud_version` (`version_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_info`
--

LOCK TABLES `project_info` WRITE;
/*!40000 ALTER TABLE `project_info` DISABLE KEYS */;
INSERT INTO `project_info` VALUES (1,'中国邮政','2017/11/1',1,'中国邮政项目描述（test）'),(2,'小河山','2017/1/1',2,'小河山项目描述（test）'),(3,'g20项目','2017/11/1',2,'g20项目描述（test）'),(4,'小小鸟','2017/11/14',3,'小小鸟'),(5,'ceshi 1',NULL,1,NULL),(6,'小泰山',NULL,1,NULL),(7,'啊啊',NULL,1,NULL),(8,'小小鸟',NULL,2,NULL),(9,'为',NULL,2,NULL),(10,'一',NULL,3,NULL),(11,'一','2017/1/2',3,'你奥'),(12,'小虾米','2017/10/30',1,'小河流水哗啦啦'),(13,'小虾米2','啊',3,'啊'),(14,'小猪','2017/11/11',3,'小猪佩奇\naaa\na\na\na\na\na\na\n'),(15,NULL,NULL,1,NULL),(16,NULL,NULL,1,NULL),(17,NULL,NULL,1,NULL),(18,'小测试','111111',3,'小测试\n小测试\n'),(19,'小小测试','啊啊',1,'xiao\n小小\n测试'),(20,NULL,NULL,1,NULL),(21,NULL,NULL,3,NULL),(22,NULL,NULL,3,NULL),(23,NULL,NULL,1,NULL),(24,NULL,NULL,1,NULL),(25,NULL,NULL,1,NULL),(26,NULL,NULL,1,NULL),(27,NULL,NULL,1,NULL),(28,NULL,NULL,1,NULL),(29,NULL,NULL,1,NULL),(30,NULL,NULL,1,NULL),(31,NULL,NULL,1,NULL),(32,'你好','啊啊啊',3,'啊啊啊'),(33,'a','a',1,'a'),(34,'a','a',1,'a'),(35,'1','1',1,'1'),(36,'1','1',3,'1');
/*!40000 ALTER TABLE `project_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `script_tools_info`
--

DROP TABLE IF EXISTS `script_tools_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `script_tools_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tool_name` varchar(1000) NOT NULL,
  `tool_instructions` varchar(1000) NOT NULL,
  `creat_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `script_tools_info`
--

LOCK TABLES `script_tools_info` WRITE;
/*!40000 ALTER TABLE `script_tools_info` DISABLE KEYS */;
INSERT INTO `script_tools_info` VALUES (2,'check_dns.sh','DNS服务检查工具：[dmsag 服务器上运行]\n1、-t参数指定一个域名，以检查客户端指定的DNS服务器是否可以解析域名，不加-t默认解析客户端本身域名；\n2、-m和-s参数需要同时使用，分别指定dns主从服务器，以检查主从服务器的区域文件是否同步一致，此操作在DMS-AG服务器上执行；\n3、使用示例：\n./check_dns.sh -t dnsapi1.tbsite.net   \n./check_dns.sh -m 10.0.0.1 -s 10.0.0.2\n\n\n','2017-11-17 07:15:23'),(4,'collection_process.sh','操作系统进程信息收集工具，将此脚本拷到操作系统后根据此脚本提供的帮助来收集指定进程号的进程信息，例如：collection_process.sh -p 12345','2017-10-30 03:14:23'),(9,'cld_check.sh','操作系统故障分析工具。服务器宕机后，拷贝脚本到服务器直接运行，收集日志，然后上载日志到 “检测日志” 标签，查看日志检测报告。\n#sh cld_check.sh -h\n    Usage:\n        cld_check.sh -V                     debug mode.\n        cld_check.sh -d <target dir>        All log will be generated to target dir.\n        cld_check.sh -i <target item>       Call target item to get info.\n        cld_check.sh -t <target type>       Call target type to get info.\n        cld_check.sh -s <target scope>      Call target scope: small, normal(default), all to get info.\n        cld_check.sh -n                     Will not compress log files to generate tarball.\n        cld_check.sh -c                     Check log content and generate report.\n        cld_check.sh -f <log file>          Assign log tarball file, need with parameter -c.\n        cld_check.sh -l                     Just list type and items out.\n    Example:\n        cld_check.sh -d /apsara -s all\n        cld_check.sh -s small\n        cld_check.sh -t \"Slb Info Data\"      <-- 拷贝脚本到dmsag 上执行\n        cld_check.sh ','2017-11-10 07:08:39'),(12,'ntp_check.sh','NTP运行状态检查工具，从DMS-AG服务器上运行，通过-t参数指定要检查的目标服务器。\nsh ntp_check.sh -t  xx.xx.xx.xx','2017-11-08 09:27:24'),(13,'kc_config.sh','kdump与conman配置检查工具.\n-c参数配置NC串口并在重启前检查串口配置；\n-k参数配置kdump服务并在重启前检查配置；\n-c可与 -t（指定tty设备，如：ttyS0）、-b（指定tty设备波特率，如：115200）一同使用；\n-a参数在重启后检查kdump与conman配置。\n例如：\n./kc_config.sh -c\n./kc_config.sh -k\n./kc_config.sh -c -t \"ttyS0\" -b \"115200\"\n./kc_config.sh -a','2017-11-10 05:16:47');
/*!40000 ALTER TABLE `script_tools_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upload_tarball_info`
--

DROP TABLE IF EXISTS `upload_tarball_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upload_tarball_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `check_status` int(11) NOT NULL,
  `upload_time` datetime NOT NULL,
  `file_name` varchar(1000) NOT NULL,
  `up_status` int(11) NOT NULL,
  `check_report_url` varchar(1000) NOT NULL,
  `tarball_url` varchar(1000) NOT NULL,
  `remarks` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upload_tarball_info`
--

LOCK TABLES `upload_tarball_info` WRITE;
/*!40000 ALTER TABLE `upload_tarball_info` DISABLE KEYS */;
INSERT INTO `upload_tarball_info` VALUES (40,1,'2017-10-23 09:15:41','cloud_log.2017-10-20-16-44-59.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-10-20-16-44-59.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-10-20-16-44-59.tar.gz',''),(50,1,'2017-10-27 02:09:29','cloud_log.2017-10-27-10-08-07.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-10-27-10-08-07.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-10-27-10-08-07.tar.gz','北宫门  slb  收集日志tarball'),(51,1,'2017-11-01 16:05:14','cloud_log.2017-11-01-23-41-00.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-01-23-41-00.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-01-23-41-00.tar.gz','G2897LG _鄂尔多斯流计算处理'),(52,1,'2017-11-02 05:26:42','cloud_log.2017-11-02-12-56-08.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-02-12-56-08.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-02-12-56-08.tar.gz','G2897LG _鄂尔多斯流计算处理 OPS1 '),(53,1,'2017-11-02 06:11:25','cloud_log.2017-11-02-14-03-40.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-02-14-03-40.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-02-14-03-40.tar.gz','G2897LG _鄂尔多斯流计算处理 galaxy'),(54,1,'2017-11-02 08:01:42','cloud_log.2017-11-02-14-03-40.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-02-14-03-40.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-02-14-03-40.tar.gz','G2897LG _鄂尔多斯流计算处理 galaxy retry'),(57,1,'2017-11-11 07:50:49','cloud_log.2017-11-11-15-15-50.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-11-15-15-50.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-11-15-15-50.tar.gz','F48DWJ8-邮政slb文件系统只读'),(58,1,'2017-11-13 04:10:28','cloud_log.2017-11-13-11-58-46.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-13-11-58-46.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-13-11-58-46.tar.gz',''),(59,1,'2017-11-16 07:45:04','cloud_log.2017-10-25-14-24-43.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-10-25-14-24-43.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-10-25-14-24-43.tar.gz','测试\r\n'),(60,1,'2017-11-16 07:46:40','cloud_log.2017-10-20-16-44-59.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-10-20-16-44-59.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-10-20-16-44-59.tar.gz',''),(61,1,'2017-11-17 07:12:12','cloud_log.2017-11-17-15-10-19.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-11-17-15-10-19.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-11-17-15-10-19.tar.gz','测试'),(62,1,'2017-11-21 12:43:49','cloud_log.2017-10-23-10-11-22.tar.gz',1,'http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/check_report_cloud_log.2017-10-23-10-11-22.html','http://135400.oss-cn-hangzhou-zmf.aliyuncs.com/web_bucket/cloud_log.2017-10-23-10-11-22.tar.gz','啊');
/*!40000 ALTER TABLE `upload_tarball_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-11-24 18:20:33
