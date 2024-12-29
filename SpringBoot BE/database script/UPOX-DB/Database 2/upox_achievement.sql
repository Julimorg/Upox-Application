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
-- Table structure for table `achievement`
--

DROP TABLE IF EXISTS `achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `achievement` (
  `achievement_id` varchar(255) NOT NULL,
  `achievement_name` varchar(255) DEFAULT NULL,
  `achievement_type` varchar(255) DEFAULT NULL,
  `level` int NOT NULL,
  `limit_to_upgrade` int NOT NULL,
  PRIMARY KEY (`achievement_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achievement`
--

LOCK TABLES `achievement` WRITE;
/*!40000 ALTER TABLE `achievement` DISABLE KEYS */;
INSERT INTO `achievement` VALUES ('1dd89860-81df-4838-91b5-ba314d124fb4','Người bạn của tương lai xanh','Tiêu dùng',3,7),('40f5f9cb-b572-4b9c-9561-6984ce656372','Tiết kiệm thông minh','Tiết Kiệm',1,3),('80040ce7-84d0-4c94-a0f2-ef740672dc14','Người hùng thầm lặng','Từ thiện',2,5),('836a878f-190d-4efe-8589-4237e00f0401','Tiêu dùng tinh tế','Tiêu dùng',2,5),('8e33c225-3079-44c1-aa67-a37cac8fef49','Bậc thầy tiết kiệm','Tiết Kiệm',2,5),('8ea9feba-6c8b-4541-ad66-6e026ca4251f','Người bạn đồng hành','Từ thiện',3,7),('948448fb-16b7-438e-bcb0-225851cd258f','Doanh thân tương lai','Tiết Kiệm',3,7),('95114a27-711b-420b-9f28-ae52b361df09','Trái tim ấm áp','Từ thiện',1,3),('be90cf82-fab6-457d-af26-8e66831f1d60','Tiêu dùng có trách nhiệm','Tiêu dùng',1,3);
/*!40000 ALTER TABLE `achievement` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-26 14:11:17
