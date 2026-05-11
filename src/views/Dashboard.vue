<template>
  <div class="space-y-6">
    <!-- Welcome Section -->
    <div class="bg-blue-600 rounded-2xl p-6 lg:p-8 text-white shadow-md relative overflow-hidden">
      <div class="relative z-10">
        <h1 class="text-xl lg:text-2xl font-bold mb-1">สวัสดี, {{ authStore.user?.name }}!</h1>
        <p class="text-blue-100 text-sm opacity-90">ข้อมูลสรุปประจำวันที่ {{ currentDate }}</p>
      </div>
      <Smartphone class="absolute right-[-20px] bottom-[-20px] w-32 h-32 opacity-10 rotate-12" />
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 lg:gap-6">
      <div class="stat-card">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">สินค้าทั้งหมด</h3>
            <p class="text-2xl font-bold text-slate-800 mt-1">{{ stats.total }}</p>
          </div>
          <div class="icon-box bg-blue-50 text-blue-600">
            <Package class="w-5 h-5" />
          </div>
        </div>
      </div>

      <div class="stat-card">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">พร้อมขาย</h3>
            <p class="text-2xl font-bold text-emerald-600 mt-1">{{ stats.available }}</p>
          </div>
          <div class="icon-box bg-emerald-50 text-emerald-600">
            <CheckCircle class="w-5 h-5" />
          </div>
        </div>
      </div>

      <div class="stat-card">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">ขายแล้วเดือนนี้</h3>
            <p class="text-2xl font-bold text-amber-600 mt-1">{{ stats.sold }}</p>
          </div>
          <div class="icon-box bg-amber-50 text-amber-600">
            <ShoppingCart class="w-5 h-5" />
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="bg-white rounded-2xl shadow-sm border border-slate-200">
      <div class="p-5 border-b border-slate-100 flex items-center justify-between">
        <h3 class="text-sm font-bold text-slate-800">อัปเดตสต็อกล่าสุด</h3>
        <router-link to="/products" class="text-blue-600 text-xs font-bold hover:underline">ดูทั้งหมด</router-link>
      </div>
      <div class="p-2">
        <div v-for="i in 3" :key="i" class="flex items-center p-3 rounded-xl hover:bg-slate-50 transition">
          <div class="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center mr-4 flex-shrink-0">
            <Smartphone class="w-5 h-5 text-slate-400" />
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-bold text-slate-800 truncate">iPhone 15 Pro Max</p>
            <p class="text-[10px] text-slate-500">โดย พนักงาน • 2 นาทีที่แล้ว</p>
          </div>
          <div class="text-right ml-4">
            <p class="text-sm font-bold text-emerald-600">฿42,900</p>
            <p class="text-[10px] text-slate-400">สต็อกเข้า</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted, computed } from 'vue';
import axios from 'axios';
import { useAuthStore } from '../store/auth';
import { 
  Package, 
  CheckCircle, 
  ShoppingCart, 
  Smartphone 
} from 'lucide-vue-next';

const authStore = useAuthStore();
const stats = reactive({
  total: 0,
  available: 0,
  sold: 0
});

const currentDate = computed(() => {
  return new Date().toLocaleDateString('th-TH', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });
});

const fetchStats = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/products', {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    const products = response.data;
    stats.total = products.length;
    stats.available = products.filter(p => p.status === 'available').length;
    stats.sold = products.filter(p => p.status === 'sold').length;
  } catch (error) {
    console.error('Failed to fetch dashboard stats', error);
  }
};

onMounted(fetchStats);
</script>

<style scoped>
@reference "../style.css";

.stat-card {
  @apply bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md;
}
.icon-box {
  @apply w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0;
}
</style>
