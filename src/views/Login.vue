<template>
  <div class="min-h-screen bg-[var(--gh-canvas-subtle)] flex items-center justify-center p-4 relative font-sans">

    <div class="max-w-sm w-full relative z-10">
      <div class="gh-surface gh-card p-8 lg:p-10">
        <div class="text-center mb-8">
          <div class="w-12 h-12 bg-[var(--gh-accent-emphasis)] rounded-xl flex items-center justify-center mx-auto mb-4 shadow-sm">
            <Smartphone class="w-8 h-8 text-white" />
          </div>
          <h2 class="text-2xl font-bold text-slate-800">เข้าสู่ระบบ</h2>
          <p class="text-xs text-slate-500 mt-1 font-medium">ระบบจัดการร้าน VIP Phone</p>
        </div>

        <form @submit.prevent="handleLogin" class="space-y-4">
          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">ชื่อผู้ใช้ หรือ อีเมล</label>
            <div class="relative group">
              <User class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 transition" />
              <input 
                v-model="email" 
                type="text" 
                class="gh-input pl-11"
                placeholder="Username or email"
                required
              />
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">รหัสผ่าน</label>
            <div class="relative group">
              <Lock class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 transition" />
              <input 
                v-model="password" 
                type="password" 
                class="gh-input pl-11"
                placeholder="••••••••"
                required
              />
            </div>
          </div>

          <button 
            type="submit" 
            class="gh-btn gh-btn-primary w-full py-2.5 active:translate-y-px disabled:opacity-50"
            :disabled="loading"
          >
            <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />
            <span>{{ loading ? 'กำลังตรวจสอบ...' : 'ลงชื่อเข้าใช้งาน' }}</span>
          </button>

          <div v-if="error" class="bg-red-50 text-red-700 p-3 rounded-md text-[10px] text-center font-bold border" :style="{ borderColor: 'var(--gh-border-default)' }">
            {{ error }}
          </div>
        </form>
      </div>

      <p class="text-center mt-6 text-slate-500 text-[10px] font-semibold uppercase tracking-wider">
        ติดต่อผู้ดูแลระบบเพื่อขอสิทธิ์ใช้งาน
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useAuthStore } from '../store/auth';
import { useRouter } from 'vue-router';
import { Smartphone, User, Lock, Loader2 } from 'lucide-vue-next';

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
