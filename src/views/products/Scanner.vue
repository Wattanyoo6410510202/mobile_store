<template>
  <div class="max-w-xl mx-auto space-y-6 pb-20">
    <div class="flex items-center space-x-3 mb-6">
      <button @click="$router.back()" class="gh-btn !p-2" aria-label="Back">
        <ArrowLeft class="w-5 h-5" />
      </button>
      <div>
        <h1 class="gh-h1">สแกน QR Code</h1>
        <p class="gh-subtitle">สแกนรหัสสินค้าเพื่อดูข้อมูลทันที</p>
      </div>
    </div>

    <!-- Scanner Container -->
    <div class="gh-surface gh-card overflow-hidden relative">
      <div id="reader" class="w-full aspect-square bg-slate-900"></div>
      
      <!-- Overlay for Visual Guide -->
      <div class="absolute inset-0 pointer-events-none flex flex-col items-center justify-center">
         <div class="w-64 h-64 border-2 border-blue-500 rounded-xl opacity-50 relative">
            <div class="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-white rounded-tl-lg"></div>
            <div class="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-white rounded-tr-lg"></div>
            <div class="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-white rounded-bl-lg"></div>
            <div class="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-white rounded-br-lg"></div>
         </div>
         <p class="text-white text-[10px] font-bold mt-4 uppercase tracking-widest bg-black/40 px-3 py-1 rounded-full backdrop-blur-md">Place QR code inside the frame</p>
      </div>
    </div>

    <div class="flex flex-col items-center space-y-4">
       <button 
         @click="toggleScanner" 
         class="gh-btn gh-btn-primary px-6 py-3 active:translate-y-px"
       >
         <Camera class="w-5 h-5" />
         <span>{{ isScanning ? 'หยุดสแกน' : 'เริ่มสแกนใหม่' }}</span>
       </button>
       <p v-if="error" class="text-red-500 text-xs font-medium">{{ error }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { Html5Qrcode } from 'html5-qrcode';
import { useRouter } from 'vue-router';
import { ArrowLeft, Camera } from 'lucide-vue-next';

const router = useRouter();
const isScanning = ref(false);
const error = ref('');
let html5QrCode = null;

const onScanSuccess = (decodedText) => {
  try {
    const data = JSON.parse(decodedText);
    if (data.id) {
      stopScanner().then(() => {
        // We'll redirect to a product detail page (to be implemented) or back to list with filter
        router.push({ name: 'ProductList', query: { search: data.id } });
      });
    }
  } catch (e) {
    console.error('Invalid QR data', decodedText);
    error.value = 'รหัส QR ไม่ถูกต้องสำหรับระบบนี้';
  }
};

const startScanner = async () => {
  try {
    error.value = '';
    const devices = await Html5Qrcode.getCameras();
    if (devices && devices.length > 0) {
      const config = { fps: 10, qrbox: { width: 250, height: 250 } };
      await html5QrCode.start(
        { facingMode: "environment" }, 
        config, 
        onScanSuccess
      );
      isScanning.value = true;
    } else {
      error.value = 'ไม่พบกล้องในอุปกรณ์นี้';
    }
  } catch (err) {
    console.error('Scanner start failed', err);
    error.value = 'ไม่สามารถเข้าถึงกล้องได้';
  }
};

const stopScanner = async () => {
  if (html5QrCode && isScanning.value) {
    await html5QrCode.stop();
    isScanning.value = false;
  }
};

const toggleScanner = () => {
  if (isScanning.value) {
    stopScanner();
  } else {
    startScanner();
  }
};

onMounted(() => {
  html5QrCode = new Html5Qrcode("reader");
  startScanner();
});

onBeforeUnmount(() => {
  stopScanner();
});
</script>
