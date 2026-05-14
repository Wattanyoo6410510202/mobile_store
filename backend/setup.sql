-- Create Database
CREATE DATABASE IF NOT EXISTS `phone_store` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `phone_store`;

-- Table structure for Users
CREATE TABLE IF NOT EXISTS `Users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff') DEFAULT 'staff',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table structure for Products
CREATE TABLE IF NOT EXISTS `Products` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `imei1` varchar(255) DEFAULT NULL,
  `imei2` varchar(255) DEFAULT NULL,
  `serialNumber` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `storage` varchar(255) DEFAULT NULL,
  `batteryHealth` int(11) DEFAULT NULL,
  `purchasePrice` decimal(10,2) DEFAULT NULL,
  `sellPrice` decimal(10,2) DEFAULT NULL,
  `warrantyStartDate` datetime DEFAULT NULL,
  `saleDate` datetime DEFAULT NULL,
  `status` enum('available','sold','reserved','repair') DEFAULT 'available',
  `condition` enum('new','used') DEFAULT 'used',
  `hasWarranty` tinyint(1) DEFAULT '1',
  `warrantyType` enum('manufacturer','shop') DEFAULT 'shop',
  `warrantyEndDate` datetime DEFAULT NULL,
  `isCloudLocked` tinyint(1) DEFAULT '0',
  `isResetReady` tinyint(1) DEFAULT '1',
  `isMdmLocked` tinyint(1) DEFAULT '0',
  `isPromoAttached` tinyint(1) DEFAULT '0',
  `isGenuineParts` tinyint(1) DEFAULT '1',
  `testTouchscreen` tinyint(1) DEFAULT '1',
  `testSpeaker` tinyint(1) DEFAULT '1',
  `testMic` tinyint(1) DEFAULT '1',
  `testWifi` tinyint(1) DEFAULT '1',
  `testBluetooth` tinyint(1) DEFAULT '1',
  `testCamera` tinyint(1) DEFAULT '1',
  `testFaceId` tinyint(1) DEFAULT '1',
  `testFingerprint` tinyint(1) DEFAULT '1',
  `testCharging` tinyint(1) DEFAULT '1',
  `testSimCard` tinyint(1) DEFAULT '1',
  `conditionNote` text,
  `thumbnail` varchar(255) DEFAULT NULL,
  `vdo360` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `barcode` (`barcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table structure for ProductImages
CREATE TABLE IF NOT EXISTS `ProductImages` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `productId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `type` varchar(255) NOT NULL,
  `imageUrl` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `productId` (`productId`),
  CONSTRAINT `productimages_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `Products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table structure for SellerInfos
CREATE TABLE IF NOT EXISTS `SellerInfos` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `productId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `idCardNumber` varchar(255) DEFAULT NULL,
  `idCardImageUrl` varchar(255) DEFAULT NULL,
  `sellerWithPhoneImageUrl` varchar(255) DEFAULT NULL,
  `signatureUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `productId` (`productId`),
  CONSTRAINT `sellerinfos_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `Products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table structure for Settings
CREATE TABLE IF NOT EXISTS `Settings` (
  `id` int(11) NOT NULL,
  `storeName` varchar(255) DEFAULT 'VIP Phone',
  `storePhone` varchar(255) DEFAULT NULL,
  `warrantyDays` int(11) DEFAULT '30',
  `termsAndConditions` text,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table structure for SoftwareTests
CREATE TABLE IF NOT EXISTS `SoftwareTests` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `productId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `testData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `testedAt` datetime DEFAULT NULL,
  `testerName` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `productId` (`productId`),
  CONSTRAINT `softwaretests_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `Products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed Admin User (Password: 1234)
-- Note: The password hash below is for '1234' using bcrypt cost 10
INSERT INTO `Users` (`id`, `name`, `email`, `password`, `role`, `createdAt`, `updatedAt`) 
VALUES (UUID(), 'Administrator', 'admin', '$2b$10$FWbdWvpwXO9pjD.BUONwa./4sSS4ZXYcc3wDM./TTSTax9knbDVay', 'admin', NOW(), NOW())
ON DUPLICATE KEY UPDATE `email`=`email`;

-- Seed Default Settings
INSERT INTO `Settings` (`id`, `storeName`, `warrantyDays`, `createdAt`, `updatedAt`)
VALUES (1, 'VIP Phone', 30, NOW(), NOW())
ON DUPLICATE KEY UPDATE `id`=`id`;
