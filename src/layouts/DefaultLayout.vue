<template>
  <div class="flex flex-col h-screen bg-[var(--gh-canvas-subtle)] font-sans text-[var(--gh-fg-default)]">
    <!-- Main Content -->
    <main class="flex-1 flex flex-col overflow-hidden w-full bg-[var(--gh-canvas-subtle)]">
      <header class="bg-white border-b sticky top-0 z-10" :style="{ borderColor: 'var(--gh-border-default)' }">
        <!-- Top bar (GitHub-like) -->
        <div class="h-12 flex items-center justify-between px-2 sm:px-3 lg:px-6">
          <div class="flex items-center gap-2 min-w-0">
            <div class="w-8 h-8 rounded-full bg-slate-900 flex items-center justify-center text-white text-xs font-black tracking-tight">
              VIP
            </div>

            <div class="relative" ref="userMenuRef">
              <button
                class="inline-flex items-center gap-1.5 px-2 py-1.5 rounded-md hover:bg-slate-100 text-sm font-semibold text-slate-800 min-w-0"
                @click="isUserMenuOpen = !isUserMenuOpen"
                aria-haspopup="menu"
                :aria-expanded="isUserMenuOpen ? 'true' : 'false'"
              >
                <UserCircle2 class="w-5 h-5 text-slate-700 sm:hidden" />
                <span class="truncate hidden sm:inline">{{ authStore.user?.name || 'Administrator' }}</span>
                <ChevronDown class="w-4 h-4 text-slate-500 flex-shrink-0" />
              </button>

              <div
                v-if="isUserMenuOpen"
                class="absolute left-0 mt-2 z-50 w-56 rounded-md border bg-white shadow-lg py-1"
                :style="{ borderColor: 'var(--gh-border-default)' }"
                role="menu"
              >
                <div class="px-3 py-2 border-b" :style="{ borderColor: 'var(--gh-border-default)' }">
                  <p class="text-xs font-bold text-slate-800 truncate">{{ authStore.user?.name || 'Administrator' }}</p>
                  <p class="text-[11px] text-slate-500 truncate capitalize">{{ authStore.user?.role === 'admin' ? 'ผู้ดูแลระบบ' : 'พนักงาน' }}</p>
                </div>

                <button
                  class="w-full text-left px-3 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-100 flex items-center gap-2"
                  @click="handleLogoutFromMenu"
                  role="menuitem"
                >
                  <LogOut class="w-4 h-4 text-slate-500" />
                  <span>Logout</span>
                </button>
              </div>
            </div>
          </div>

          <div class="flex items-center gap-2">
            <!-- Search -->
            <div class="hidden md:flex items-center">
              <div class="relative">
                <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
                <input
                  class="h-8 w-[260px] lg:w-[360px] rounded-md border bg-white pl-9 pr-20 text-sm text-slate-800 placeholder:text-slate-500 focus:outline-none"
                  :style="{ borderColor: 'var(--gh-border-default)' }"
                  placeholder="Type / to search"
                />
                <kbd class="absolute right-2 top-1/2 -translate-y-1/2 text-[10px] font-semibold text-slate-500 border rounded px-1.5 py-0.5 bg-white"
                  :style="{ borderColor: 'var(--gh-border-default)' }"
                >/</kbd>
              </div>
            </div>

            <!-- Icon buttons -->
            <button class="md:hidden inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="Search"
              title="Search"
            >
              <Search class="w-4 h-4" />
            </button>

            <button class="inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="Apps"
            >
              <LayoutGrid class="w-4 h-4" />
            </button>

            <button class="inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="New"
            >
              <Plus class="w-4 h-4" />
            </button>

            <button class="hidden sm:inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="Issues"
            >
              <CircleDot class="w-4 h-4" />
            </button>

            <button class="hidden sm:inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="Pull requests"
            >
              <GitPullRequest class="w-4 h-4" />
            </button>

            <button class="inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="Notifications"
            >
              <Inbox class="w-4 h-4" />
            </button>

            <button class="hidden sm:inline-flex items-center justify-center h-8 w-8 rounded-md border bg-white hover:bg-slate-100 text-slate-700"
              :style="{ borderColor: 'var(--gh-border-default)' }"
              aria-label="Profile"
            >
              <UserCircle2 class="w-4 h-4" />
            </button>
          </div>
        </div>

        <!-- Second row tabs (like screenshot) -->
        <div class="h-10 flex items-center gap-4 px-2 sm:px-3 lg:px-6 border-t overflow-x-auto gh-scrollbar-hide" :style="{ borderColor: 'var(--gh-border-default)' }">
          <router-link
            to="/admin"
            class="inline-flex items-center gap-2 text-sm font-semibold px-2 py-1 rounded-md hover:bg-slate-100 whitespace-nowrap flex-shrink-0"
            :class="route.name === 'Dashboard' ? 'text-slate-900' : 'text-slate-600'"
          >
            <LayoutDashboard class="w-4 h-4" />
            <span>Dashboard</span>
          </router-link>

          <router-link
            to="/admin/products"
            class="inline-flex items-center gap-2 text-sm font-semibold px-2 py-1 rounded-md hover:bg-slate-100 whitespace-nowrap flex-shrink-0"
            :class="route.name === 'ProductList' ? 'text-slate-900' : 'text-slate-600'"
          >
            <Package class="w-4 h-4" />
            <span>สินค้า</span>
          </router-link>

          <router-link
            to="/admin/products/add"
            class="inline-flex items-center gap-2 text-sm font-semibold px-2 py-1 rounded-md hover:bg-slate-100 whitespace-nowrap flex-shrink-0"
            :class="route.name === 'AddProduct' ? 'text-slate-900' : 'text-slate-600'"
          >
            <PlusCircle class="w-4 h-4" />
            <span>เพิ่มสินค้า</span>
          </router-link>

          <router-link
            to="/admin/products/scan"
            class="inline-flex items-center gap-2 text-sm font-semibold px-2 py-1 rounded-md hover:bg-slate-100 whitespace-nowrap flex-shrink-0"
            :class="route.name === 'Scanner' ? 'text-slate-900' : 'text-slate-600'"
          >
            <QrCode class="w-4 h-4" />
            <span>สแกน</span>
          </router-link>

          <div class="ml-auto text-xs font-semibold text-slate-500 hidden md:block">
            {{ pageTitle }} • {{ currentDate }}
          </div>
        </div>
      </header>

      <section class="flex-1 overflow-y-auto p-3 sm:p-4 lg:p-8 bg-[var(--gh-canvas-subtle)]">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
import { useAuthStore } from '../store/auth';
import { useRouter, useRoute } from 'vue-router';
import { 
  LayoutDashboard,
  Package,
  PlusCircle,
  LogOut,
  Search,
  LayoutGrid,
  Plus,
  CircleDot,
  GitPullRequest,
  Inbox,
  UserCircle2,
  ChevronDown,
  QrCode,
} from 'lucide-vue-next';

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const isUserMenuOpen = ref(false);
const userMenuRef = ref<HTMLElement | null>(null);

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

const handleLogoutFromMenu = () => {
  isUserMenuOpen.value = false;
  handleLogout();
};

const onDocumentPointerDown = (e: PointerEvent) => {
  if (!isUserMenuOpen.value) return;
  const el = userMenuRef.value;
  if (!el) return;
  if (e.target instanceof Node && !el.contains(e.target)) {
    isUserMenuOpen.value = false;
  }
};

onMounted(() => {
  document.addEventListener('pointerdown', onDocumentPointerDown);
});

onBeforeUnmount(() => {
  document.removeEventListener('pointerdown', onDocumentPointerDown);
});
</script>

<style scoped>
@reference "../style.css";

.fade-enter-active, .fade-leave-active { transition: opacity 0.15s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
