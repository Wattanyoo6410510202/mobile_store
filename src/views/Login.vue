<template>
  <div class="min-h-screen bg-slate-900 flex items-center justify-center p-4 relative overflow-hidden font-sans">
    <!-- Background -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute top-0 left-0 w-64 h-64 bg-blue-600 rounded-full blur-[100px] opacity-10"></div>
    </div>

    <div class="max-w-sm w-full relative z-10">
      <div class="bg-white rounded-3xl shadow-xl p-8 lg:p-10">
        <div class="text-center mb-8">
          <div class="w-16 h-16 bg-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg shadow-blue-200">
            <Smartphone class="w-8 h-8 text-white" />
          </div>
          <h2 class="text-2xl font-bold text-slate-800">เข้าสู่ระบบ</h2>
          <p class="text-xs text-slate-400 mt-1 font-medium">ระบบจัดการร้าน VIP Phone</p>
        </div>

        <form @submit.prevent="handleLogin" class="space-y-4">
          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">อีเมลพนักงาน</label>
            <div class="relative group">
              <Mail class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 transition" />
              <input 
                v-model="email" 
                type="email" 
                class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-slate-800 placeholder:text-slate-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-sm font-medium"
                placeholder="name@company.com"
                required
              />
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">รหัสผ่าน</label>
            <div class="relative group">
              <Lock class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 transition" />
              <input 
                v-model="password" 
                type="password" 
                class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-slate-800 placeholder:text-slate-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-sm font-medium"
                placeholder="••••••••"
                required
              />
            </div>
          </div>

          <button 
            type="submit" 
            class="w-full bg-blue-600 text-white font-bold py-3.5 rounded-xl shadow-md hover:bg-blue-700 active:scale-95 transition-all text-sm flex items-center justify-center space-x-2 disabled:opacity-50"
            :disabled="loading"
          >
            <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />
            <span>{{ loading ? 'กำลังตรวจสอบ...' : 'ลงชื่อเข้าใช้งาน' }}</span>
          </button>

          <div v-if="error" class="bg-red-50 text-red-500 p-3 rounded-xl text-[10px] text-center font-bold border border-red-100">
            {{ error }}
          </div>
        </form>
      </div>

      <p class="text-center mt-6 text-slate-500 text-[10px] font-medium uppercase tracking-wider">
        ติดต่อผู้ดูแลระบบเพื่อขอสิทธิ์ใช้งาน
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '../store/auth';
import { useRouter } from 'vue-router';
import { Smartphone, Mail, Lock, Loader2 } from 'lucide-vue-next';

const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref('');
const authStore = useAuthStore();
const router = useRouter();

const handleLogin = async () => {
  loading.value = true;
  error.value = '';
  try {
    await authStore.login(email.value, password.value);
    router.push('/');
  } catch (err) {
    error.value = err.response?.data?.message || 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
  } finally {
    loading.value = false;
  }
};
</script>
