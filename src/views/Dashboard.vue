<template>
  <div class="space-y-6">
    <!-- Welcome Section -->
    <div class="bg-red-600 rounded-2xl p-6 lg:p-8 text-white shadow-md relative overflow-hidden">
      <div class="relative z-10">
        <h1 class="text-xl lg:text-2xl font-bold mb-1">สวัสดี, {{ authStore.user?.name }}!</h1>
        <p class="text-red-100 text-sm opacity-90">ข้อมูลสรุปประจำวันที่ {{ currentDate }}</p>
      </div>
      <Smartphone class="absolute right-[-20px] bottom-[-20px] w-32 h-32 opacity-10 rotate-12" />
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4 lg:gap-6">
      <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md">
        <div class="flex flex-col items-center justify-center text-center">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-red-50 text-red-600 mb-3">
            <Package class="w-5 h-5" />
          </div>
          <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">ทั้งหมด</h3>
          <p class="text-2xl font-bold text-slate-800 mt-1">{{ stats.total }}</p>
        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md">
        <div class="flex flex-col items-center justify-center text-center">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-emerald-50 text-emerald-600 mb-3">
            <CheckCircle class="w-5 h-5" />
          </div>
          <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">พร้อมขาย</h3>
          <p class="text-2xl font-bold text-emerald-600 mt-1">{{ stats.available }}</p>
        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md">
        <div class="flex flex-col items-center justify-center text-center">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-amber-50 text-amber-600 mb-3">
            <ShoppingCart class="w-5 h-5" />
          </div>
          <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">ขายแล้ว</h3>
          <p class="text-2xl font-bold text-amber-600 mt-1">{{ stats.sold }}</p>
        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md">
        <div class="flex flex-col items-center justify-center text-center">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-orange-50 text-orange-500 mb-3">
            <Package class="w-5 h-5" />
          </div>
          <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">จองแล้ว</h3>
          <p class="text-2xl font-bold text-orange-500 mt-1">{{ stats.reserved }}</p>
        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md">
        <div class="flex flex-col items-center justify-center text-center">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-red-50 text-red-500 mb-3">
            <Package class="w-5 h-5" />
          </div>
          <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">ส่งซ่อม</h3>
          <p class="text-2xl font-bold text-red-500 mt-1">{{ stats.repair }}</p>
        </div>
      </div>

      <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md">
        <div class="flex flex-col items-center justify-center text-center">
          <div class="w-10 h-10 rounded-xl flex items-center justify-center bg-purple-50 text-purple-600 mb-3">
            <Package class="w-5 h-5" />
          </div>
          <h3 class="text-slate-500 text-[10px] font-bold uppercase tracking-wider">รอนำเข้า</h3>
          <p class="text-2xl font-bold text-purple-600 mt-1">{{ stats.import }}</p>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-2 sm:grid-cols-2 gap-4 lg:gap-6">
      <router-link to="/admin/users" class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md flex items-center gap-4 group">
        <div class="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 bg-indigo-50 text-indigo-600 group-hover:bg-indigo-600 group-hover:text-white transition-colors">
          <Users class="w-6 h-6" />
        </div>
        <div class="text-left">
          <h3 class="text-sm font-bold text-slate-800">จัดการผู้ใช้</h3>
          <p class="text-[10px] text-slate-400 font-medium">เพิ่ม ลบ หรือแก้ไขสิทธิ์การใช้งาน</p>
        </div>
      </router-link>

      <router-link to="/admin/reports" class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200 transition-all hover:shadow-md flex items-center gap-4 group">
        <div class="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 bg-rose-50 text-rose-600 group-hover:bg-rose-600 group-hover:text-white transition-colors">
          <FileBarChart class="w-6 h-6" />
        </div>
        <div class="text-left">
          <h3 class="text-sm font-bold text-slate-800">รายงาน</h3>
          <p class="text-[10px] text-slate-400 font-medium">สรุปยอดขายและข้อมูลสถิติต่างๆ</p>
        </div>
      </router-link>
    </div>

    <!-- Recent Activity -->
    <div class="bg-white rounded-2xl shadow-sm border border-slate-200">
      <div class="p-5 border-b border-slate-100 flex items-center justify-between">
        <h3 class="text-sm font-bold text-slate-800">อัปเดตสต็อกล่าสุด</h3>
        <router-link to="/admin/products" class="text-red-600 text-xs font-bold hover:underline">ดูทั้งหมด</router-link>
      </div>
      <div class="p-2">
        <div v-if="stats.recent.length === 0" class="p-8 text-center text-slate-400 text-xs">
          ไม่พบรายการอัปเดตล่าสุด
        </div>
        <div v-else class="divide-y divide-slate-50">
          <div v-for="product in stats.recent" :key="product.id" class="p-3 flex items-center justify-between hover:bg-slate-50 rounded-lg transition-colors">
            <div class="flex items-center space-x-3">
              <div class="w-8 h-8 rounded bg-slate-100 flex items-center justify-center text-slate-400">
                <Smartphone class="w-4 h-4" />
              </div>
              <div>
                <p class="text-xs font-bold text-slate-800">{{ product.brand }} {{ product.model }}</p>
                <p class="text-[10px] text-slate-400">{{ new Date(product.updatedAt).toLocaleDateString('th-TH') }}</p>
              </div>
            </div>
            <span :class="{
              'bg-emerald-50 text-emerald-600': product.status === 'available',
              'bg-slate-100 text-slate-500': product.status === 'sold',
              'bg-amber-50 text-amber-600': product.status === 'reserved',
              'bg-red-50 text-red-600': product.status === 'repair',
              'bg-violet-50 text-violet-600': product.status === 'import'
            }" class="text-[9px] font-bold px-2 py-0.5 rounded-full uppercase">
              {{ product.status === 'available' ? 'พร้อมขาย' : product.status === 'sold' ? 'ขายแล้ว' : product.status === 'reserved' ? 'จองแล้ว' : product.status === 'repair' ? 'ส่งซ่อม' : 'รอนำเข้า' }}
            </span>
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
import { getApiBasePath } from '../config/api';
import { 
  Package, 
  CheckCircle, 
  ShoppingCart, 
  Smartphone,
  Users,
  FileBarChart
} from 'lucide-vue-next';

const authStore = useAuthStore();
const stats = reactive({
  total: 0,
  available: 0,
  sold: 0,
  reserved: 0,
  repair: 0,
  import: 0,
  recent: []
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
    const response = await axios.get(`${getApiBasePath()}/products/stats/dashboard`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    stats.total = response.data.total;
    stats.available = response.data.available;
    stats.sold = response.data.sold;
    stats.reserved = response.data.reserved;
    stats.repair = response.data.repair;
    stats.import = response.data.import;
    stats.recent = response.data.recent || [];
  } catch (error) {
    console.error('Failed to fetch dashboard stats', error);
  }
};

onMounted(fetchStats);
</script>
