import { defineStore } from 'pinia';
import { io, type Socket } from 'socket.io-client';
import { getApiOrigin } from '../config/api';

let socket: Socket | null = null;
let socketListenersBound = false;

function getSocket(): Socket {
  if (!socket) {
    socket = io(getApiOrigin(), { autoConnect: true });
  }
  return socket;
}

export const useReservationStore = defineStore('reservation', {
  state: () => ({
    unreadCount: 0,
    showToast: false,
    latestReservation: null as any,
    /** Bumped when `reservation:sync` delivers rows to merge on the admin list. */
    reservationSyncNonce: 0,
    reservationSyncRows: [] as any[],
  }),
  actions: {
    initSocket() {
      const s = getSocket();
      if (socketListenersBound) return;
      socketListenersBound = true;

      s.on('connect', () => {
        console.log('Socket connected:', s.id);
      });
      s.on('new_reservation', (data) => {
        console.log('New reservation received:', data);
        this.unreadCount++;
        this.latestReservation = data;
        this.triggerAlert();
      });
      s.on('reservation:sync', (payload: { rows?: unknown[] }) => {
        const rows = payload?.rows;
        if (!Array.isArray(rows) || rows.length === 0) return;
        this.reservationSyncRows = rows;
        this.reservationSyncNonce++;
      });
    },
    triggerAlert() {
      const audio = new Audio('/sounds/notification.mp3');
      audio.play().catch((e) => console.log('Audio playback failed:', e));

      this.showToast = true;
      setTimeout(() => {
        this.showToast = false;
      }, 5000);
    },
    resetCount() {
      this.unreadCount = 0;
    },
  },
});
