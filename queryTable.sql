-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: harveyhermandb
-- ------------------------------------------------------
-- Server version	8.4.4
--
-- Table structure for table `aplogin`
--

DROP TABLE IF EXISTS `aplogin`;
CREATE TABLE `aplogin` (
  `ap_id` varchar(255) NOT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `staff_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ap_id`),
  KEY `FK_aplogin_staff_id` (`staff_id`),
  CONSTRAINT `FK_aplogin_staff_id` FOREIGN KEY (`staff_id`) REFERENCES `staffdata` (`staff_id`)
);

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `cart_id` varchar(255) NOT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(38,0) DEFAULT NULL,
  `updated_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cart_id`),
  KEY `FK_cart_user_id` (`user_id`),
  CONSTRAINT `FK_cart_user_id` FOREIGN KEY (`user_id`) REFERENCES `userdata` (`user_id`)
);

--
-- Table structure for table `cart_item`
--

DROP TABLE IF EXISTS `cart_item`;
CREATE TABLE `cart_item` (
  `cart_item_id` varchar(255) NOT NULL,
  `quantity` int DEFAULT NULL,
  `subtotal` decimal(38,0) DEFAULT NULL,
  `unit_price` decimal(38,0) DEFAULT NULL,
  `cart_id` varchar(255) DEFAULT NULL,
  `item_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cart_item_id`),
  KEY `FK_cart_item_item_id` (`item_id`),
  KEY `FK_cart_item_cart_id` (`cart_id`),
  CONSTRAINT `FK_cart_item_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`),
  CONSTRAINT `FK_cart_item_item_id` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`)
);

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
CREATE TABLE `delivery` (
  `delivery_id` varchar(255) NOT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delivered_date` timestamp DEFAULT NULL,
  `expected_date` date DEFAULT NULL,
  `shipping_address` longtext,
  `shipping_status` varchar(255) DEFAULT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`delivery_id`),
  KEY `FK_delivery_order_id` (`order_id`),
  CONSTRAINT `FK_delivery_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
);

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `item_id` varchar(255) NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `description` longtext,
  `image_url` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `price` decimal(38,0) DEFAULT NULL,
  `stock_quantity` int DEFAULT NULL,
  `updated_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`)
);

--
-- Table structure for table `orderdetails`
--

DROP TABLE IF EXISTS `orderdetails`;
CREATE TABLE `orderdetails` (
  `detail_id` varchar(255) NOT NULL,
  `price_per_item` decimal(38,0) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `item_id` varchar(255) DEFAULT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  KEY `FK_orderdetails_order_id` (`order_id`),
  KEY `FK_orderdetails_item_id` (`item_id`),
  CONSTRAINT `FK_orderdetails_item_id` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`),
  CONSTRAINT `FK_orderdetails_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
);

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` varchar(255) NOT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_method` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `total_amount` decimal(38,0) DEFAULT NULL,
  `promotion_id` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `FK_orders_user_id` (`user_id`),
  KEY `FK_orders_promotion_id` (`promotion_id`),
  CONSTRAINT `FK_orders_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`promotion_id`),
  CONSTRAINT `FK_orders_user_id` FOREIGN KEY (`user_id`) REFERENCES `userdata` (`user_id`)
);

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `payment_id` varchar(255) NOT NULL,
  `payment_date` timestamp DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `payment_status` varchar(255) DEFAULT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `FK_payment_order_id` (`order_id`),
  CONSTRAINT `FK_payment_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
);

--
-- Table structure for table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
CREATE TABLE `promotion` (
  `promotion_id` varchar(255) NOT NULL,
  `description` longtext,
  `discount_value` decimal(38,0) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `minimum_purchase` decimal(38,0) DEFAULT NULL,
  `promotion_code` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`promotion_id`)
);

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `report_id` varchar(255) NOT NULL,
  `description` longtext,
  `report_date` date DEFAULT NULL,
  `report_type` varchar(255) DEFAULT NULL,
  `total_sales` decimal(38,0) DEFAULT NULL,
  PRIMARY KEY (`report_id`)
);

--
-- Table structure for table `review_rating`
--

DROP TABLE IF EXISTS `review_rating`;
CREATE TABLE `review_rating` (
  `review_id` varchar(255) NOT NULL,
  `comment` longtext,
  `review_date` date DEFAULT NULL,
  `review_grade` int DEFAULT NULL,
  `item_id` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `FK_review_rating_item_id` (`item_id`),
  KEY `FK_review_rating_user_id` (`user_id`),
  CONSTRAINT `FK_review_rating_item_id` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`),
  CONSTRAINT `FK_review_rating_user_id` FOREIGN KEY (`user_id`) REFERENCES `userdata` (`user_id`)
);

--
-- Table structure for table `staffdata`
--

DROP TABLE IF EXISTS `staffdata`;
CREATE TABLE `staffdata` (
  `staff_id` varchar(255) NOT NULL,
  `address` longtext,
  `contact_number` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(255) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_id`)
);

--
-- Table structure for table `userdata`
--

DROP TABLE IF EXISTS `userdata`;
CREATE TABLE `userdata` (
  `user_id` varchar(255) NOT NULL,
  `address` longtext,
  `birth_date` date DEFAULT NULL,
  `contact_number` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `email` varchar(255) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
);

--
-- Table structure for table `userlogin`
--

DROP TABLE IF EXISTS `userlogin`;
CREATE TABLE `userlogin` (
  `login_id` varchar(255) NOT NULL,
  `answer` varchar(255) DEFAULT NULL,
  `challenge_question` varchar(255) DEFAULT NULL,
  `last_login` timestamp DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`login_id`),
  KEY `FK_userlogin_user_id` (`user_id`),
  CONSTRAINT `FK_userlogin_user_id` FOREIGN KEY (`user_id`) REFERENCES `userdata` (`user_id`)
);

-- Dump completed on 2025-04-17 17:06:46
