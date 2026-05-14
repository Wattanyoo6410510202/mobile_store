<template>
  <div class="min-h-screen bg-[#FDFDFD] font-sans selection:bg-blue-100 selection:text-blue-600 overflow-x-hidden">
    <!-- Navbar -->
    <nav class="sticky top-0 bg-white/80 backdrop-blur-xl border-b border-slate-100 z-50 transition-all duration-300">
      <div class="max-w-7xl mx-auto px-6 py-3 flex items-center justify-between">
        <div class="flex items-center space-x-2 group cursor-pointer" @click="selectedBrand = null">
          <div class="w-8 h-8 bg-blue-600 rounded-xl flex items-center justify-center font-[1000] text-white italic text-xs shadow-lg shadow-blue-200 group-hover:rotate-12 transition-transform">V</div>
          <h1 class="text-xl font-[1000] text-slate-900 tracking-tighter uppercase">VIP<span class="text-blue-600">PHONE</span></h1>
        </div>
        <div class="hidden lg:flex items-center space-x-8 text-[11px] font-black text-slate-400 uppercase tracking-[0.2em]">
          <a href="#deals" class="hover:text-blue-600 transition-colors">สินค้าแนะนำ</a>
          <a href="#brands" class="hover:text-blue-600 transition-colors">แบรนด์</a>
          <a href="#quality" class="hover:text-blue-600 transition-colors">คุณภาพ</a>
          <a href="#faq" class="hover:text-blue-600 transition-colors">คำถาม</a>
          <router-link to="/login" class="px-6 py-2 bg-black text-white rounded-full hover:bg-blue-600 transition-all shadow-lg shadow-slate-100 active:scale-95 text-[10px] font-black">
            เข้าสู่ระบบ
          </router-link>
        </div>
      </div>
    </nav>

    <!-- Hero Section (Compact) -->
    <header class="relative pt-20 pb-24 overflow-hidden bg-white border-b border-slate-50">
      <div class="max-w-7xl mx-auto px-6 text-center relative z-10">
        <span class="inline-block px-3 py-1 bg-blue-50 text-blue-600 text-[9px] font-black uppercase tracking-[0.4em] rounded-full mb-6">PREMIUM CERTIFIED DEALER</span>
        <h2 class="text-5xl lg:text-7xl font-[1000] text-slate-900 leading-none tracking-[-0.05em] mb-8 animate-fade-in-up">
          MOBILES <br/>
          <span class="text-blue-600 underline decoration-blue-100 decoration-8 underline-offset-8">REDEFINED.</span>
        </h2>
        <p class="text-lg text-slate-400 font-medium max-w-2xl mx-auto mb-10 leading-relaxed animate-fade-in-up delay-100">
          ยกระดับสมาร์ทโฟนมือสองสู่มาตรฐานใหม่ <br/>
          ทุกเครื่องคือความสมบูรณ์แบบที่ผ่านการคัดสรรโดยผู้เชี่ยวชาญ
        </p>
        <div class="flex items-center justify-center gap-4 animate-fade-in-up delay-200">
          <a href="#deals" class="px-10 py-4 bg-black text-white font-[1000] text-[10px] uppercase tracking-[0.2em] rounded-xl hover:bg-blue-600 transition-all active:scale-95 shadow-xl shadow-slate-100">เริ่มเลือกซื้อ</a>
          <a href="#quality" class="px-10 py-4 border border-slate-200 text-slate-900 font-[1000] text-[10px] uppercase tracking-[0.2em] rounded-xl hover:bg-slate-50 transition-all">มาตรฐานของเรา</a>
        </div>
      </div>
      <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-blue-50/50 rounded-full blur-[100px] -z-10 animate-pulse"></div>
    </header>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-6">
      
      <!-- Shop by Brand Section (Compact) -->
      <section id="brands" class="mb-24 mt-12">
        <h2 class="text-2xl font-bold text-slate-900 mb-8 tracking-tight">เลือกตามแบรนด์</h2>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
          <div 
            v-for="brand in brandOptions" 
            :key="brand.name" 
            @click="selectedBrand = (brand.name === 'ทั้งหมด' ? null : brand.name)"
            class="group bg-[#F9FAFB] border border-slate-100 rounded-2xl p-6 flex flex-col items-center justify-center hover:border-blue-400 hover:bg-white hover:shadow-lg transition-all duration-500 cursor-pointer h-36"
            :class="(selectedBrand === brand.name || (selectedBrand === null && brand.name === 'ทั้งหมด')) ? 'border-blue-600 bg-white shadow-lg shadow-blue-100/50' : ''"
          >
            <div class="h-12 flex items-center justify-center mb-5">
              <component :is="brand.icon" class="text-slate-900 scale-110 group-hover:scale-125 transition-transform duration-500" />
            </div>
            <span class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] group-hover:text-blue-600 transition-colors" :class="(selectedBrand === brand.name || (selectedBrand === null && brand.name === 'ทั้งหมด')) ? 'text-blue-600' : ''">{{ brand.name }}</span>
          </div>
        </div>
      </section>

      <!-- Featured Deals Section (Standard Scale) -->
      <section id="deals" class="mb-24 scroll-mt-24">
        <div class="flex items-end justify-between mb-8">
          <div>
            <p class="text-[10px] font-[1000] text-blue-700 uppercase tracking-[0.3em] mb-1.5">MARKET WATCH</p>
            <h2 class="text-3xl font-bold text-slate-900 tracking-tight leading-none">สินค้าแนะนำ</h2>
          </div>
          <div class="flex items-center space-x-6">
            <button v-if="selectedBrand" @click="selectedBrand = null" class="text-[10px] font-black text-slate-300 hover:text-blue-600 transition-colors uppercase tracking-widest">
              ล้างการเลือก
            </button>
            <a href="#" class="text-sm font-bold text-blue-600 hover:underline flex items-center group">
              ดูทั้งหมด <ArrowRight class="w-4 h-4 ml-1.5 group-hover:translate-x-1 transition-transform" />
            </a>
          </div>
        </div>

        <div v-if="loading" class="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div v-for="i in 4" :key="i" class="aspect-[3/4] bg-slate-50 animate-pulse rounded-lg border border-slate-100"></div>
        </div>

        <div v-else-if="filteredProducts.length === 0" class="py-24 text-center border-2 border-dashed border-slate-100 rounded-3xl bg-slate-50/50">
          <Smartphone class="w-12 h-12 text-slate-200 mx-auto mb-4" />
          <p class="text-slate-400 font-bold uppercase tracking-widest text-xs">ไม่พบสินค้าในขณะนี้</p>
        </div>

        <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div v-for="product in filteredProducts.slice(0, 8)" :key="product.id" class="group bg-white border border-slate-200 rounded-lg p-4 hover:shadow-xl transition-all duration-500">
            <!-- Product Image Area -->
            <div class="relative aspect-square bg-[#F3F4F6] rounded-md overflow-hidden mb-6 border border-slate-50">
              <img v-if="product.thumbnail" :src="`http://localhost:5000${product.thumbnail}`" class="w-full h-full object-contain p-6 group-hover:scale-105 transition-transform duration-700" />
              <div v-else class="w-full h-full flex items-center justify-center">
                <Smartphone class="w-12 h-12 text-slate-200" />
              </div>
              
              <!-- Hot/Sale Tag -->
              <div class="absolute top-2.5 left-2.5">
                <span v-if="product.condition === 'new'" class="bg-[#2563EB] text-white text-[8px] font-black px-2 py-0.5 rounded-sm uppercase tracking-wider">HOT</span>
                <span v-else class="bg-[#DC2626] text-white text-[8px] font-black px-2 py-0.5 rounded-sm uppercase tracking-wider shadow-sm">SALE -15%</span>
              </div>
            </div>

            <!-- Product Info -->
            <div class="relative">
              <!-- Condition Badge -->
              <div class="absolute top-0 right-0">
                <span :class="getConditionClass(product.batteryHealth)" class="text-[8px] font-[1000] px-1.5 py-0.5 rounded-sm border uppercase tracking-wider bg-white">
                  {{ getConditionLabel(product.batteryHealth) }}
                </span>
              </div>

              <h3 class="text-[15px] font-bold text-slate-900 mb-1 leading-tight">{{ product.model }}</h3>
              <p class="text-[10px] text-slate-400 font-bold mb-4 uppercase tracking-tighter">
                {{ product.storage }} | {{ product.color }} | unlocked
              </p>
              
              <div class="flex items-baseline space-x-3 mb-6">
                <span class="text-xl font-bold text-slate-900">฿{{ Number(product.sellPrice).toLocaleString() }}</span>
                <span v-if="product.condition !== 'new'" class="text-sm text-slate-300 font-bold line-through">฿{{ Number(product.sellPrice * 1.15).toLocaleString() }}</span>
              </div>

              <button class="w-full bg-black text-white py-3 rounded-md text-[10px] font-black uppercase tracking-[0.2em] hover:bg-blue-600 transition-all active:scale-[0.98]">
                เพิ่มลงตะกร้า
              </button>
            </div>
          </div>
        </div>
      </section>

      <!-- Quality Assurance Section (Compact) -->
      <section id="quality" class="mb-24 scroll-mt-24">
        <div class="grid lg:grid-cols-2 gap-12 items-center border-t border-slate-100 pt-20">
          <div class="bg-black text-white p-10 lg:p-16 rounded-[3rem] relative overflow-hidden">
            <div class="absolute top-0 right-0 w-64 h-64 bg-blue-600/20 rounded-full blur-[80px]"></div>
            <span class="text-[9px] font-black text-blue-400 uppercase tracking-[0.5em] mb-8 block">DIAGNOSTIC EXCELLENCE</span>
            <h2 class="text-4xl lg:text-5xl font-[1000] mb-10 leading-none tracking-tighter">
              BEYOND <br/>
              INSPECTION.
            </h2>
            <div class="space-y-6">
              <div v-for="item in [
                { title: 'หน้าจอและระบบสัมผัส', desc: 'ตรวจสอบพิกเซลและความลื่นไหล 100%' },
                { title: 'สุขภาพแบตเตอรี่', desc: 'ยืนยันความจุจริงและรอบการชาร์จ' },
                { title: 'เครือข่ายและการเชื่อมต่อ', desc: 'ทดสอบ 5G, WiFi และ Bluetooth เต็มรูปแบบ' }
              ]" :key="item.title" class="flex items-start space-x-4">
                <div class="w-5 h-5 rounded-full bg-blue-500 flex items-center justify-center mt-1 shrink-0">
                  <Check class="w-3 h-3 text-white" />
                </div>
                <div>
                  <h4 class="text-xs font-black uppercase tracking-widest text-white">{{ item.title }}</h4>
                  <p class="text-slate-500 text-[10px] mt-1">{{ item.desc }}</p>
                </div>
              </div>
            </div>
          </div>
          <div>
            <h2 class="text-4xl font-black text-slate-900 tracking-tighter leading-tight mb-6">
              ทุกเครื่องผ่านการตรวจสอบ <br/> 
              <span class="text-blue-600 underline decoration-blue-100 decoration-4 underline-offset-8">อย่างละเอียดถี่ถ้วน</span> <br/>
              โดยผู้เชี่ยวชาญ.
            </h2>
            <p class="text-base text-slate-500 font-medium leading-relaxed mb-10">
              เรายึดถือมาตรฐานสูงสุดในการส่งมอบสมาร์ทโฟนมือสองคุณภาพดีเยี่ยม เพื่อให้คุณมั่นใจว่าทุกการใช้งานจะเป็นไปอย่างปลอดภัยไร้กังวล
            </p>
            <div class="grid grid-cols-2 gap-6">
              <div class="p-6 bg-slate-50 rounded-2xl border border-slate-100">
                <p class="text-4xl font-black text-slate-900 mb-1 leading-none tracking-tighter text-blue-600">100%</p>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest">อะไหล่แท้แน่นอน</p>
              </div>
              <div class="p-6 bg-slate-50 rounded-2xl border border-slate-100">
                <p class="text-4xl font-black text-slate-900 mb-1 leading-none tracking-tighter text-blue-600">30</p>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest">วัน การรับประกัน</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- FAQ Section (Compact) -->
      <section id="faq" class="mb-24 py-16 border-t border-slate-100">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-slate-900 tracking-tight uppercase">คำถามที่พบบ่อย</h2>
        </div>
        <div class="max-w-3xl mx-auto space-y-4">
          <div v-for="(faq, i) in [
            { q: 'สินค้าของ VIP Phone รับประกันอย่างไร?', a: 'สินค้าทุกเครื่องรับประกันการใช้งาน 30 วันเต็ม หากพบปัญหาปกติ สามารถส่งเคลมได้ทันทีโดยไม่มีค่าใช้จ่าย' },
            { q: 'สามารถขอดูสภาพเครื่องจริงก่อนสั่งซื้อได้ไหม?', a: 'ลูกค้าสามารถดูวิดีโอ 360 องศา และรูปถ่ายรายละเอียดทุกมุมของเครื่องได้ในหน้าสินค้าครับ' }
          ]" :key="i" class="p-6 bg-[#F8FAFC] rounded-2xl border border-slate-100 group hover:border-blue-400 hover:bg-white transition-all duration-300">
            <h4 class="text-base font-bold text-slate-900 mb-2 flex items-center">
              <span class="w-1.5 h-1.5 bg-blue-600 rounded-full mr-3"></span>
              {{ faq.q }}
            </h4>
            <p class="text-sm text-slate-500 leading-relaxed pl-4">{{ faq.a }}</p>
          </div>
        </div>
      </section>

    </main>

    <!-- Footer (Compact) -->
    <footer class="py-16 bg-black text-white overflow-hidden relative">
      <div class="absolute bottom-0 left-1/2 -translate-x-1/2 text-[10vw] font-[1000] text-white/[0.03] whitespace-nowrap pointer-events-none tracking-tighter select-none">VIP PHONE</div>
      <div class="max-w-7xl mx-auto px-6 text-center relative z-10">
        <div class="flex items-center justify-center space-x-2 mb-8">
          <h1 class="text-xl font-black tracking-tighter uppercase italic">VIP<span class="text-blue-500">PHONE</span></h1>
        </div>
        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-[0.4em]">
          &copy; 2026 VIP Phone. สงวนลิขสิทธิ์ตามกฎหมาย
        </p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, defineComponent, h } from 'vue';
import axios from 'axios';
import { Smartphone, ArrowRight, MoreHorizontal, Check, Menu } from 'lucide-vue-next';

const availableProducts = ref([]);
const loading = ref(true);
const selectedBrand = ref(null);

// Pixel-perfect Brand Icons using CSS/Tailwind (Standard Scale)
const AppleIcon = defineComponent({
  render() { return h('div', { class: 'text-2xl font-[1000] font-serif italic tracking-tighter' }, 'iOS') }
});
const SamsungIcon = defineComponent({
  render() { 
    return h('div', { class: 'w-10 h-10 border-[4px] border-slate-900 rounded-sm flex items-center justify-center p-1' }, 
    [h('div', { class: 'border-[3px] border-slate-900 w-full h-full rounded-[1px]' })]) 
  }
});
const GoogleIcon = defineComponent({
  render() { return h('div', { class: 'text-xl font-[1000] tracking-[-0.15em]' }, 'GOOGLE') }
});
const OnePlusIcon = defineComponent({
  render() { 
    return h('div', { class: 'w-10 h-10 flex flex-col items-center justify-center border-[4px] border-slate-900 rounded-sm' }, 
    [h('div', { class: 'text-[14px] font-[1000] leading-none mb-0.5' }, '1'), h('div', { class: 'text-[10px] font-black leading-none' }, '+')]) 
  }
});
const XiaomiIcon = defineComponent({
  render() { 
    return h('div', { class: 'w-10 h-10 border-[4px] border-slate-900 rounded-lg flex items-center justify-center' }, 
    [h('div', { class: 'w-6 h-6 bg-slate-900 rounded-[3px]' })]) 
  }
});

const brandOptions = [
  { name: 'Apple', icon: AppleIcon },
  { name: 'Samsung', icon: SamsungIcon },
  { name: 'Google', icon: GoogleIcon },
  { name: 'OnePlus', icon: OnePlusIcon },
  { name: 'Xiaomi', icon: XiaomiIcon },
  { name: 'ทั้งหมด', icon: MoreHorizontal }
];

const fetchAvailableProducts = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/products');
    availableProducts.value = response.data.filter(p => p.status === 'available');
  } catch (error) {
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

const filteredProducts = computed(() => {
  if (!selectedBrand.value) return availableProducts.value;
  return availableProducts.value.filter(p => p.brand.toLowerCase() === selectedBrand.value.toLowerCase());
});

const getConditionLabel = (health) => {
  if (health >= 95) return 'MINT';
  if (health >= 85) return 'GOOD';
  return 'FAIR';
};

const getConditionClass = (health) => {
  if (health >= 95) return 'border-blue-400 text-blue-600';
  if (health >= 85) return 'border-slate-300 text-slate-500';
  return 'border-orange-200 text-orange-600';
};

onMounted(fetchAvailableProducts);
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');

.font-sans {
  font-family: 'Inter', sans-serif;
}

@keyframes fade-in-up {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in-up {
  animation: fade-in-up 1s cubic-bezier(0.2, 0, 0, 1) forwards;
}

.delay-100 { animation-delay: 0.1s; }
.delay-200 { animation-delay: 0.2s; }
</style>
