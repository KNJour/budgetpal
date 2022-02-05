CREATE DATABASE  IF NOT EXISTS `budgets` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `budgets`;
-- MySQL dump 10.13  Distrib 8.0.22, for macos10.15 (x86_64)
--
-- Host: localhost    Database: budgets
-- ------------------------------------------------------
-- Server version	8.0.23

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
-- Table structure for table `budget_categories`
--

DROP TABLE IF EXISTS `budget_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budget_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `category_id` int NOT NULL,
  `budget_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_budget_categories_categories1_idx` (`category_id`),
  KEY `fk_budget_categories_budgets1_idx` (`budget_id`),
  CONSTRAINT `fk_budget_categories_budgets1` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`),
  CONSTRAINT `fk_budget_categories_categories1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `budget_categories`
--

LOCK TABLES `budget_categories` WRITE;
/*!40000 ALTER TABLE `budget_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `budget_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `budgets`
--

DROP TABLE IF EXISTS `budgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `budgets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `budget_name` varchar(45) DEFAULT NULL,
  `budget_description` varchar(400) DEFAULT NULL,
  `balance` int DEFAULT NULL,
  `adj_balance` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_budgets_users_idx` (`user_id`),
  CONSTRAINT `fk_budgets_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `budgets`
--

LOCK TABLES `budgets` WRITE;
/*!40000 ALTER TABLE `budgets` DISABLE KEYS */;
INSERT INTO `budgets` VALUES (1,'Food','All food expenses from all sources',400,400,'2021-04-20','2021-05-10','2021-04-25 15:53:08','2021-04-25 15:53:08',1),(2,'Food','this is for food',300,282,'2021-04-26','2021-05-13','2021-04-26 13:20:38','2021-04-26 13:20:38',2),(3,'Bananas','This budget is for bananas only',20,19,'2021-04-26','2021-05-21','2021-04-26 13:26:38','2021-04-26 13:26:38',2),(6,'Bananas','bananas',30,15,'2021-04-25','2021-05-06','2021-04-27 11:25:11','2021-04-27 11:25:11',3),(7,'Food','food itmes',400,400,'2021-04-27','2021-05-26','2021-04-27 11:25:32','2021-04-27 11:25:32',3),(8,'Recreation','This is for things that aren\'t fod',200,200,'2021-04-27','2021-05-20','2021-04-27 16:04:01','2021-04-27 16:04:01',2),(9,'Food','For food',200,116,'2021-04-28','2021-05-05','2021-04-30 15:28:33','2021-04-30 15:28:33',4),(10,'Gas','Gas',100,80,'2021-04-29','2021-05-30','2021-04-30 15:29:19','2021-04-30 15:29:19',4),(12,'Bananas','bananas',400,400,'2021-04-30','2021-05-08','2021-04-30 16:59:30','2021-04-30 16:59:30',4),(13,'food','this is for food',300,289,'2021-05-13','2021-06-07','2021-05-13 22:04:21','2021-05-13 22:04:21',5),(14,'drugs','drugs',400,400,'2021-05-13','2021-06-07','2021-05-13 22:05:00','2021-05-13 22:05:00',5),(15,'Drugs','drug budget',1000,900,'2021-06-13','2021-07-13','2021-06-13 16:23:14','2021-06-13 16:23:14',9),(16,'food','food',400,390,'2021-06-06','2021-06-27','2021-06-13 16:23:34','2021-06-13 16:23:34',9),(17,'bananas','bananas',50,50,'2021-06-13','2021-06-10','2021-06-13 16:25:06','2021-06-13 16:25:06',9),(18,'Food','A budget for bananas',400,380,'2022-01-10','2022-01-31','2022-01-10 12:49:29','2022-01-10 12:49:29',10),(19,'Food','A budget for Food, not including bananas',400,377,'2022-01-10','2022-02-17','2022-01-10 13:59:20','2022-01-10 13:59:20',11),(20,'Bananas','A budget for bananas only',800,787,'2022-01-10','2022-02-11','2022-01-10 13:59:46','2022-01-10 13:59:46',11),(21,'Test budget','a test',223,189,'2022-01-10','2022-01-11','2022-01-10 14:00:04','2022-01-10 14:00:04',11);
/*!40000 ALTER TABLE `budgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(30) DEFAULT NULL,
  `items` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_categories_users1_idx` (`user_id`),
  CONSTRAINT `fk_categories_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(25) DEFAULT NULL,
  `last_name` varchar(25) DEFAULT NULL,
  `user_name` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'keith','journell','kjournell','password','k@k.com','2021-04-25 15:44:26','2021-04-25 15:44:26'),(2,'bob','jones','thebob','$2b$12$xljuPTmzzY3OyGg7701JlOkvZ5XpNMLalsYTwfKHLdie6jIjzIvoG','bjones@gmail.com','2021-04-25 16:31:07','2021-04-25 16:31:07'),(3,'joe','joe','joejoe','$2b$12$HhtgmSku/iBzApYJ2.aEOuaKfCsWMM6GJtI.V3GzM7/CTJNq3yH0W','joe@joe.com','2021-04-27 11:24:22','2021-04-27 11:24:22'),(4,'Keith','Journell','user','$2b$12$BWnjsVezsx7E.K.teiPYje59N0tgteV98xSMxMLNU5qR2ZlSjJLWa','email@email.com','2021-04-30 15:05:05','2021-04-30 15:05:05'),(5,'bob','bob','bbob','$2b$12$jHQowSSs4qYtuVVQYDDgauPjVb681SgzRcOLTEtroY2X9yTh7eBay','bob@bob.com','2021-04-30 16:58:19','2021-04-30 16:58:19'),(6,'greg','jones','banana','$2b$12$ZiC3kP0euvaW/7uhUBILMOD/otVP0yG43VVlzxhk4AgoWXYt.I5/W','h@h.com','2021-05-13 21:59:59','2021-05-13 21:59:59'),(7,'keith','journell','kjournell','password','k@k.com','2021-06-02 18:06:18','2021-06-02 18:06:18'),(8,'Andy','Journell','andy','$2b$12$9jreWVsWxUtIAhTkvAaq2OJjsV4kVTqfV1Er7a/Uw7GWk0dn/wTWy','andy@andy.com','2021-06-13 15:59:20','2021-06-13 15:59:20'),(9,'testing','testing','testingtesting','$2b$12$5Mq6ACAKbC/T2y8888Yo0ubClNzDj45WZFAOGcPB1t1ak4k.nuXGe','testing@testing.com','2021-06-13 16:05:30','2021-06-13 16:05:30'),(10,'Keith','Journell','knjournell','$2b$12$WwHWue0ZcM9m8HL/35hLjufyJCfG3rwre8iuVYkaOipepcpQzsvqe','roughtakes@gmail.com','2022-01-10 12:48:24','2022-01-10 12:48:24'),(11,'Guest','McGuest','guest','$2b$12$mK3IPpcUQQqSHeufERhEqupQWfFFWrlWsGfwXrviV/hC9P3XepFKS','knjournellbiz@gmail.com','2022-01-10 13:33:24','2022-01-10 13:33:24');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-10 18:23:40
