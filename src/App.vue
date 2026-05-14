<template>
  <router-view />
</template>

<script setup>
import { onMounted, watch } from 'vue';
import { useCartStore } from './store/cart';
import { useAuthStore } from './store/auth';

const cartStore = useCartStore();
const authStore = useAuthStore();

onMounted(() => {
  if (authStore.isAuthenticated) {
    cartStore.fetchCart();
  }
});

// Watcher to handle authentication changes (e.g., login happening after app mount)
watch(() => authStore.isAuthenticated, (isAuth) => {
  if (isAuth) {
    cartStore.fetchCart();
  } else {
    cartStore.clearCart();
  }
});
</script>
