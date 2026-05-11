<template>
  <div class="min-h-screen bg-slate-50 font-sans">
    <!-- Navbar -->
    <nav class="sticky top-0 bg-white/80 backdrop-blur-md border-b border-slate-100 z-50">
      <div class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
        <h1 class="text-2xl font-black text-slate-900 tracking-tight">VIP<span class="text-blue-600">Phone</span></h1>
        <div class="hidden md:flex space-x-8 text-sm font-bold text-slate-600">
          <a href="#about" class="hover:text-blue-600 transition">เกี่ยวกับเรา</a>
          <a href="#warranty" class="hover:text-blue-600 transition">นโยบายประกัน</a>
          <a href="#contact" class="hover:text-blue-600 transition">ติดต่อ</a>
        </div>
        <router-link to="/login" class="px-5 py-2.5 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-slate-800 transition">
          เข้าสู่ระบบพนักงาน
        </router-link>
      </div>
    </nav>

    <!-- Hero Section -->
    <header class="relative bg-white pt-20 pb-32 overflow-hidden">
      <div class="max-w-4xl mx-auto text-center px-6 relative z-10">
        <span class="px-4 py-1.5 bg-blue-50 text-blue-600 text-[10px] font-bold uppercase tracking-widest rounded-full">เปิดให้บริการทุกวัน</span>
        <h2 class="text-5xl lg:text-7xl font-black text-slate-900 mt-6 leading-tight">มือถือสภาพนางฟ้า <br/><span class="text-blue-600">ราคามิตรภาพ</span></h2>
        <p class="text-lg text-slate-500 mt-8 max-w-2xl mx-auto">คัดสรรเครื่องเกรด A ผ่านการทดสอบคุณภาพทุกเครื่อง พร้อมประกันร้านที่เชื่อถือได้</p>
        <div class="mt-10 flex justify-center space-x-4">
          <a href="#contact" class="px-8 py-4 bg-blue-600 text-white font-bold rounded-2xl shadow-lg shadow-blue-200 hover:bg-blue-700 transition">สอบถามสินค้า</a>
        </div>
      </div>
      <!-- Decorative -->
      <div class="absolute bottom-0 left-0 w-full h-1/2 bg-gradient-to-t from-slate-50 to-transparent"></div>
    </header>

    <!-- Services -->
    <section id="about" class="py-20 max-w-6xl mx-auto px-6 grid md:grid-cols-3 gap-8">
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
        <div class="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center text-blue-600 mb-6">
          <CheckCircle class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-slate-800">เครื่องเกรด A</h3>
        <p class="text-sm text-slate-500 mt-2">ผ่านการตรวจสอบมากกว่า 20 จุด มั่นใจได้ในคุณภาพ</p>
      </div>
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
        <div class="w-12 h-12 bg-emerald-50 rounded-2xl flex items-center justify-center text-emerald-600 mb-6">
          <ShieldCheck class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-slate-800">ประกันยาวนาน</h3>
        <p class="text-sm text-slate-500 mt-2">อุ่นใจด้วยการรับประกันคุณภาพจากทางร้าน VIP Phone</p>
      </div>
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
        <div class="w-12 h-12 bg-indigo-50 rounded-2xl flex items-center justify-center text-indigo-600 mb-6">
          <Headphones class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-slate-800">ดูแลหลังการขาย</h3>
        <p class="text-sm text-slate-500 mt-2">ให้คำปรึกษาและแก้ไขปัญหาการใช้งานตลอดอายุประกัน</p>
      </div>
    </section>

    <!-- Warranty Footer -->
    <section id="warranty" class="py-20 bg-slate-900 text-white text-center">
      <div class="max-w-2xl mx-auto px-6">
        <h2 class="text-3xl font-bold mb-6">นโยบายการรับประกัน</h2>
        <p class="text-slate-400 text-sm">เราใส่ใจทุกรายละเอียด เครื่องทุกเครื่องได้รับใบรับประกันจากระบบมาตรฐาน VIP Phone เพื่อให้คุณมั่นใจว่าเครื่องที่คุณซื้อไป คือเครื่องที่ตรวจสอบแล้วว่าปลอดภัย 100%</p>
      </div>
    </section>

    <!-- Footer -->
    <footer id="contact" class="py-10 text-center text-slate-400 text-xs font-medium">
      <p>&copy; 2026 VIP Phone. All rights reserved.</p>
    </footer>
  </div>
</template>

<script setup>
import { CheckCircle, ShieldCheck, Headphones } from 'lucide-vue-next';
</script>
