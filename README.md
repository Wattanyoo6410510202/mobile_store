# Mobile Shop Management System (VIP Phone)

ระบบจัดการร้านขายมือถือครบวงจร รองรับการบันทึกข้อมูลสินค้า, ระบบ QR Code, รูปถ่ายสภาพเครื่อง และระบบออกใบรับประกัน

## 🚀 Getting Started

หลังจาก Clone โปรเจกต์นี้ลงเครื่อง ให้ทำตามขั้นตอนดังนี้:

### 1. ติดตั้ง Dependencies
ต้องติดตั้งทั้งฝั่ง Frontend และ Backend:

```bash
# ติดตั้งฝั่ง Frontend (Root directory)
npm install

# ติดตั้งฝั่ง Backend
cd backend
npm install
```

### 2. ตั้งค่า Environment Variables
ในโฟลเดอร์ `backend/` ให้สร้างไฟล์ชื่อ `.env` โดยคัดลอกค่าจาก `.env.example` (หากมี) หรือตั้งค่าดังนี้:

```text
PORT=5000
JWT_SECRET=your_secret_key_here
```

### 3. รันโปรเจกต์
รันคำสั่งนี้จากโฟลเดอร์ Root เพื่อเริ่มใช้งานพร้อมกันทั้ง Frontend และ Backend:

```bash
npm run dev
```

- **Frontend:** http://localhost:5174
- **Backend API:** http://localhost:5000

## 🛠 Tech Stack
- **Frontend:** Vue 3, Vite, Tailwind CSS, Lucide Icons
- **Backend:** Node.js, Express, Sequelize (SQLite)

---
*Last Updated: 2026-05-11*
