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
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` varchar(255) NOT NULL,
  `def_cost` varchar(255) DEFAULT NULL,
  `def_expiry_date` varchar(255) DEFAULT NULL,
  `def_preserve_way` varchar(255) DEFAULT NULL,
  `def_volume` varchar(255) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `segment` varchar(255) DEFAULT NULL,
  `category_id` varchar(255) DEFAULT NULL,
  `avg_usage_amount` double NOT NULL,
  `def_opened_expired_date` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1mtsbur82frn64de7balymq9s` (`category_id`),
  CONSTRAINT `FK1mtsbur82frn64de7balymq9s` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES ('01b41c53-cea0-451b-bd69-d2f9bda23de3','\"{\\n \\\"common\\\": [\\\"35000 ₫\\\", \\\"65000 ₫\\\"],\\n \\\"lessCommon\\\": [\\\"45000 ₫\\\", \\\"70000 ₫\\\"]\\n}\"','3 years','Nhiệt độ phòng','\"{\\n \\\"common\\\": [\\\"50 pieces\\\", \\\"30 pieces\\\"],\\n \\\"lessCommon\\\": [\\\"10 pieces\\\", \\\"20 pieces\\\"]\\n}\"','Mặt nạ',NULL,'bff67b27-066a-4317-b589-336d5783d071',0,'unchanged','/mask'),('043b1b41-3066-4d53-acc9-d0d90f1a19b3','\"{\\n \\\"common\\\": [\\\"25000 ₫\\\"]\\n}\"','2 months','Nhiệt độ mát','\"{\\n \\\"common\\\": [\\\"65 ml\\\"]\\n}\"','Sữa chua uống',NULL,'df0cbf11-4518-478c-a657-651ed151ef63',0,'48 hours','/probie'),('27942aac-072d-47a0-97e8-d290c10873b7','\"{\\n \\\"common\\\": [\\\"48000 ₫\\\", \\\"25000 ₫\\\"],\\n \\\"lessCommon\\\": [\\\"66000 ₫\\\", \\\"20000 ₫\\\"]\\n}\"','2 years','Nhiệt độ phòng','\"{\\n \\\"common\\\": [\\\"150 g\\\", \\\"100 g\\\"],\\n \\\"lessCommon\\\": [\\\"170 g\\\", \\\"200 g\\\"]\\n}\"','Kem đánh răng',NULL,'82f2328b-7570-4d4c-bbb3-bc1cec12091b',2,'1 year','/toothpaste'),('32315515-4aa7-45fc-ae6e-94b025d25afb','\"{\\n \\\"common\\\": [\\\"200000 ₫\\\", \\\"150000 ₫\\\"],\\n \\\"lessCommon\\\": [\\\"500000 ₫\\\", \\\"40000 ₫\\\"]\\n}\"','3 years','Nhiệt độ phòng','\"{\\n \\\"common\\\": [\\\"150 ml\\\"],\\n \\\"lessCommon\\\": [\\\"200 ml\\\"]\\n}\"','Kem rửa mặt',NULL,'bff67b27-066a-4317-b589-336d5783d071',2,'12 months','/cleanser'),('731dca0c-ed36-4351-984a-89bc0e61dc5a','\"{\\n \\\"common\\\": [\\\"150000 ₫\\\"],\\n \\\"lessCommon\\\": [\\\"80000 ₫\\\"]\\n}\"','3 years','Nhiệt độ phòng','\"{\\n \\\"common\\\": [\\\"3.8 l\\\", \\\"5 l\\\"],\\n \\\"lessCommon\\\": [\\\"2 l\\\", \\\"1 l\\\"]\\n}\"','Nước lau nhà',NULL,'2f349447-1a55-4c2c-b736-a57f188e19fc',60,'unchanged','/cleaningLiquid'),('792c5f09-bc33-451d-b14a-586a0cf361ce','\"{\\n \\\"common\\\": [\\\"11000 ₫\\\" ,\\\"8000 ₫\\\"]\\n }\"','6 months','Nhiệt độ mát','\"{\\n \\\"common\\\": [\\\"220 ml\\\"]\\n}\"','Sữa bịch',NULL,'df0cbf11-4518-478c-a657-651ed151ef63',0,'48 hours','/milkPack'),('8ffa4b62-077c-420f-8434-6b85e9cdb5c4','\"{\\n \\\"common\\\": [\\\"200000 ₫\\\", \\\"150000 ₫\\\"],\\n \\\"lessCommon\\\": [\\\"500000 ₫\\\", \\\"40000 ₫\\\"]\\n}\"','1 year','Nhiệt độ phòng','\"{\\n \\\"common\\\": [\\\"3.6 l\\\", \\\"2.7 l\\\"],\\n \\\"lessCommon\\\": [\\\"2.2 l\\\", \\\"2.4 l\\\"]\\n}\"','Bột giặt - Nước giặt',NULL,'b1f19115-c119-48c8-a4ad-b0b2707da86a',65,'unchanged','/laundry');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
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
