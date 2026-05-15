import { defineStore } from 'pinia';
import axios from 'axios';
import { useCartStore } from './cart';
import { getApiBasePath } from '../config/api';
import router from '../router';

const api = axios.create({
  baseURL: getApiBasePath(),
});

type AuthUser = {
  id?: number | string;
  name?: string;
  email?: string;
  role?: string;
};

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: (JSON.parse(localStorage.getItem('user') ?? 'null') as AuthUser | null) ?? null,
    token: (localStorage.getItem('token') as string | null) ?? null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
  },
  actions: {
    async login(email: string, password: string) {
      try {
        const response = await api.post('/auth/login', { email, password });
        this.user = response.data.user;
        this.token = response.data.token;
        if (this.token) localStorage.setItem('token', this.token);
        localStorage.setItem('user', JSON.stringify(this.user));
        
        // Sync cart after login
        const cartStore = useCartStore();
        await cartStore.fetchCart();
        
        return true;
      } catch (error) {
        console.error('Login failed', error);
        throw error;
      }
    },
    logout() {
      const cartStore = useCartStore();
      cartStore.clearCart();
      
      this.user = null;
      this.token = null;
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      router.push('/login');
    },
  },
});
