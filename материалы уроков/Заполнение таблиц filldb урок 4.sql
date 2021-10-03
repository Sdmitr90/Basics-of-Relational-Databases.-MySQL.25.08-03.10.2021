USE vk;

-- MariaDB dump 10.17  Distrib 10.4.15-MariaDB, for Linux (x86_64)
--
-- Host: mysql.hostinger.ro    Database: u574849695_23
-- ------------------------------------------------------
-- Server version	10.4.15-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin_user_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `communities_name_idx` (`name`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `communities_ibfk_1` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
INSERT INTO `communities` VALUES (1,'a',1),(2,'iure',2),(3,'adipisci',3),(4,'ullam',4),(5,'eligendi',5),(6,'pariatur',6),(7,'cum',7),(8,'nisi',8),(9,'quas',9),(10,'nam',10);
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friend_requests` (
  `initiator_user_id` bigint(20) unsigned NOT NULL,
  `target_user_id` bigint(20) unsigned NOT NULL,
  `status` enum('requested','approved','declined','unfriended') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requested_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`initiator_user_id`,`target_user_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`initiator_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend_requests`
--

LOCK TABLES `friend_requests` WRITE;
/*!40000 ALTER TABLE `friend_requests` DISABLE KEYS */;
INSERT INTO `friend_requests` VALUES (1,1,'unfriended','2012-03-04 10:54:03','1972-01-15 14:41:48'),(2,2,'approved','2005-08-04 03:19:20','2005-06-21 07:32:40'),(3,3,'declined','1974-04-23 20:50:19','2016-12-24 14:59:53'),(4,4,'unfriended','2015-10-12 19:10:46','1970-01-07 11:33:49'),(5,5,'declined','2000-01-05 10:23:44','2003-06-22 04:44:59'),(6,6,'declined','2017-05-19 08:20:19','1992-08-11 22:28:26'),(7,7,'requested','1987-09-07 22:40:07','1981-12-22 22:27:27'),(8,8,'declined','1994-03-28 07:34:59','2007-01-24 19:50:24'),(9,9,'approved','1972-09-21 23:09:42','2018-03-29 03:35:40'),(10,10,'declined','2008-10-07 08:24:55','1985-06-05 15:04:50');
/*!40000 ALTER TABLE `friend_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (1,1,1,'1999-10-17 01:28:01'),(2,2,2,'2013-10-18 06:26:35'),(3,3,3,'1990-07-27 02:57:34'),(4,4,4,'2013-01-15 21:05:25'),(5,5,5,'1994-04-11 07:18:13'),(6,6,6,'2004-05-10 02:03:15'),(7,7,7,'2014-11-26 05:17:53'),(8,8,8,'2012-06-11 19:54:32'),(9,9,9,'1998-06-05 15:11:47'),(10,10,10,'2006-05-13 05:25:47');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  KEY `media_type_id` (`media_type_id`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `media_ibfk_2` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,1,1,'Eos eaque qui nam iusto nihil. A enim maiores voluptate non corporis consectetur. Perspiciatis iure quibusdam quia illo saepe sit cum.','molestiae',3009,NULL,'2015-09-13 05:49:00','1998-02-07 02:52:18'),(2,2,2,'Dicta asperiores odit excepturi et optio. Quas dignissimos rem optio.','totam',41307962,NULL,'1995-05-21 09:28:52','1988-06-14 22:41:48'),(3,3,3,'Nemo velit velit assumenda occaecati maxime qui sunt. Ipsa voluptatem et velit maxime facilis. Itaque quisquam sapiente alias facilis nisi qui.','facere',376131665,NULL,'1972-11-16 13:42:34','2008-06-18 09:57:01'),(4,4,4,'Inventore qui quo cum praesentium. Veritatis non enim tempore sequi repellendus doloremque aliquam numquam. Est enim non minus ea veritatis.','necessitatibus',8184148,NULL,'1989-07-19 16:37:38','1988-07-10 14:46:16'),(5,1,5,'Dignissimos quae dolor error iure. Qui placeat et praesentium modi quo recusandae. Odit sit ratione cum omnis. Ipsam blanditiis consequatur maiores rem reprehenderit occaecati. Velit accusantium velit eos.','quo',129531,NULL,'2007-09-25 21:05:02','2018-01-16 03:28:35'),(6,2,6,'Maiores neque animi distinctio perspiciatis unde. Eum dolores quis expedita officiis nihil. Quam tempora facere excepturi necessitatibus.','rerum',7120,NULL,'1973-09-13 10:11:43','2018-04-27 04:48:40'),(7,3,7,'Autem sed et eveniet magnam. Pariatur sequi quia dolorem. Deserunt et dolorem quia error sit est iste optio. Quia unde est quis voluptatum corrupti. Saepe et doloribus minima dolores repellendus dolor enim.','harum',7974033,NULL,'2007-01-05 00:39:53','1975-08-06 17:59:49'),(8,4,8,'Nisi sapiente et ut perferendis. Accusamus illum ut quia mollitia fugiat pariatur assumenda. Nobis ipsa ut veniam doloremque fugit consequatur repudiandae et. Sit voluptas consectetur porro qui.','et',4202,NULL,'2014-12-19 01:20:27','1986-08-21 03:38:58'),(9,1,9,'Excepturi atque corporis eligendi qui et dolorem. Ut sit sit accusantium rerum labore ratione. Dolorem quia odit reiciendis et incidunt perspiciatis enim vel. Ut quo occaecati recusandae error quis enim natus.','enim',23426,NULL,'2018-08-19 02:54:50','1987-08-15 21:05:58'),(10,2,10,'Dolor delectus aliquam quia qui rerum provident eos. Sunt eius delectus repellat neque voluptatem laudantium. Pariatur eum culpa magnam iusto. Et enim est nam quod rerum error.','soluta',9,NULL,'2021-06-28 23:19:11','1997-02-26 18:52:34');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_types`
--

DROP TABLE IF EXISTS `media_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_types`
--

LOCK TABLES `media_types` WRITE;
/*!40000 ALTER TABLE `media_types` DISABLE KEYS */;
INSERT INTO `media_types` VALUES (1,'cum','1983-05-06 15:32:33','2019-07-18 05:00:38'),(2,'in','1995-05-09 22:05:04','2013-01-29 12:12:23'),(3,'quaerat','2021-07-17 04:49:28','2016-09-08 15:11:22'),(4,'nihil','1994-11-04 19:57:36','1997-03-01 05:04:50');
/*!40000 ALTER TABLE `media_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint(20) unsigned NOT NULL,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  UNIQUE KEY `id` (`id`),
  KEY `from_user_id` (`from_user_id`),
  KEY `to_user_id` (`to_user_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,1,1,'Qui non dolore aut tempora. Ut a quia ut labore. Est minus molestiae qui repellat sunt autem.','1988-01-31 18:46:49'),(2,2,2,'Eos eos aspernatur voluptas corrupti consectetur temporibus. Vitae sed maiores quia quia deserunt. Similique unde doloribus cumque mollitia officiis praesentium corrupti eos.','1978-07-24 12:00:52'),(3,3,3,'Sit omnis non est doloremque itaque ipsa. Praesentium odio velit ipsam cumque. Distinctio quo corrupti quas hic. Et quas odit quis soluta consectetur sint sint. Aliquid eos id voluptatibus illum ea et ut est.','2000-09-16 05:12:19'),(4,4,4,'Cum enim consequuntur nostrum et autem quia ullam. Et perferendis consequatur quis magni soluta quia omnis.','1984-08-07 06:35:13'),(5,5,5,'A sapiente autem facere ab beatae. Id molestiae est sit ut sint eligendi perspiciatis. Facere fugit ea est rerum repudiandae voluptatibus. Id rerum ducimus voluptas maxime.','2005-01-17 08:06:54'),(6,6,6,'Enim est voluptatem eius quasi. Cumque occaecati quo suscipit dignissimos doloremque enim aut. Qui voluptates mollitia repellendus nihil. Illo sit quaerat ad dolores qui.','1994-05-16 01:02:07'),(7,7,7,'Ipsa pariatur et voluptatibus rerum repellat inventore repellat. Laboriosam doloribus non modi aut quia quia. Ratione ullam nemo omnis vel rerum nam.','1984-06-25 11:42:18'),(8,8,8,'Aut ipsa voluptatum atque. Nihil voluptas assumenda corrupti et laudantium sapiente quia est. Asperiores sit ducimus praesentium sunt inventore. Dolor quia necessitatibus et accusamus et autem necessitatibus.','1984-12-18 01:43:19'),(9,9,9,'Qui qui ex placeat molestias est blanditiis. Perspiciatis et corrupti omnis rem id. Fuga sunt molestiae libero qui occaecati accusantium labore qui. Ea earum a minima assumenda ipsa sit.','2000-07-08 08:51:15'),(10,10,10,'Officia hic sit sunt in excepturi. Voluptates enim odit consectetur tenetur reprehenderit eos harum. Et est quis explicabo officia sapiente.','2019-03-31 08:17:16');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_albums`
--

DROP TABLE IF EXISTS `photo_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photo_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `photo_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photo_albums`
--

LOCK TABLES `photo_albums` WRITE;
/*!40000 ALTER TABLE `photo_albums` DISABLE KEYS */;
INSERT INTO `photo_albums` VALUES (1,'illo',1),(2,'voluptatem',2),(3,'expedita',3),(4,'et',4),(5,'sunt',5),(6,'iusto',6),(7,'est',7),(8,'beatae',8),(9,'iste',9),(10,'tenetur',10);
/*!40000 ALTER TABLE `photo_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`),
  CONSTRAINT `photos_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10);
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `photo_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `hometown` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,'m','1986-01-08',1,'1973-10-02 10:32:30',NULL),(2,'m','1999-06-11',2,'1980-06-19 19:14:58',NULL),(3,'f','2018-11-03',3,'1985-05-28 06:40:11',NULL),(4,'f','2010-04-05',4,'2017-07-15 07:15:37',NULL),(5,'f','1975-05-16',5,'1983-07-06 02:38:02',NULL),(6,'f','1977-07-27',6,'1970-06-20 20:30:05',NULL),(7,'m','1984-04-29',7,'1973-01-18 23:48:58',NULL),(8,'m','1970-10-22',8,'2001-11-20 05:15:54',NULL),(9,'f','2011-03-13',9,'2020-04-03 20:41:46',NULL),(10,'m','1991-05-22',10,'2020-05-31 17:10:02',NULL);
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Фамиль',
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `users_firstname_lastname_idx` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='юзеры';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Keyshawn','Bechtelar','jenkins.bennie@example.com','b9877ea34675f88c78cc24d5d5c7d3642b05c3df',89084107839),(2,'Frances','Turcotte','krystel34@example.org','34998d99472eb8be722c797257eb9f9490be5b34',89768790245),(3,'Melvin','Kunde','julian.sauer@example.com','7dc5f6cda9704b0650ce6524f59cee72aca5948d',89718258679),(4,'Alyce','Willms','derek55@example.com','72e8eb94a7550f4d44775974bfb3adbcc67b7f81',89573668733),(5,'Winfield','Funk','gunner27@example.com','5384ca0bafb22be7ea03a50cb7bc92eb2abfa1fe',89401127257),(6,'Eliza','Ward','vivien.harber@example.com','82adccc46f2ba773d1e833e3bcb65179b1fa1805',89419488395),(7,'Arnoldo','Leannon','kirk24@example.net','78d988f399f445755162bb0e7e61fdd59a7b59c4',89794604728),(8,'Rosemarie','Cartwright','dstehr@example.com','73501d5416ba2e1da7d503bbcab9f99ecbe10f32',89479454738),(9,'Velma','Abernathy','eichmann.markus@example.com','eb3177626f1ac10a776d52b4a0c3b4a755c288ca',89908324799),(10,'Cloyd','Botsford','wlittel@example.org','b58b0a5f1ee38006e58c11823917bb24c499211f',89457350769);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_communities`
--

DROP TABLE IF EXISTS `users_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_communities` (
  `user_id` bigint(20) unsigned NOT NULL,
  `community_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`community_id`),
  KEY `community_id` (`community_id`),
  CONSTRAINT `users_communities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_communities_ibfk_2` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_communities`
--

LOCK TABLES `users_communities` WRITE;
/*!40000 ALTER TABLE `users_communities` DISABLE KEYS */;
INSERT INTO `users_communities` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
/*!40000 ALTER TABLE `users_communities` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-03  8:51:42
