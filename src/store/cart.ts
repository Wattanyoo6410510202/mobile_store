import { ref, computed } from 'vue';
import { defineStore } from 'pinia';
import axios from 'axios';
import { useAuthStore } from './auth';

type CartItem = {
  id: string;
  Product?: Record<string, unknown>;
  [key: string]: unknown;
};

export const useCartStore = defineStore('cart', () => {
  const items = ref<CartItem[]>([]);
  const authStore = useAuthStore();

  async function fetchCart() {
    if (!authStore.user) return;
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('http://localhost:5000/api/cart', {
        headers: { Authorization: `Bearer ${token}` }
      });
      items.value = response.data;
    } catch (error) {
      console.error('Error fetching cart:', error);
    }
  }

  const addItem = async (product: { id: string } & Record<string, unknown>) => {
    if (!authStore.user) {
      throw new Error('กรุณาเข้าสู่ระบบเพื่อใช้งานตะกร้าสินค้า');
    }
    
    try {
      const token = localStorage.getItem('token');
      const response = await axios.post('http://localhost:5000/api/cart', 
        { product_id: product.id },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      items.value.push({ ...(response.data as CartItem), Product: product });
    } catch (error) {
      console.error('Error adding to cart:', error);
    }
  };

  const removeItem = async (cartItemId: string) => {
    try {
      const token = localStorage.getItem('token');
      await axios.delete(`http://localhost:5000/api/cart/${cartItemId}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      items.value = items.value.filter(i => i.id !== cartItemId);
    } catch (error) {
      console.error('Error removing from cart:', error);
    }
  };

  const clearCart = () => {
    items.value = [];
  };

  const cartCount = computed(() => items.value.length);

  return { items, addItem, removeItem, clearCart, cartCount, fetchCart };
});
