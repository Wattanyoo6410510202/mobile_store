import { defineStore } from 'pinia';
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:5000/api',
});

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: JSON.parse(localStorage.getItem('user')) || null,
    token: localStorage.getItem('token') || null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
  },
  actions: {
    async login(email, password) {
      try {
        const response = await api.post('/auth/login', { email, password });
        this.user = response.data.user;
        this.token = response.data.token;
        localStorage.setItem('token', this.token);
        localStorage.setItem('user', JSON.stringify(this.user));
        return true;
      } catch (error) {
        console.error('Login failed', error);
        throw error;
      }
    },
    logout() {
      this.user = null;
      this.token = null;
      localStorage.removeItem('token');
      localStorage.removeItem('user');
    },
  },
});
