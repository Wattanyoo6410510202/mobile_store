-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2026 at 06:52 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `phone_store`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `phone`, `email`, `address`, `createdAt`, `updatedAt`) VALUES
('e5e3a9d9-f520-4e7f-b14a-95094375667f', 'สมชัย ใจดี', '08551616216', 'creeda7255@gmail.com', NULL, '2026-05-14 21:27:39', '2026-05-14 21:27:39'),
('f5d9b8a5-7e96-4474-b6aa-f403b0032a03', 'วทัญญุ ต้นจาน', '0993134923', 'creeda725@gmail.com', NULL, '2026-05-14 20:14:24', '2026-05-14 20:14:24');

-- --------------------------------------------------------

--
-- Table structure for table `productimages`
--

CREATE TABLE `productimages` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `productId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `type` varchar(255) NOT NULL,
  `imageUrl` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
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
  `status` enum('available','sold','reserved','repair','import') DEFAULT 'available',
  `condition` enum('new','used') DEFAULT 'used',
  `hasWarranty` tinyint(1) DEFAULT 1,
  `warrantyType` enum('manufacturer','shop') DEFAULT 'shop',
  `warrantyEndDate` datetime DEFAULT NULL,
  `isCloudLocked` tinyint(1) DEFAULT 0,
  `isResetReady` tinyint(1) DEFAULT 1,
  `isMdmLocked` tinyint(1) DEFAULT 0,
  `isPromoAttached` tinyint(1) DEFAULT 0,
  `isGenuineParts` tinyint(1) DEFAULT 1,
  `testTouchscreen` tinyint(1) DEFAULT 1,
  `testSpeaker` tinyint(1) DEFAULT 1,
  `testMic` tinyint(1) DEFAULT 1,
  `testWifi` tinyint(1) DEFAULT 1,
  `testBluetooth` tinyint(1) DEFAULT 1,
  `testCamera` tinyint(1) DEFAULT 1,
  `testFaceId` tinyint(1) DEFAULT 1,
  `testFingerprint` tinyint(1) DEFAULT 1,
  `testCharging` tinyint(1) DEFAULT 1,
  `testSimCard` tinyint(1) DEFAULT 1,
  `conditionNote` text DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `vdo360` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `barcode`, `imei1`, `imei2`, `serialNumber`, `brand`, `model`, `color`, `storage`, `batteryHealth`, `purchasePrice`, `sellPrice`, `warrantyStartDate`, `saleDate`, `status`, `condition`, `hasWarranty`, `warrantyType`, `warrantyEndDate`, `isCloudLocked`, `isResetReady`, `isMdmLocked`, `isPromoAttached`, `isGenuineParts`, `testTouchscreen`, `testSpeaker`, `testMic`, `testWifi`, `testBluetooth`, `testCamera`, `testFaceId`, `testFingerprint`, `testCharging`, `testSimCard`, `conditionNote`, `thumbnail`, `vdo360`, `createdAt`, `updatedAt`) VALUES
('1af6640e-4e36-441b-95dc-31a972c915eb', NULL, '358901234567891', NULL, 'SNR2PYG8', 'Apple', 'iPhone 15 Pro Max นะจ่ะ', 'Natural Titanium', '256GB', 100, 35000.00, 42900.00, NULL, '2026-05-14 10:39:49', 'available', 'used', 1, 'shop', '2026-06-13 10:12:17', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:17', '2026-05-15 21:05:57'),
('3eb67948-3b46-460f-86bc-0aeb2b08c030', NULL, '358901234567894', NULL, 'SNA73IUE', 'Apple', 'iPhone 13', 'Starlight', '128GB', 88, 14000.00, 17900.00, NULL, NULL, 'repair', 'used', 1, 'shop', '2026-06-13 10:12:18', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:18', '2026-05-14 21:26:01'),
('501ae12c-ef5b-412f-a6b0-b03abaace397', NULL, '358901234567895', NULL, 'SNHA79B', 'Samsung', 'Galaxy Z Fold 5', 'Phantom Black', '256GB', 98, 28000.00, 34900.00, NULL, NULL, 'repair', 'used', 1, 'shop', '2026-06-13 10:12:18', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:18', '2026-05-14 21:26:03'),
('9400a3b3-365c-4976-84d0-aa7cc0264719', NULL, '358901234567893', NULL, 'SNY5XZJ', 'Samsung', 'Galaxy S24 Ultra', 'Titanium Gray', '512GB', 100, 32000.00, 38500.00, NULL, '2026-05-15 21:21:10', 'sold', 'used', 1, 'shop', '2026-06-13 10:12:18', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:18', '2026-05-15 21:21:10'),
('9e90cbd7-a094-4691-9952-b214e9875b98', NULL, '358901234567897', NULL, 'SNO11K7H', 'Google', 'Pixel 8 Pro', 'Obsidian', '128GB', 99, 19000.00, 23900.00, NULL, '2026-05-15 00:54:16', 'sold', 'used', 1, 'shop', '2026-06-13 10:12:18', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:18', '2026-05-15 00:54:16'),
('e7672733-39a2-4d13-96cd-ec9734ee4d80', NULL, '358901234567898', NULL, 'SNNMBP5I', 'Apple', 'iPhone 12 Pro', 'Pacific Blue', '256GB', 85, 12000.00, 15500.00, NULL, NULL, 'available', 'used', 1, 'shop', '2026-06-13 10:12:18', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('f22b97e6-93d1-4fed-8790-66b1fa4f57fb', NULL, '358901234567892', NULL, 'SNO64VNO', 'Apple', 'iPhone 14 Pro', 'Deep Purple', '128GB', 92, 25000.00, 29900.00, NULL, '2026-05-15 21:21:22', 'available', 'used', 1, 'shop', '2026-06-13 10:12:17', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:17', '2026-05-15 21:45:06'),
('fdd24061-72b1-4075-8f10-9e9b40cbcfbb', NULL, '358901234567896', NULL, 'SNVDUYZO', 'Apple', 'iPhone 15', 'Pink', '128GB', 100, 22000.00, 26500.00, NULL, NULL, 'available', 'used', 1, 'shop', '2026-06-13 10:12:18', 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '/uploads/products/default.jpg', NULL, '2026-05-14 10:12:18', '2026-05-15 21:50:45');

-- --------------------------------------------------------

--
-- Table structure for table `purchasequotations`
--

CREATE TABLE `purchasequotations` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `requester_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`items`)),
  `total_amount` decimal(12,2) DEFAULT 0.00,
  `status` enum('pending','approved','rejected','paid','completed') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `payment_slip` varchar(255) DEFAULT NULL,
  `receipt_file` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `customer_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `status` enum('pending','confirmed','cancelled','completed') DEFAULT 'pending',
  `deposit_amount` decimal(10,2) DEFAULT 0.00,
  `reservation_date` datetime DEFAULT NULL,
  `reservation_expires_at` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `attachment_file` varchar(255) DEFAULT NULL COMMENT 'ชื่อไฟล์หรือ path เอกสารแนบ',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `slip_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `product_id`, `customer_id`, `user_id`, `status`, `deposit_amount`, `reservation_date`, `reservation_expires_at`, `notes`, `attachment_file`, `createdAt`, `updatedAt`, `slip_image`) VALUES
('0bea93f6-4c98-4703-a95e-a02dfa88be19', 'f22b97e6-93d1-4fed-8790-66b1fa4f57fb', 'f5d9b8a5-7e96-4474-b6aa-f403b0032a03', '21080a7f-52bf-4ca6-80ef-c842d55ba42a', 'confirmed', 0.00, '2026-05-15 22:01:33', NULL, NULL, NULL, '2026-05-15 22:01:33', '2026-05-15 22:01:37', NULL),
('bbca2a97-47c3-421e-9b28-6467e71efb90', '1af6640e-4e36-441b-95dc-31a972c915eb', 'f5d9b8a5-7e96-4474-b6aa-f403b0032a03', '21080a7f-52bf-4ca6-80ef-c842d55ba42a', 'pending', 0.00, '2026-05-16 11:23:18', NULL, NULL, NULL, '2026-05-16 11:23:18', '2026-05-16 11:23:18', NULL),
('bef1cc92-abee-400d-8e8d-48c671325077', 'f22b97e6-93d1-4fed-8790-66b1fa4f57fb', 'f5d9b8a5-7e96-4474-b6aa-f403b0032a03', '21080a7f-52bf-4ca6-80ef-c842d55ba42a', 'confirmed', 0.00, '2026-05-15 20:09:29', NULL, NULL, NULL, '2026-05-15 20:09:29', '2026-05-15 22:01:21', NULL),
('d95d5f8d-be1b-49e1-ab7c-82758b0382c1', 'e7672733-39a2-4d13-96cd-ec9734ee4d80', 'f5d9b8a5-7e96-4474-b6aa-f403b0032a03', '21080a7f-52bf-4ca6-80ef-c842d55ba42a', 'confirmed', 0.00, '2026-05-15 20:08:45', NULL, NULL, NULL, '2026-05-15 20:08:45', '2026-05-15 22:01:23', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reservation_logs`
--

CREATE TABLE `reservation_logs` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `reservation_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `changed_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `change_reason` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sellerinfos`
--

CREATE TABLE `sellerinfos` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `productId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `idCardNumber` varchar(255) DEFAULT NULL,
  `idCardImageUrl` varchar(255) DEFAULT NULL,
  `sellerWithPhoneImageUrl` varchar(255) DEFAULT NULL,
  `signatureUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sellerinfos`
--

INSERT INTO `sellerinfos` (`id`, `productId`, `fullName`, `phoneNumber`, `idCardNumber`, `idCardImageUrl`, `sellerWithPhoneImageUrl`, `signatureUrl`, `createdAt`, `updatedAt`) VALUES
('01286077-9159-4103-a209-82a168fa4e57', 'f22b97e6-93d1-4fed-8790-66b1fa4f57fb', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('1de601fd-ac94-4c0c-bb69-f4f71720234e', 'fdd24061-72b1-4075-8f10-9e9b40cbcfbb', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('30e87811-32d4-4132-8c51-48b6074fa4e1', '1af6640e-4e36-441b-95dc-31a972c915eb', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:17', '2026-05-14 10:12:17'),
('719e5c71-7db8-401d-b1f4-45f454fdb462', 'e7672733-39a2-4d13-96cd-ec9734ee4d80', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('9feb015d-706b-4dc9-af9c-d38d29e17ccd', '3eb67948-3b46-460f-86bc-0aeb2b08c030', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('abdb885a-cc89-4e9b-b7d3-f2eacb29b01b', '9e90cbd7-a094-4691-9952-b214e9875b98', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('b8dfafc5-fedc-4e08-b888-0ba56e912caa', '9400a3b3-365c-4976-84d0-aa7cc0264719', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18'),
('ba48bfa1-2b10-4c77-9dd9-c042733172b1', '501ae12c-ef5b-412f-a6b0-b03abaace397', 'คุณสมชาย ใจดี', '0812345678', NULL, NULL, NULL, NULL, '2026-05-14 10:12:18', '2026-05-14 10:12:18');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `storeName` varchar(255) DEFAULT 'VIP Phone',
  `storePhone` varchar(255) DEFAULT NULL,
  `warrantyDays` int(11) DEFAULT 30,
  `termsAndConditions` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `storeName`, `storePhone`, `warrantyDays`, `termsAndConditions`, `createdAt`, `updatedAt`) VALUES
(1, 'VIP Phone', NULL, 30, NULL, '2026-05-14 09:45:01', '2026-05-14 09:45:01');

-- --------------------------------------------------------

--
-- Table structure for table `softwaretests`
--

CREATE TABLE `softwaretests` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `productId` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `testData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`testData`)),
  `testedAt` datetime DEFAULT NULL,
  `testerName` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff') DEFAULT 'staff',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `createdAt`, `updatedAt`) VALUES
('21080a7f-52bf-4ca6-80ef-c842d55ba42a', 'วทัญญุ ต้นจาน', 'creeda725@gmail.com', '$2b$10$Dbg/Hc8Ci0BCmBTDRJVHHeaCQK2ZUgcA.G1oUrTAI3MH9H52uLUGa', '', '2026-05-14 20:14:24', '2026-05-14 20:14:24'),
('8eba1691-28f2-42b1-83f5-0b6ab5e420e3', 'สมชัย ใจดี', 'creeda7255@gmail.com', '$2b$10$HpaXIs842mkWhK4guOVqLew8Mknfj4qFOry2XotLIhjJ8w7B7kDIG', '', '2026-05-14 21:27:38', '2026-05-14 21:27:38'),
('e76275db-4f3e-11f1-8d4b-d017c213c99a', 'Administrator', 'admin', '$2y$10$WZgSGG3t8R9LecX9BEnTbe.PNbYJAAeEzjna0XeRkvQ.sNZlHOR0S', 'admin', '2026-05-14 09:45:01', '2026-05-14 09:45:01');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cart_user` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD UNIQUE KEY `phone_2` (`phone`),
  ADD UNIQUE KEY `phone_3` (`phone`),
  ADD UNIQUE KEY `phone_4` (`phone`),
  ADD UNIQUE KEY `phone_5` (`phone`),
  ADD UNIQUE KEY `phone_6` (`phone`),
  ADD UNIQUE KEY `phone_7` (`phone`),
  ADD UNIQUE KEY `phone_8` (`phone`),
  ADD UNIQUE KEY `phone_9` (`phone`),
  ADD UNIQUE KEY `phone_10` (`phone`),
  ADD UNIQUE KEY `phone_11` (`phone`),
  ADD UNIQUE KEY `phone_12` (`phone`),
  ADD UNIQUE KEY `phone_13` (`phone`),
  ADD UNIQUE KEY `phone_14` (`phone`),
  ADD UNIQUE KEY `phone_15` (`phone`),
  ADD UNIQUE KEY `phone_16` (`phone`),
  ADD UNIQUE KEY `phone_17` (`phone`),
  ADD UNIQUE KEY `phone_18` (`phone`),
  ADD UNIQUE KEY `phone_19` (`phone`),
  ADD UNIQUE KEY `phone_20` (`phone`),
  ADD UNIQUE KEY `phone_21` (`phone`),
  ADD UNIQUE KEY `phone_22` (`phone`),
  ADD UNIQUE KEY `phone_23` (`phone`),
  ADD UNIQUE KEY `phone_24` (`phone`),
  ADD UNIQUE KEY `phone_25` (`phone`),
  ADD UNIQUE KEY `phone_26` (`phone`),
  ADD UNIQUE KEY `phone_27` (`phone`),
  ADD UNIQUE KEY `phone_28` (`phone`),
  ADD UNIQUE KEY `phone_29` (`phone`),
  ADD UNIQUE KEY `phone_30` (`phone`),
  ADD UNIQUE KEY `phone_31` (`phone`),
  ADD UNIQUE KEY `phone_32` (`phone`),
  ADD UNIQUE KEY `phone_33` (`phone`),
  ADD UNIQUE KEY `phone_34` (`phone`),
  ADD UNIQUE KEY `phone_35` (`phone`),
  ADD UNIQUE KEY `phone_36` (`phone`),
  ADD UNIQUE KEY `phone_37` (`phone`),
  ADD UNIQUE KEY `phone_38` (`phone`),
  ADD UNIQUE KEY `phone_39` (`phone`),
  ADD UNIQUE KEY `phone_40` (`phone`),
  ADD UNIQUE KEY `phone_41` (`phone`),
  ADD UNIQUE KEY `phone_42` (`phone`),
  ADD UNIQUE KEY `phone_43` (`phone`);

--
-- Indexes for table `productimages`
--
ALTER TABLE `productimages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barcode` (`barcode`),
  ADD UNIQUE KEY `barcode_2` (`barcode`),
  ADD UNIQUE KEY `barcode_3` (`barcode`),
  ADD UNIQUE KEY `barcode_4` (`barcode`),
  ADD UNIQUE KEY `barcode_5` (`barcode`),
  ADD UNIQUE KEY `barcode_6` (`barcode`),
  ADD UNIQUE KEY `barcode_7` (`barcode`),
  ADD UNIQUE KEY `barcode_8` (`barcode`),
  ADD UNIQUE KEY `barcode_9` (`barcode`),
  ADD UNIQUE KEY `barcode_10` (`barcode`),
  ADD UNIQUE KEY `barcode_11` (`barcode`),
  ADD UNIQUE KEY `barcode_12` (`barcode`),
  ADD UNIQUE KEY `barcode_13` (`barcode`),
  ADD UNIQUE KEY `barcode_14` (`barcode`),
  ADD UNIQUE KEY `barcode_15` (`barcode`),
  ADD UNIQUE KEY `barcode_16` (`barcode`),
  ADD UNIQUE KEY `barcode_17` (`barcode`),
  ADD UNIQUE KEY `barcode_18` (`barcode`),
  ADD UNIQUE KEY `barcode_19` (`barcode`),
  ADD UNIQUE KEY `barcode_20` (`barcode`),
  ADD UNIQUE KEY `barcode_21` (`barcode`),
  ADD UNIQUE KEY `barcode_22` (`barcode`),
  ADD UNIQUE KEY `barcode_23` (`barcode`),
  ADD UNIQUE KEY `barcode_24` (`barcode`),
  ADD UNIQUE KEY `barcode_25` (`barcode`),
  ADD UNIQUE KEY `barcode_26` (`barcode`),
  ADD UNIQUE KEY `barcode_27` (`barcode`),
  ADD UNIQUE KEY `barcode_28` (`barcode`),
  ADD UNIQUE KEY `barcode_29` (`barcode`),
  ADD UNIQUE KEY `barcode_30` (`barcode`),
  ADD UNIQUE KEY `barcode_31` (`barcode`),
  ADD UNIQUE KEY `barcode_32` (`barcode`),
  ADD UNIQUE KEY `barcode_33` (`barcode`),
  ADD UNIQUE KEY `barcode_34` (`barcode`),
  ADD UNIQUE KEY `barcode_35` (`barcode`),
  ADD UNIQUE KEY `barcode_36` (`barcode`),
  ADD UNIQUE KEY `barcode_37` (`barcode`),
  ADD UNIQUE KEY `barcode_38` (`barcode`),
  ADD UNIQUE KEY `barcode_39` (`barcode`),
  ADD UNIQUE KEY `barcode_40` (`barcode`),
  ADD UNIQUE KEY `barcode_41` (`barcode`),
  ADD UNIQUE KEY `barcode_42` (`barcode`),
  ADD UNIQUE KEY `barcode_43` (`barcode`),
  ADD UNIQUE KEY `barcode_44` (`barcode`),
  ADD UNIQUE KEY `barcode_45` (`barcode`),
  ADD UNIQUE KEY `barcode_46` (`barcode`),
  ADD UNIQUE KEY `barcode_47` (`barcode`),
  ADD UNIQUE KEY `barcode_48` (`barcode`),
  ADD UNIQUE KEY `barcode_49` (`barcode`),
  ADD UNIQUE KEY `barcode_50` (`barcode`),
  ADD UNIQUE KEY `barcode_51` (`barcode`),
  ADD UNIQUE KEY `barcode_52` (`barcode`),
  ADD UNIQUE KEY `barcode_53` (`barcode`),
  ADD UNIQUE KEY `barcode_54` (`barcode`),
  ADD UNIQUE KEY `barcode_55` (`barcode`),
  ADD UNIQUE KEY `barcode_56` (`barcode`),
  ADD UNIQUE KEY `barcode_57` (`barcode`),
  ADD UNIQUE KEY `barcode_58` (`barcode`),
  ADD UNIQUE KEY `barcode_59` (`barcode`),
  ADD UNIQUE KEY `barcode_60` (`barcode`),
  ADD UNIQUE KEY `barcode_61` (`barcode`),
  ADD UNIQUE KEY `barcode_62` (`barcode`),
  ADD UNIQUE KEY `barcode_63` (`barcode`);

--
-- Indexes for table `purchasequotations`
--
ALTER TABLE `purchasequotations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `requester_id` (`requester_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_res_status` (`status`),
  ADD KEY `idx_res_product_id` (`product_id`),
  ADD KEY `idx_res_customer_id` (`customer_id`);

--
-- Indexes for table `reservation_logs`
--
ALTER TABLE `reservation_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`),
  ADD KEY `changed_by` (`changed_by`);

--
-- Indexes for table `sellerinfos`
--
ALTER TABLE `sellerinfos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `softwaretests`
--
ALTER TABLE `softwaretests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_10` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_11` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_12` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_13` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_14` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_15` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_16` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_17` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_18` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_19` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_20` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_21` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_22` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_23` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_24` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_25` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_26` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_27` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_28` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_29` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_3` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_30` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_31` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_32` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_33` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_34` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_4` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_5` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_6` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_7` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_8` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `carts_ibfk_9` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `productimages`
--
ALTER TABLE `productimages`
  ADD CONSTRAINT `productimages_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_10` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_11` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_12` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_13` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_14` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_15` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_16` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_17` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_18` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_19` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_20` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_21` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_22` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_23` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_24` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_25` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_26` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_27` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_28` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_29` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_3` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_30` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_31` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_32` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_33` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_34` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_35` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_36` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_37` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_38` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_39` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_4` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_40` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_41` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_42` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_43` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_44` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_45` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_46` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_47` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_48` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_49` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_5` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_50` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_51` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_52` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_53` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_54` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_55` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_56` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_57` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_58` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_59` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_6` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_60` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_7` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_8` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productimages_ibfk_9` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `purchasequotations`
--
ALTER TABLE `purchasequotations`
  ADD CONSTRAINT `purchasequotations_ibfk_1` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_10` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_11` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_12` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_13` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_14` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_15` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_16` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_17` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_18` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_19` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_20` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_21` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_22` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_23` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_24` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_25` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_26` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_27` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_28` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_29` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_30` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_31` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_32` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_33` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_34` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_35` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_36` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_37` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_38` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_39` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_40` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_41` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_42` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_43` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_44` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_45` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_46` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_47` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_5` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_6` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_7` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_8` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_9` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `reservation_logs`
--
ALTER TABLE `reservation_logs`
  ADD CONSTRAINT `reservation_logs_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservation_logs_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sellerinfos`
--
ALTER TABLE `sellerinfos`
  ADD CONSTRAINT `sellerinfos_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_10` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_11` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_12` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_13` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_14` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_15` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_16` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_17` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_18` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_19` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_20` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_21` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_22` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_23` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_24` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_25` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_26` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_27` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_28` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_29` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_3` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_30` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_31` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_32` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_33` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_34` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_35` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_36` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_37` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_38` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_39` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_4` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_40` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_41` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_42` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_43` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_44` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_45` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_46` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_47` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_48` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_49` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_5` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_50` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_51` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_52` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_53` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_54` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_55` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_56` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_57` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_58` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_59` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_6` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_7` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_8` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sellerinfos_ibfk_9` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `softwaretests`
--
ALTER TABLE `softwaretests`
  ADD CONSTRAINT `softwaretests_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_10` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_11` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_12` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_13` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_14` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_15` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_16` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_17` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_18` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_19` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_20` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_21` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_22` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_23` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_24` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_25` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_26` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_27` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_28` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_29` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_3` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_30` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_31` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_32` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_33` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_34` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_35` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_36` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_37` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_38` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_39` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_4` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_40` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_41` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_42` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_43` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_44` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_45` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_46` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_47` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_48` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_49` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_5` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_50` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_51` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_52` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_53` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_54` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_55` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_56` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_6` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_7` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_8` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwaretests_ibfk_9` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
