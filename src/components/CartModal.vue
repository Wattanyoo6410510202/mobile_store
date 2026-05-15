<template>
  <div v-if="isOpen" class="fixed inset-0 z-[100] flex justify-end">
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" @click="$emit('close')"></div>
    
    <!-- Modal Content -->
    <div class="relative w-full sm:max-w-md bg-white h-full shadow-2xl p-6 sm:p-8 overflow-y-auto animate-in slide-in-from-right duration-300">
      <div v-if="isSuccess" class="h-full flex flex-col items-center justify-center text-center animate-in zoom-in duration-500 py-20">
        <div class="w-24 h-24 bg-green-50 rounded-full flex items-center justify-center mx-auto mb-6 shadow-xl shadow-green-100/50">
          <Check class="w-12 h-12 text-green-500" stroke-width="3" />
        </div>
        <h3 class="text-3xl font-black text-slate-900 mb-3 tracking-tight">จองสินค้าสำเร็จ!</h3>
        <p class="text-slate-500 font-medium mb-10 text-sm leading-relaxed">
          ขอบคุณที่ไว้วางใจ VIP PHONE<br/>
          รายการจองของคุณถูกบันทึกเรียบร้อยแล้ว
        </p>
        <button @click="closeSuccess" class="px-10 py-4 bg-black text-white rounded-xl font-black uppercase tracking-widest text-xs hover:bg-green-500 hover:shadow-lg hover:-translate-y-0.5 transition-all w-full">
          ตกลง
        </button>
      </div>

      <div v-else class="h-full flex flex-col">
        <div class="flex items-center justify-between mb-4 shrink-0 border-b border-slate-100 pb-2">
          <div class="flex space-x-6">
            <button @click="activeTab = 'cart'" :class="activeTab === 'cart' ? 'text-black border-b-2 border-black' : 'text-slate-400'" class="text-sm font-black uppercase tracking-tighter pb-2 -mb-[9px] transition-colors relative">
              ตะกร้าสินค้า 
              <span v-if="cartStore.items.length > 0" class="absolute -top-2 -right-3 bg-black text-white text-[9px] px-1.5 py-0.5 rounded-full">{{cartStore.items.length}}</span>
            </button>
            <button @click="activeTab = 'reservations'" :class="activeTab === 'reservations' ? 'text-black border-b-2 border-black' : 'text-slate-400'" class="text-sm font-black uppercase tracking-tighter pb-2 -mb-[9px] transition-colors">
              การจองของฉัน
            </button>
          </div>
          <button @click="$emit('close')" class="text-slate-400 hover:text-black p-2 -mr-2 -mt-2">
            <X class="w-5 h-5" />
          </button>
        </div>

        <!-- Tab: Cart -->
        <div v-if="activeTab === 'cart'" class="flex-1 overflow-y-auto pt-2 flex flex-col">
          <div v-if="cartStore.items.length === 0" class="flex-1 flex flex-col items-center justify-center text-slate-400 font-bold uppercase tracking-widest text-sm min-h-[200px]">
            ตะกร้าว่างเปล่า
          </div>

          <div v-else class="space-y-6 flex-1">
            <div v-for="item in cartStore.items" :key="item.id" class="flex items-center justify-between border-b border-slate-100 pb-4">
              <div class="flex items-center space-x-4">
                <img :src="assetUrl(item.Product?.thumbnail)" class="w-16 h-16 object-cover rounded-lg shadow-sm" />
                <div>
                  <h3 class="font-bold text-sm">{{ item.Product.model }}</h3>
                  <p class="text-[10px] text-slate-400 font-bold uppercase">{{ item.Product.brand }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="font-bold text-sm">฿{{ Number(item.Product.sellPrice).toLocaleString() }}</p>
                <button @click="cartStore.removeItem(item.id)" class="text-[10px] font-bold text-red-500 hover:underline uppercase tracking-wider">ลบ</button>
              </div>
            </div>
          </div>

          <div v-if="cartStore.items.length > 0" class="pt-6 border-t-2 border-black shrink-0 mt-6">
            <div class="flex justify-between items-center mb-6">
              <span class="font-bold uppercase tracking-widest text-xs">รวมทั้งหมด</span>
              <span class="text-xl font-black">฿{{ total.toLocaleString() }}</span>
            </div>
            <button @click="handleCheckout" :disabled="loading" class="w-full py-4 bg-black text-white font-black text-xs uppercase tracking-[0.2em] hover:bg-blue-600 active:scale-[0.98] transition-all rounded-xl shadow-xl">
              {{ loading ? 'กำลังดำเนินการ...' : 'ยืนยันการจอง' }}
            </button>
          </div>
        </div>

        <!-- Tab: Reservations -->
        <div v-else-if="activeTab === 'reservations'" class="flex-1 overflow-y-auto pt-2">
          <div v-if="resLoading" class="flex justify-center py-10">
            <div class="w-6 h-6 border-2 border-slate-200 border-t-black rounded-full animate-spin"></div>
          </div>
          <div v-else-if="myReservations.length === 0" class="text-center flex flex-col items-center justify-center py-24 text-slate-400 font-bold uppercase tracking-widest text-sm min-h-[200px]">
            ไม่มีประวัติการจอง
          </div>
          <div v-else class="space-y-4 pb-4">
            <div v-for="res in myReservations" :key="res.id" class="border border-slate-100 p-4 rounded-xl shadow-sm hover:border-slate-300 transition-colors bg-slate-50/50">
              <div class="flex items-center justify-between mb-3 border-b border-slate-100 pb-2">
                <span class="text-[10px] text-slate-400 font-bold uppercase tracking-widest">ID: {{ res.id.slice(0,8) }}</span>
                <span :class="getStatusClass(res.status)" class="text-[9px] font-black uppercase tracking-widest px-2 py-0.5 rounded-sm border">
                  {{ getStatusText(res.status) }}
                </span>
              </div>
              <div class="flex items-center space-x-4">
                <img :src="assetUrl(res.Product?.thumbnail)" class="w-16 h-16 object-cover rounded-lg shadow-sm bg-white" />
                <div class="flex-1">
                  <h3 class="font-bold text-sm text-slate-900 leading-tight">{{ res.Product?.model || 'Unknown Product' }}</h3>
                  <p class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mt-0.5">{{ res.Product?.brand || '' }}</p>
                  <p class="text-sm font-black mt-1 text-slate-900">฿{{ Number(res.Product?.sellPrice || 0).toLocaleString() }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import axios from 'axios';
import { useCartStore } from '../store/cart';
import { X, Check } from 'lucide-vue-next';
import { getApiBasePath, assetUrl } from '../config/api';

const props = defineProps({ isOpen: Boolean });
const emit = defineEmits(['close']);

const cartStore = useCartStore();
const loading = ref(false);
const isSuccess = ref(false);
const activeTab = ref('cart');
const myReservations = ref([]);
const resLoading = ref(false);

const total = computed(() => cartStore.items.reduce((sum, item) => sum + Number(item.Product.sellPrice), 0));

const fetchMyReservations = async () => {
  resLoading.value = true;
  try {
    const token = localStorage.getItem('token');
    if (!token) return;
    const res = await axios.get(`${getApiBasePath()}/reservations/me`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    myReservations.value = res.data;
  } catch (error) {
    console.error('Failed to fetch reservations', error);
  } finally {
    resLoading.value = false;
  }
};

watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    fetchMyReservations();
    activeTab.value = cartStore.items.length > 0 ? 'cart' : 'reservations';
    isSuccess.value = false;
  }
});

const getStatusText = (status) => {
  const map = { pending: 'รอดำเนินการ', confirmed: 'ยืนยันแล้ว', cancelled: 'ยกเลิก', completed: 'เสร็จสิ้น' };
  return map[status] || status;
};

const getStatusClass = (status) => {
  const map = {
    pending: 'text-orange-600 bg-orange-50 border-orange-200',
    confirmed: 'text-blue-600 bg-blue-50 border-blue-200',
    cancelled: 'text-red-600 bg-red-50 border-red-200',
    completed: 'text-green-600 bg-green-50 border-green-200'
  };
  return map[status] || 'text-slate-600 bg-slate-50 border-slate-200';
};

const handleCheckout = async () => {
  loading.value = true;
  try {
    const token = localStorage.getItem('token');
    await axios.post(`${getApiBasePath()}/checkout`, {}, {
      headers: { Authorization: `Bearer ${token}` }
    });
    cartStore.clearCart();
    isSuccess.value = true;
    fetchMyReservations(); // Refresh list behind the scenes
  } catch (error) {
    alert(error.response?.data?.message || 'เกิดข้อผิดพลาดในการจอง');
  } finally {
    loading.value = false;
  }
};

const closeSuccess = () => {
  isSuccess.value = false;
  activeTab.value = 'reservations'; // Switch to reservations tab to show what they just booked
};
</script>
