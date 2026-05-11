<template>
  <div class="flex h-screen bg-slate-50 font-sans text-slate-900">
    <!-- Mobile Menu Backdrop -->
    <div v-if="isMobileMenuOpen" @click="isMobileMenuOpen = false" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-30 lg:hidden"></div>

    <!-- Sidebar -->
    <aside 
      :class="[
        'fixed inset-y-0 left-0 w-64 bg-[#0f172a] text-slate-300 flex flex-col z-40 transition-transform duration-300 lg:relative lg:translate-x-0',
        isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
      ]"
    >
      <div class="p-6 flex items-center space-x-3 border-b border-slate-800">
        <div class="bg-blue-600 p-1.5 rounded-lg shadow-md">
          <Smartphone class="w-5 h-5 text-white" />
        </div>
        <span class="text-lg font-bold tracking-tight text-white">VIP Phone <span class="text-blue-500 text-sm">v1</span></span>
      </div>

      <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest mb-3 px-2">เมนูหลัก</p>
        
        <router-link to="/admin" exact-active-class="active" @click="isMobileMenuOpen = false" class="nav-item group">
          <LayoutDashboard class="w-4 h-4" />
          <span class="text-sm">แดชบอร์ด</span>
        </router-link>

        <router-link to="/admin/products" @click="isMobileMenuOpen = false" class="nav-item group" active-class="active">
          <Package class="w-4 h-4" />
          <span class="text-sm">รายการสินค้า</span>
        </router-link>

        <router-link to="/admin/products/add" @click="isMobileMenuOpen = false" class="nav-item group" active-class="active">
          <PlusCircle class="w-4 h-4" />
          <span class="text-sm">เพิ่มสินค้าใหม่</span>
        </router-link>

        <div class="pt-6">
          <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest mb-3 px-2">อื่นๆ</p>
          <a href="#" class="nav-item opacity-50 cursor-not-allowed">
            <BarChart3 class="w-4 h-4" />
            <span class="text-sm">รายงานการขาย</span>
          </a>
          <a href="#" class="nav-item opacity-50 cursor-not-allowed">
            <Users class="w-4 h-4" />
            <span class="text-sm">จัดการพนักงาน</span>
          </a>
        </div>
      </nav>

      <div class="p-4 border-t border-slate-800 bg-slate-900/50">
        <div class="flex items-center space-x-3 mb-4 px-2">
          <div class="w-8 h-8 rounded-lg bg-slate-800 flex items-center justify-center text-blue-500 border border-slate-700 text-sm font-bold">
            {{ authStore.user?.name?.charAt(0) }}
          </div>
          <div class="flex-1 overflow-hidden">
            <p class="text-xs font-bold text-white truncate">{{ authStore.user?.name }}</p>
            <p class="text-[10px] text-slate-500 truncate capitalize">{{ authStore.user?.role === 'admin' ? 'ผู้ดูแลระบบ' : 'พนักงาน' }}</p>
          </div>
        </div>
        <button @click="handleLogout" class="flex items-center space-x-3 w-full p-2.5 text-slate-400 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-all text-xs font-medium">
          <LogOut class="w-4 h-4" />
          <span>ออกจากระบบ</span>
        </button>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 flex flex-col overflow-hidden w-full bg-slate-50">
      <header class="bg-white border-b border-slate-200 h-16 flex items-center justify-between px-4 lg:px-8 sticky top-0 z-10">
        <div class="flex items-center space-x-3">
          <button @click="isMobileMenuOpen = true" class="p-2 text-slate-500 hover:bg-slate-100 rounded-lg lg:hidden">
            <Menu class="w-5 h-5" />
          </button>
          <h2 class="text-sm font-bold text-slate-800 tracking-tight">{{ pageTitle }}</h2>
        </div>
        
        <div class="flex items-center space-x-3 lg:space-x-4">
          <div class="flex flex-col items-end hidden sm:flex">
             <span class="text-[10px] text-slate-400 font-bold uppercase tracking-tighter">วันที่ปัจจุบัน</span>
             <span class="text-xs font-bold text-slate-600">{{ currentDate }}</span>
          </div>
          <div class="h-6 w-px bg-slate-200 hidden sm:block"></div>
          <Bell class="w-5 h-5 text-slate-400 hover:text-blue-600 cursor-pointer transition" />
        </div>
      </header>

      <section class="flex-1 overflow-y-auto p-4 lg:p-8 bg-slate-50">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </section>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useAuthStore } from '../store/auth';
import { useRouter, useRoute } from 'vue-router';
import { 
  LayoutDashboard, Package, PlusCircle, LogOut, Smartphone, BarChart3, Users, Bell, Menu
} from 'lucide-vue-next';

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const isMobileMenuOpen = ref(false);

const pageTitle = computed(() => {
  switch (route.name) {
    case 'Dashboard': return 'ภาพรวมระบบ';
    case 'ProductList': return 'สต็อกสินค้า';
    case 'AddProduct': return 'เพิ่มสินค้าใหม่';
    default: return route.name;
  }
});

const currentDate = computed(() => {
  return new Date().toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: 'numeric' });
});

const handleLogout = () => {
  authStore.logout();
  router.push('/login');
};
</script>

<style scoped>
@reference "../style.css";

.nav-item {
  @apply flex items-center space-x-3 p-3 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition-all font-medium text-sm;
}
.nav-item.active {
  @apply bg-blue-600 text-white shadow-md;
}

.fade-enter-active, .fade-leave-active { transition: opacity 0.15s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
