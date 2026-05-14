import { defineStore } from 'pinia';
import { io } from 'socket.io-client';

const socket = io('http://localhost:5000'); // Ensure this matches your backend port

export const useReservationStore = defineStore('reservation', {
  state: () => ({
    unreadCount: 0,
    showToast: false,
    latestReservation: null as any,
  }),
  actions: {
    initSocket() {
      socket.on('connect', () => {
        console.log('Socket connected:', socket.id);
      });
      socket.on('new_reservation', (data) => {
        console.log('New reservation received:', data);
        this.unreadCount++;
        this.latestReservation = data;
        this.triggerAlert();
      });
    },
    triggerAlert() {
      // Play sound
      const audio = new Audio('/sounds/notification.mp3');
      audio.play().catch(e => console.log('Audio playback failed:', e));
      
      // Show toast
      this.showToast = true;
      setTimeout(() => { this.showToast = false; }, 5000);
    },
    resetCount() {
      this.unreadCount = 0;
    },
  },
});
