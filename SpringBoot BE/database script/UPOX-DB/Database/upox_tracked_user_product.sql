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
-- Table structure for table `tracked_user_product`
--

DROP TABLE IF EXISTS `tracked_user_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracked_user_product` (
  `cost` int NOT NULL,
  `date_bought` datetime(6) DEFAULT NULL,
  `date_open` datetime(6) DEFAULT NULL,
  `date_status_change` datetime(6) DEFAULT NULL,
  `expiry_date` datetime(6) DEFAULT NULL,
  `frequency` varchar(255) DEFAULT NULL,
  `is_opened` bit(1) NOT NULL,
  `num_product_opened` int DEFAULT NULL,
  `people_use` int NOT NULL,
  `quantity` int NOT NULL,
  `volume` int NOT NULL,
  `volume_left` int DEFAULT NULL,
  `way_payment` varchar(255) DEFAULT NULL,
  `way_preserve` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `product_id` varchar(255) NOT NULL,
  `charity_id` varchar(255) DEFAULT NULL,
  `status_id` varchar(255) DEFAULT NULL,
  `products_in_use` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`product_id`,`transaction_id`),
  KEY `FK9jwx9tb199hli06g4fs0a0elb` (`transaction_id`),
  KEY `FK99sgtxxgdg5xahp0lqb6kjj6p` (`charity_id`),
  KEY `FK4vwndbm4kweh63l3v9wb5f8ux` (`status_id`),
  CONSTRAINT `FK4vwndbm4kweh63l3v9wb5f8ux` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_product_id`),
  CONSTRAINT `FK99sgtxxgdg5xahp0lqb6kjj6p` FOREIGN KEY (`charity_id`) REFERENCES `charity` (`charity_id`),
  CONSTRAINT `FK9jwx9tb199hli06g4fs0a0elb` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`transaction_id`),
  CONSTRAINT `FKpukrwbch6uqyfrh1y5o6g28wf` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracked_user_product`
--

LOCK TABLES `tracked_user_product` WRITE;
/*!40000 ALTER TABLE `tracked_user_product` DISABLE KEYS */;
INSERT INTO `tracked_user_product` VALUES (55000,'2024-10-28 00:00:00.000000',NULL,'2024-10-28 17:07:54.073066','2025-04-28 00:00:00.000000','2/1',_binary '\0',0,5,10,30,0,NULL,'Nhiệt độ phòng','2183cc51-9c6a-46bd-9138-2f524837b3a0','01b41c53-cea0-451b-bd69-d2f9bda23de3',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 22:39:29.389700','2025-11-14 00:00:00.000000','2/1',_binary '\0',0,2,10,150,0,NULL,'Nhiệt độ phòng','02c7444a-65b7-4753-8eb5-848fa7d63171','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-10-28 00:00:00.000000',NULL,'2024-10-28 17:07:48.365369','2025-10-28 00:00:00.000000','2/1',_binary '\0',0,2,5,150,0,NULL,'Nhiệt độ phòng','2183cc51-9c6a-46bd-9138-2f524837b3a0','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 22:55:13.394509','2025-11-14 00:00:00.000000','1/1',_binary '\0',0,2,12,150,0,NULL,'Nhiệt độ phòng','2c12fd36-f8e4-436a-b89c-59c083e16fc5','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000','2024-11-15 12:03:26.933562','2024-11-15 12:03:24.118525','2025-11-14 00:00:00.000000','1/1',_binary '',1,2,12,150,150,NULL,'Nhiệt độ phòng','3c482cb1-eb45-4f24-a1ec-2bd47971a5e0','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219','{\"id\": \"6de7d2f9-694e-42fc-8104-da5345ddf132\",\"statusName\": \"NORMAL\",\"avgAmountUse\": \"2.0\",\"dateOpen\": \"2024-11-15 12:03\",\"openDateStatusChange\": \"2024-11-15 12:03\",\"volumeLeft\": \"150.0\",\"openExpiryDate\": \"2025-11-15 12:03\"}'),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 22:57:35.672139','2025-11-14 00:00:00.000000','1/1',_binary '\0',0,2,12,150,0,NULL,'Nhiệt độ phòng','519dfb82-6412-4f40-a737-b308f59bd9ec','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 23:00:59.464623','2025-11-14 00:00:00.000000','1/1',_binary '\0',0,2,12,150,0,NULL,'Nhiệt độ phòng','700667a4-d5cf-4314-814e-254fbd644830','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 23:00:14.468136','2025-11-14 00:00:00.000000','1/1',_binary '\0',0,2,12,150,0,NULL,'Nhiệt độ phòng','9c57039b-e4cf-4d4f-a29d-a150b0db9ad8','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 22:58:49.738305','2025-11-14 00:00:00.000000','1/1',_binary '\0',0,2,12,150,0,NULL,'Nhiệt độ phòng','d97d6b16-49f8-45cd-a63e-a4c1332ff1a4','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL),(150000,'2024-11-14 00:00:00.000000',NULL,'2024-11-14 23:08:47.681672','2025-11-14 00:00:00.000000','1/1',_binary '\0',0,2,12,150,0,NULL,'Nhiệt độ phòng','faf66219-aa05-420a-b751-e6a2f6b0ebcb','32315515-4aa7-45fc-ae6e-94b025d25afb',NULL,'03ccba7f-6fbd-4b98-a442-120bb35a3219',NULL);
/*!40000 ALTER TABLE `tracked_user_product` ENABLE KEYS */;
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
