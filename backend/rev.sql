-- ระบบจองสินค้า (Reservation System)
-- ตารางเก็บข้อมูลลูกค้าแยกต่างหาก
CREATE TABLE IF NOT EXISTS `customers` (
    `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(20) NOT NULL,
    `email` VARCHAR(255),
    `address` TEXT,
    `createdAt` DATETIME NOT NULL,
    `updatedAt` DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ตารางเก็บรายการจอง (ปรับปรุงให้ใช้ customer_id)
CREATE TABLE IF NOT EXISTS `reservations` (
    `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `product_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `customer_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `user_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL, 
    
    `status` ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    `deposit_amount` DECIMAL(10, 2) DEFAULT 0.00,
    `reservation_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `reservation_expires_at` DATETIME,
    `notes` TEXT,
    
    `createdAt` DATETIME NOT NULL,
    `updatedAt` DATETIME NOT NULL,
    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index สำหรับประสิทธิภาพ
CREATE INDEX idx_res_status ON `reservations`(`status`);
CREATE INDEX idx_res_product_id ON `reservations`(`product_id`);
CREATE INDEX idx_res_customer_id ON `reservations`(`customer_id`);

-- บันทึกประวัติการเปลี่ยนสถานะการจอง (Audit Log)
CREATE TABLE IF NOT EXISTS `reservation_logs` (
    `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `reservation_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `changed_by` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `old_status` VARCHAR(50),
    `new_status` VARCHAR(50),
    `change_reason` TEXT,
    `createdAt` DATETIME NOT NULL,
    `updatedAt` DATETIME NOT NULL,
    
    PRIMARY KEY (`id`),
    FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`changed_by`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
