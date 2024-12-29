CREATE DATABASE  IF NOT EXISTS `upox` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `upox`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: upox
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` varchar(255) NOT NULL,
  `dob` date DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gender` int NOT NULL,
  `phone_num` varchar(255) DEFAULT NULL,
  `role` varbinary(255) DEFAULT NULL,
  `activated` bit(1) NOT NULL,
  `google_login` bit(1) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('318ab0b9-831a-4a0e-a5aa-65d2db9a3c82',NULL,NULL,NULL,'890231232','tai',NULL,'buikhoa2015@gmail.com',0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('44525572-7236-4b47-a7bb-9d6d3adcb0c3',NULL,NULL,NULL,'$2a$10$VdOOb.XA4/BAlYGH5n9ihu3VQkSmzITt1M5H2znUj3/hbvl.zAcCC','admin',NULL,NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('48cea211-9e08-47e5-a411-645095c6a1ce','2003-10-06','Nguyen','Khoa','$2a$10$hj7e8oFxWmjMU.7tUFueq.Rh7r0WUXADbERe8UD1Tx6jOA.7hkPju','nak','Ha Noi','buikhoa2015@gmail.com',0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('5d1ce0c7-c731-41e1-910b-5bceaae726d4','2003-12-06','Tran','Phong','89023123','fong',NULL,NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('6ebe2d11-f8ca-4913-b40c-966197a6f381',NULL,NULL,NULL,'$2a$10$g8JVKNGOWl13mGonegwpbOUbfQbdda7ZSzmTEBd/vMqU.MZMkmMpO','Duy','',NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('9442a1fc-5a46-49a9-9d62-1d3d90935507',NULL,NULL,NULL,'$2a$10$TCasaet/wkeEZ63rnAxAh.bf3SHtI27Am1.RzmU/wlCuFZrbhagdu','thanh',NULL,NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('99b0759e-6cff-42a4-82fa-d37d576cad22',NULL,NULL,'9060 - Nguyễn Bùi Anh Khoa',NULL,'9060 - Nguyễn Bùi Anh Khoa','','buikhoa2015@gmail.com',0,NULL,NULL,_binary '',_binary '',NULL,NULL),('abcf927e-990e-416a-9beb-94f08d17df56',NULL,NULL,NULL,'$2a$10$GfMF0zZ8wvhChdxFxltP8O1HyYoOe82lkIeXvGnNtv8eAfHA/Ui.a','huy',NULL,NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('c4d9b40f-2cc0-4f4d-8d5b-9aebebdd25ad','2003-10-06','Nguyen','Khoa','89023126','khoa','Ha Noi',NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('cf5bf638-29bf-44ce-b7fa-9b0eb992cf77',NULL,NULL,NULL,'$2a$10$x92WKHOq0xb1Gi2GoVVW5eMe7lJ7XIsfZEA6cGvaQjfi0RYE.qmcm','Đạt','',NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('dbbb6571-1f2c-47a6-b41a-1bd016a5c516',NULL,NULL,NULL,'$2a$10$Xfj3UAn9B3gZ5CGJe89ihOhYeoDqx1PTpfihEIvfd7MDQE4vYMtEy','Kkkkk','',NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('de261023-b834-4e01-ade2-e93b970f5c8d',NULL,NULL,NULL,'$2a$10$Sfv5b.jrYAUp/O0yCCU7nOtuhfybcMJxuwc2sUQGU4/N8v9nxKJxi','nhut',NULL,NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL),('ea0a0ca4-c2fe-45a1-baaa-5a35249716ac',NULL,NULL,NULL,'$2a$10$v4k5Vn1eZt4ZfxBx/.r08OPh4pbEtd9pUHoYkN2NOOI15FP5wERY2','dung',NULL,NULL,0,NULL,NULL,_binary '\0',_binary '\0',NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-26 14:05:56
