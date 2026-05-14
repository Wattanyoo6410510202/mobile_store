<template>
  <div v-if="isOpen" class="fixed inset-0 z-[100] flex justify-end">
    <!-- Backdrop -->
    <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" @click="$emit('close')"></div>
    
    <!-- Modal Content -->
    <div class="relative w-full sm:max-w-md bg-white h-full shadow-2xl p-6 sm:p-8 overflow-y-auto animate-in slide-in-from-right duration-300">
      <div class="flex items-center justify-between mb-6">
        <h2 class="text-lg sm:text-xl font-black uppercase tracking-tighter">ตะกร้าสินค้า</h2>
        <button @click="$emit('close')" class="text-slate-400 hover:text-black p-2">
          <X class="w-6 h-6" />
        </button>
      </div>

      <div v-if="cartStore.items.length === 0" class="text-center py-24 text-slate-400 font-bold uppercase tracking-widest text-sm">
        ตะกร้าว่างเปล่า
      </div>

      <div v-else class="space-y-6">
        <div v-for="item in cartStore.items" :key="item.id" class="flex items-center justify-between border-b border-slate-100 pb-4">
          <div class="flex items-center space-x-4">
            <img :src="assetUrl(item.Product?.thumbnail)" class="w-16 h-16 object-cover rounded-lg" />
            <div>
              <h3 class="font-bold text-sm">{{ item.Product.model }}</h3>
              <p class="text-[10px] text-slate-400 font-bold uppercase">{{ item.Product.brand }}</p>
            </div>
          </div>
          <div class="text-right">
            <p class="font-bold text-sm">฿{{ Number(item.Product.sellPrice).toLocaleString() }}</p>
            <button @click="cartStore.removeItem(item.id)" class="text-[10px] text-red-500 hover:underline">ลบ</button>
          </div>
        </div>

        <div class="pt-6 border-t-2 border-black">
          <div class="flex justify-between items-center mb-6">
            <span class="font-bold uppercase tracking-widest text-xs">รวมทั้งหมด</span>
            <span class="text-xl font-black">฿{{ total.toLocaleString() }}</span>
          </div>
          <button @click="handleCheckout" :disabled="loading" class="w-full py-4 bg-black text-white font-black text-xs uppercase tracking-[0.2em] hover:bg-blue-600 transition-all">
            {{ loading ? 'กำลังดำเนินการ...' : 'ยืนยันการจอง' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import axios from 'axios';
import { useCartStore } from '../store/cart';
import { X } from 'lucide-vue-next';
import { getApiBasePath, assetUrl } from '../config/api';

defineProps({ isOpen: Boolean });
const emit = defineEmits(['close']);

const cartStore = useCartStore();
const loading = ref(false);
const total = computed(() => cartStore.items.reduce((sum, item) => sum + Number(item.Product.sellPrice), 0));

const handleCheckout = async () => {
  loading.value = true;
  try {
    const token = localStorage.getItem('token');
    await axios.post(`${getApiBasePath()}/checkout`, {}, {
      headers: { Authorization: `Bearer ${token}` }
    });
    alert('จองสินค้าสำเร็จ!');
    cartStore.clearCart();
    emit('close');
  } catch (error) {
    alert(error.response?.data?.message || 'เกิดข้อผิดพลาดในการจอง');
  } finally {
    loading.value = false;
  }
};
</script>
