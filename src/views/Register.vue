<template>
  <div class="min-h-screen bg-[var(--gh-canvas-subtle)] flex items-center justify-center p-4 relative font-sans">
    <div class="max-w-sm w-full relative z-10">
      <div class="gh-surface gh-card p-8 lg:p-10">
        <div class="text-center mb-8">
          <div class="w-12 h-12 bg-blue-600 rounded-xl flex items-center justify-center mx-auto mb-4 shadow-sm">
            <Smartphone class="w-8 h-8 text-white" />
          </div>
          <h2 class="text-2xl font-bold text-slate-800">สมัครสมาชิก</h2>
          <p class="text-xs text-slate-500 mt-1 font-medium">เริ่มต้นใช้งาน VIP Phone</p>
        </div>

        <form @submit.prevent="handleRegister" class="space-y-4">
          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">ชื่อ-นามสกุล</label>
            <div class="relative">
              <User class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="name" type="text" class="gh-input pl-11" placeholder="ชื่อของคุณ" required />
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">อีเมล</label>
            <div class="relative">
              <Mail class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="email" type="email" class="gh-input pl-11" placeholder="your@email.com" required />
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">เบอร์โทรศัพท์</label>
            <div class="relative">
              <Smartphone class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="phone" type="text" class="gh-input pl-11" placeholder="08xxxxxxxx" required />
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">รหัสผ่าน</label>
            <div class="relative">
              <Lock class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input v-model="password" type="password" class="gh-input pl-11" placeholder="••••••••" required />
            </div>
          </div>

          <button 
            type="submit" 
            class="gh-btn gh-btn-primary w-full py-2.5 active:translate-y-px"
            :disabled="loading"
          >
            {{ loading ? 'กำลังสมัคร...' : 'สมัครสมาชิก' }}
          </button>

          <div v-if="error" class="bg-red-50 text-red-700 p-3 rounded-md text-[10px] text-center font-bold border border-red-200">
            {{ error }}
          </div>
        </form>

        <div class="mt-6 text-center">
          <p class="text-[10px] text-slate-500 font-semibold">
            มีบัญชีแล้ว? 
            <router-link to="/login" class="text-blue-600 hover:underline">เข้าสู่ระบบ</router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import axios from 'axios';
import { useRouter } from 'vue-router';
import { Smartphone, User, Lock, Mail } from 'lucide-vue-next';
import { getApiBasePath } from '../config/api';

const name = ref('');
const email = ref('');
const password = ref('');
const phone = ref(''); // เพิ่มตัวแปรเก็บเบอร์โทร
const loading = ref(false);
const error = ref('');
const router = useRouter();

const handleRegister = async () => {
  loading.value = true;
  error.value = '';
  try {
    await axios.post(`${getApiBasePath()}/auth/register`, {
      name: name.value,
      email: email.value,
      password: password.value,
      phone: phone.value, // ส่งเบอร์โทรไป
      role: 'customer' // เปลี่ยนเป็น customer
    });
    alert('สมัครสมาชิกสำเร็จ!');
    router.push('/login');
  } catch (err) {
    error.value = err.response?.data?.message || 'เกิดข้อผิดพลาดในการสมัครสมาชิก';
  } finally {
    loading.value = false;
  }
};
</script>
