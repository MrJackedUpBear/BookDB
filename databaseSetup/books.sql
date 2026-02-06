/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: Books
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `Book`
--

DROP TABLE IF EXISTS `Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Book` (
  `bookId` bigint(20) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `imageLoc` varchar(255) NOT NULL,
  `isbn` varchar(13) NOT NULL,
  `language` varchar(40) NOT NULL,
  `publishDate` datetime(6) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `title` varchar(80) NOT NULL,
  PRIMARY KEY (`bookId`),
  UNIQUE KEY `UKbi5lx9jtv1f52idrmc0ck8ysx` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Book`
--

LOCK TABLES `Book` WRITE;
/*!40000 ALTER TABLE `Book` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Book` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `BookAvailability`
--

DROP TABLE IF EXISTS `BookAvailability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BookAvailability` (
  `count` int(11) NOT NULL,
  `availability` varchar(15) NOT NULL,
  `BookId` bigint(20) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  PRIMARY KEY (`BookId`,`count`,`UserId`),
  KEY `FKhpivepaow7l139qoj282bjpnv` (`UserId`),
  CONSTRAINT `FK5htcyc379gdvijhbn1tl8gqob` FOREIGN KEY (`BookId`) REFERENCES `Book` (`bookId`),
  CONSTRAINT `FKhpivepaow7l139qoj282bjpnv` FOREIGN KEY (`UserId`) REFERENCES `User` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BookAvailability`
--

LOCK TABLES `BookAvailability` WRITE;
/*!40000 ALTER TABLE `BookAvailability` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `BookAvailability` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Permission`
--

DROP TABLE IF EXISTS `Permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Permission` (
  `permissionId` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `permissionName` varchar(80) NOT NULL,
  `permissionStatus` varchar(15) NOT NULL,
  PRIMARY KEY (`permissionId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Permission`
--

LOCK TABLES `Permission` WRITE;
/*!40000 ALTER TABLE `Permission` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Permission` VALUES
(1,'Allow the user to add books to the database...','Add Book','POST'),
(2,'Allow the user to remove books from the database...','Delete Book','DELETE'),
(3,'Allow the user to update a book in the database...','Update Book','PUT'),
(4,'Allow the user to get books from the database...','Get Book','GET');
/*!40000 ALTER TABLE `Permission` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `RefreshToken`
--

DROP TABLE IF EXISTS `RefreshToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RefreshToken` (
  `refreshToken` varchar(255) NOT NULL,
  `dateProvisioned` datetime(6) NOT NULL,
  `expiryDate` datetime(6) NOT NULL,
  `lastUsed` datetime(6) NOT NULL,
  `UserId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`refreshToken`),
  KEY `FKaa8o8mcp7wbgqmyxia5nbm23f` (`UserId`),
  CONSTRAINT `FKaa8o8mcp7wbgqmyxia5nbm23f` FOREIGN KEY (`UserId`) REFERENCES `User` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefreshToken`
--

LOCK TABLES `RefreshToken` WRITE;
/*!40000 ALTER TABLE `RefreshToken` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `RefreshToken` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Review`
--

DROP TABLE IF EXISTS `Review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Review` (
  `reviewId` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `rating` double NOT NULL,
  `title` varchar(80) NOT NULL,
  `BookId` bigint(20) DEFAULT NULL,
  `UserId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`reviewId`),
  KEY `FK2s8in7m5n12ic7a9p5jvve15l` (`BookId`),
  KEY `FKqxcvsfeqaqgtiv5yl57jab801` (`UserId`),
  CONSTRAINT `FK2s8in7m5n12ic7a9p5jvve15l` FOREIGN KEY (`BookId`) REFERENCES `Book` (`bookId`),
  CONSTRAINT `FKqxcvsfeqaqgtiv5yl57jab801` FOREIGN KEY (`UserId`) REFERENCES `User` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `Review` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Role` (
  `roleId` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `roleName` varchar(30) NOT NULL,
  `roleStatus` varchar(15) NOT NULL,
  PRIMARY KEY (`roleId`),
  UNIQUE KEY `UK9w2skwb5squ3usiaiml4iw9e7` (`roleName`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Role`
--

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `Role` VALUES
(1,'Administrators of this app. Only give to users that need to do everything.','Admin','All'),
(2,'Users that have access to view and add books to the database','Elevated User','Most'),
(3,'Users that can only view books','General User','View');
/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `RolePermission`
--

DROP TABLE IF EXISTS `RolePermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RolePermission` (
  `dateProvisioned` datetime(6) NOT NULL,
  `description` varchar(255) NOT NULL,
  `PermissionId` bigint(20) NOT NULL,
  `RoleId` bigint(20) NOT NULL,
  PRIMARY KEY (`PermissionId`,`RoleId`),
  KEY `FK35xfvovmoqp6h003l4mo9h99s` (`RoleId`),
  CONSTRAINT `FK35xfvovmoqp6h003l4mo9h99s` FOREIGN KEY (`RoleId`) REFERENCES `Role` (`roleId`),
  CONSTRAINT `FKte3vk7n65jm131i3dl1l9vn7o` FOREIGN KEY (`PermissionId`) REFERENCES `Permission` (`permissionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RolePermission`
--

LOCK TABLES `RolePermission` WRITE;
/*!40000 ALTER TABLE `RolePermission` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `RolePermission` VALUES
('0000-00-00 00:00:00.000388','Give access to admin to add books',1,1),
('0000-00-00 00:00:00.000388','Give access to elevated user to add books',1,2),
('0000-00-00 00:00:00.000388','Give access to admin to delete books',2,1),
('0000-00-00 00:00:00.000388','Give access to admin to update books',3,1),
('0000-00-00 00:00:00.000388','Give access to admin to view books',4,1),
('0000-00-00 00:00:00.000388','Give access to elevated user to view books',4,2),
('0000-00-00 00:00:00.000388','Give access to general user to view books',4,3);
/*!40000 ALTER TABLE `RolePermission` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `userId` bigint(20) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(30) NOT NULL,
  `lastName` varchar(30) NOT NULL,
  `numOwnedBooks` int(11) NOT NULL,
  `password` varbinary(255) NOT NULL,
  `username` varchar(30) NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `UKjreodf78a7pl5qidfh43axdfb` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `UserRole`
--

DROP TABLE IF EXISTS `UserRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserRole` (
  `dateProvisioned` datetime(6) NOT NULL,
  `description` varchar(255) NOT NULL,
  `UserId` bigint(20) NOT NULL,
  `RoleId` bigint(20) NOT NULL,
  PRIMARY KEY (`RoleId`,`UserId`),
  KEY `FK5jq14av8e8bf5br021uoqnmkw` (`UserId`),
  CONSTRAINT `FK5jq14av8e8bf5br021uoqnmkw` FOREIGN KEY (`UserId`) REFERENCES `User` (`userId`),
  CONSTRAINT `FKg1ejth3htkirbqrh6npi60wmt` FOREIGN KEY (`RoleId`) REFERENCES `Role` (`roleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserRole`
--

LOCK TABLES `UserRole` WRITE;
/*!40000 ALTER TABLE `UserRole` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `UserRole` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-02-05 18:49:22
