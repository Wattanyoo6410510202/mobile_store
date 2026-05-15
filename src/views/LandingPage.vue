<template>
  <div class="min-h-screen bg-white font-sans selection:bg-blue-100 selection:text-blue-600 overflow-x-hidden">
    <!-- Navbar -->
    <nav
      class="fixed top-0 left-0 w-full bg-white/80 backdrop-blur-xl border-b border-slate-100 z-50 transition-all duration-300">
      <div class="max-w-7xl mx-auto px-6 py-3 flex items-center justify-between">
        <div class="flex items-center space-x-2 group cursor-pointer" @click="selectedBrand = null">
          <div
            class="w-8 h-8 bg-blue-600 rounded-xl flex items-center justify-center font-[1000] text-white italic text-xs shadow-lg shadow-blue-200 group-hover:rotate-12 transition-transform">
            V</div>
          <h1 class="text-xl font-[1000] text-slate-900 tracking-tighter uppercase">VIP<span
              class="text-blue-600">PHONE</span></h1>
        </div>
        <div
          class="flex items-center space-x-4 sm:space-x-6 text-[10px] sm:text-[11px] font-black text-slate-400 uppercase tracking-[0.2em]">
          
          <div class="hidden lg:flex items-center space-x-8">
            <a href="#deals" class="hover:text-blue-600 transition-colors">สินค้าแนะนำ</a>
            <a href="#brands" class="hover:text-blue-600 transition-colors">แบรนด์</a>
            <a href="#quality" class="hover:text-blue-600 transition-colors">คุณภาพ</a>
            <a href="#faq" class="hover:text-blue-600 transition-colors">คำถาม</a>
          </div>

          <button @click="isCartOpen = true" class="relative group p-1">
            <ShoppingBag class="w-5 h-5 hover:text-blue-600 transition-colors" />
            <span v-if="cartStore.cartCount > 0" class="absolute -top-1 -right-1 bg-blue-600 text-white text-[9px] font-bold w-4 h-4 rounded-full flex items-center justify-center">{{ cartStore.cartCount }}</span>
          </button>
          
          <div v-if="authStore.user" class="flex items-center space-x-3">
            <span class="hidden sm:inline-block text-slate-900 truncate max-w-[150px] text-[10px]">{{ authStore.user.email }}</span>
            <button @click="authStore.logout()" class="text-slate-400 hover:text-red-600 transition-colors">
              <LogOut class="w-4 h-4" />
            </button>
          </div>
          <router-link v-else to="/login"
            class="px-4 py-2 bg-black text-white rounded-full hover:bg-blue-600 transition-all shadow-lg shadow-slate-100 active:scale-95 text-[10px] font-black">
            เข้าสู่ระบบ
          </router-link>
        </div>
      </div>
    </nav>

    <!-- Hero Section (Compact) -->
    <header class="relative pt-32 pb-24 overflow-hidden min-h-[600px] flex items-center bg-slate-900">
      <!-- Video Background Wrapper -->
      <div class="absolute inset-0 w-full h-full overflow-hidden pointer-events-none">
        <video autoplay loop muted playsinline class="absolute inset-0 w-full h-full object-cover" style="z-index: 0;">
          <source src="/landingpage.mp4" type="video/mp4">
        </video>
        <div class="" style="z-index: 1;"></div>
      </div>

      <div class="max-w-7xl mx-auto px-6 text-center relative" style="z-index: 10;">
        <span
          class="inline-block px-3 py-1 bg-blue-50/90 text-blue-600 text-[9px] font-black uppercase tracking-[0.4em] rounded-full mb-6 backdrop-blur-md">
          PREMIUM CERTIFIED DEALER
        </span>
        <h2
          class="text-5xl lg:text-7xl font-[1000] text-white leading-none tracking-[-0.05em] mb-8 animate-fade-in-up">
          VIP <br />
          <span class="text-blue-600 underline decoration-blue-100 decoration-8 underline-offset-8">PHONE</span>
        </h2>
        <p
          class="text-lg text-white font-bold max-w-2xl mx-auto mb-10 leading-relaxed animate-fade-in-up delay-100">
          ยกระดับสมาร์ทโฟนมือสองสู่มาตรฐานใหม่ <br />
          ทุกเครื่องคือความสมบูรณ์แบบที่ผ่านการคัดสรรโดยผู้เชี่ยวชาญ
        </p>
      </div>
    </header>


    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-6 py-12 md:py-24 space-y-24 md:space-y-32">

      <!-- Shop by Brand Section -->
      <section id="brands" class="section-animate" v-intersection>
        <h2 class="text-2xl font-bold text-slate-900 mb-8 md:mb-12 tracking-tight">เลือกตามแบรนด์</h2>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
          <div v-for="brand in brandOptions" :key="brand.name"
            @click="selectedBrand = (brand.name === 'ทั้งหมด' ? null : brand.name)"
            class="group bg-white border border-slate-100 rounded-2xl p-6 flex flex-col items-center justify-center hover:border-blue-400 hover:shadow-lg transition-all duration-500 cursor-pointer h-36 hover-reveal"
            :class="(selectedBrand === brand.name || (selectedBrand === null && brand.name === 'ทั้งหมด')) ? 'border-blue-600 shadow-lg shadow-blue-100/50' : ''">
            <div class="h-12 flex items-center justify-center mb-5">
              <img v-if="brand.imageUrl" :src="brand.imageUrl" :alt="brand.name" loading="lazy"
                class="w-10 h-10 object-contain scale-110 group-hover:scale-125 transition-transform duration-500 opacity-90 group-hover:opacity-100" />
              <component v-else :is="brand.icon"
                class="text-slate-900 scale-110 group-hover:scale-125 transition-transform duration-500 w-10 h-10" />
            </div>
            <span
              class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] group-hover:text-blue-600 transition-colors"
              :class="(selectedBrand === brand.name || (selectedBrand === null && brand.name === 'ทั้งหมด')) ? 'text-blue-600' : ''">{{
                brand.name }}</span>
          </div>
        </div>
      </section>

      <!-- Featured Deals Section -->
      <section id="deals" class="section-animate" v-intersection>
        <div class="relative z-10 p-8 lg:p-10 bg-white/10 backdrop-blur-[1px]">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
            <div>
              <p class="text-[10px] font-[1000] text-blue-700 uppercase tracking-[0.3em] mb-1.5">MARKET WATCH</p>
              <h2 class="text-3xl font-bold text-slate-900 tracking-tight leading-none">Featured Deals</h2>
            </div>
            <div class="flex items-center gap-3">
              <div class="relative group">
                <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-slate-400 group-focus-within:text-blue-600 transition-colors pointer-events-none" />
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="ค้นหาสินค้า..."
                  class="pl-9 pr-4 py-2.5 text-[11px] font-semibold bg-slate-50 border border-slate-200 rounded-xl w-52 focus:outline-none focus:border-blue-400 focus:bg-white focus:shadow-md focus:shadow-blue-100/50 transition-all placeholder:text-slate-300"
                />
                <button
                  v-if="searchQuery"
                  @click="searchQuery = ''"
                  class="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-300 hover:text-slate-600 transition-colors"
                >
                  <X class="w-3 h-3" />
                </button>
              </div>
              <button v-if="selectedBrand" @click="selectedBrand = null"
                class="text-[10px] font-black text-slate-300 hover:text-blue-600 transition-colors uppercase tracking-widest whitespace-nowrap">
                ล้างการเลือก
              </button>
            </div>
          </div>

          <div v-if="loading" class="grid grid-cols-2 lg:grid-cols-4 gap-4">
            <Skeleton v-for="i in 8" :key="i" class="aspect-[3/4] w-full" />
          </div>

          <div v-else-if="filteredProducts.length === 0"
            class="py-24 text-center border-2 border-dashed border-slate-100 rounded-3xl bg-white/50 backdrop-blur-md">
            <Smartphone class="w-12 h-12 text-slate-200 mx-auto mb-4" />
            <p class="text-slate-400 font-bold uppercase tracking-widest text-xs">ไม่พบสินค้าในขณะนี้</p>
          </div>

          <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div v-for="product in displayedProducts" :key="product.id"
              class="group bg-white/90 border border-slate-100 rounded-lg p-4 hover:shadow-xl hover:bg-white transition-all duration-500 hover-reveal">
              <div class="relative aspect-square rounded-md overflow-hidden mb-6 flex items-center justify-center">
                <img v-if="product.thumbnail" :src="assetUrl(product.thumbnail)" loading="lazy"
                  class="w-full h-full object-contain p-2 transition-transform duration-700 group-hover:scale-110" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <Smartphone class="w-12 h-12 text-slate-200" />
                </div>
                <div class="absolute top-2 left-2">
                  <span v-if="product.condition === 'new'"
                    class="bg-[#2563EB] text-white text-[8px] font-black px-2 py-0.5 rounded-sm uppercase tracking-wider shadow-sm">HOT</span>
                  <span v-else
                    class="bg-[#DC2626] text-white text-[8px] font-black px-2 py-0.5 rounded-sm uppercase tracking-wider shadow-sm">SALE
                    -15%</span>
                </div>
              </div>

              <div class="relative">
                <div class="absolute top-0 right-0">
                  <span :class="getConditionClass(product.batteryHealth)"
                    class="text-[8px] font-[1000] px-1.5 py-0.5 rounded-sm border uppercase tracking-wider bg-white">
                    {{ getConditionLabel(product.batteryHealth) }}
                  </span>
                </div>

                <h3 class="text-[15px] font-bold text-slate-900 mb-1 leading-tight">{{ product.model }}</h3>
                <p class="text-[10px] text-slate-400 font-bold mb-4 uppercase tracking-tighter">
                  {{ product.storage }} | {{ product.color }} | unlocked
                </p>

                <div class="flex items-baseline space-x-3 mb-6">
                  <span class="text-xl font-bold text-slate-900">฿{{ Number(product.sellPrice).toLocaleString()
                  }}</span>
                  <span v-if="product.condition !== 'new'" class="text-sm text-slate-300 font-bold line-through">฿{{
                    Number(product.sellPrice * 1.15).toLocaleString() }}</span>
                </div>

                <button @click="addToCart(product)"
                  class="w-full bg-black text-white py-3 rounded-md text-[10px] font-black uppercase tracking-[0.2em] hover:bg-blue-600 transition-all active:scale-[0.98]">
                  เพิ่มลงตะกร้า
                </button>
              </div>
            </div>
          </div>

          <div v-if="filteredProducts.length > 8" class="mt-16 text-center">
            <button @click="showAll = !showAll"
              class="px-12 py-3.5 border-2 border-slate-900 text-slate-900 font-black text-[10px] uppercase tracking-[0.3em] rounded-xl hover:bg-black hover:text-white backdrop-blur-md transition-all active:scale-95 shadow-xl shadow-slate-100">
              {{ showAll ? 'แสดงน้อยลง' : 'แสดงทั้งหมด' }}
            </button>
          </div>
        </div>
      </section>

      <!-- ... (Rest of content) -->

      <!-- Quality Assurance Section (Compact) -->
      <section id="quality" class="section-animate" v-intersection>
        <div class="grid lg:grid-cols-2 gap-12 items-center border-t border-slate-100 pt-20">
          <div class="bg-black text-white p-10 lg:p-16 rounded-[3rem] relative overflow-hidden">
            <div class="absolute top-0 right-0 w-64 h-64 bg-blue-600/20 rounded-full blur-[80px]"></div>
            <span class="text-[9px] font-black text-blue-400 uppercase tracking-[0.5em] mb-8 block">DIAGNOSTIC
              EXCELLENCE</span>
            <h2 class="text-4xl lg:text-5xl font-[1000] mb-10 leading-none tracking-tighter">
              BEYOND <br />
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
            <h2 class="text-4xl font-black text-slate-900 tracking-tighter leading-tight mb-6 h-32">
              <span class="typing-text">{{ typedText }}</span>
              <span class="cursor">|</span>
            </h2>
            <p class="text-base text-slate-500 font-medium leading-relaxed mb-10">
              เรายึดถือมาตรฐานสูงสุดในการส่งมอบสมาร์ทโฟนมือสองคุณภาพดีเยี่ยม
              เพื่อให้คุณมั่นใจว่าทุกการใช้งานจะเป็นไปอย่างปลอดภัยไร้กังวล
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
      <section id="faq" class="section-animate py-16 border-t border-slate-100" v-intersection>
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-slate-900 tracking-tight uppercase">คำถามที่พบบ่อย</h2>
        </div>
        <div class="max-w-3xl mx-auto space-y-4">
          <div v-for="(faq, i) in [
            { q: 'สินค้าของ VIP Phone รับประกันอย่างไร?', a: 'สินค้าทุกเครื่องรับประกันการใช้งาน 30 วันเต็ม หากพบปัญหาปกติ สามารถส่งเคลมได้ทันทีโดยไม่มีค่าใช้จ่าย' },
            { q: 'สามารถขอดูสภาพเครื่องจริงก่อนสั่งซื้อได้ไหม?', a: 'ลูกค้าสามารถดูวิดีโอ 360 องศา และรูปถ่ายรายละเอียดทุกมุมของเครื่องได้ในหน้าสินค้าครับ' }
          ]" :key="i"
            class="p-6 bg-[#F8FAFC] rounded-2xl border border-slate-100 group hover:border-blue-400 hover:bg-white transition-all duration-300">
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
      <div
        class="absolute bottom-0 left-1/2 -translate-x-1/2 text-[10vw] font-[1000] text-white/[0.03] whitespace-nowrap pointer-events-none tracking-tighter select-none">
        VIP PHONE</div>
      <div class="max-w-7xl mx-auto px-6 text-center relative z-10">
        <div class="flex items-center justify-center space-x-2 mb-8">
          <h1 class="text-xl font-black tracking-tighter uppercase italic">VIP<span class="text-blue-500">PHONE</span>
          </h1>
        </div>
        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-[0.4em]">
          &copy; 2026 VIP Phone. สงวนลิขสิทธิ์ตามกฎหมาย
        </p>
      </div>
    </footer>
    <CartModal :isOpen="isCartOpen" @close="isCartOpen = false" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, defineComponent, h } from 'vue';
import axios from 'axios';
import { ShoppingBag, ArrowRight, MoreHorizontal, Check, Menu, LogOut, Search, X } from 'lucide-vue-next';
import { useCartStore } from '../store/cart';
import { useAuthStore } from '../store/auth';
import CartModal from '../components/CartModal.vue';
import Skeleton from '../components/Skeleton.vue';
import { useRouter } from 'vue-router';
import { getApiBasePath, assetUrl } from '../config/api';
import { useToast } from 'vue-toastification';

const isCartOpen = ref(false);
const cartStore = useCartStore();
const authStore = useAuthStore();
const toast = useToast();
const availableProducts = ref([]);
const loading = ref(true);
const selectedBrand = ref(null);
const showAll = ref(false);
const searchQuery = ref('');
const router = useRouter();

const addToCart = (product) => {
  try {
    cartStore.addItem(product);
    isCartOpen.value = true;
  } catch (error) {
    toast.warning(error.message);
    router.push('/login');
  }
};

const brandOptions = [
  { name: 'Apple', imageUrl: 'https://cdn.simpleicons.org/apple/0f172a' },
  { name: 'Samsung', imageUrl: 'https://cdn.simpleicons.org/samsung/0f172a' },
  { name: 'Google', imageUrl: 'https://cdn.simpleicons.org/google/0f172a' },
  { name: 'OnePlus', imageUrl: 'https://cdn.simpleicons.org/oneplus/0f172a' },
  { name: 'Xiaomi', imageUrl: 'https://cdn.simpleicons.org/xiaomi/0f172a' },
  { name: 'ทั้งหมด', icon: MoreHorizontal }
];

const fetchAvailableProducts = async () => {
  try {
    const response = await axios.get(`${getApiBasePath()}/products`);
    availableProducts.value = response.data.filter(p => p.status === 'available');
  } catch (error) {
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

const filteredProducts = computed(() => {
  let result = availableProducts.value;
  if (selectedBrand.value) {
    result = result.filter(p => p.brand.toLowerCase() === selectedBrand.value.toLowerCase());
  }
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.trim().toLowerCase();
    result = result.filter(p =>
      (p.model && p.model.toLowerCase().includes(q)) ||
      (p.brand && p.brand.toLowerCase().includes(q)) ||
      (p.storage && p.storage.toLowerCase().includes(q)) ||
      (p.color && p.color.toLowerCase().includes(q))
    );
  }
  return result;
});

const displayedProducts = computed(() => {
  return showAll.value ? filteredProducts.value : filteredProducts.value.slice(0, 8);
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


const videoPlayer = ref(null)

const typedText = ref('');
const fullText = 'ทุกเครื่องผ่านการตรวจสอบ อย่างละเอียดถี่ถ้วน โดยผู้เชี่ยวชาญ.';

const startTyping = () => {
  let i = 0;
  const timer = setInterval(() => {
    typedText.value += fullText[i];
    i++;
    if (i === fullText.length) clearInterval(timer);
  }, 50); // เปลี่ยนจาก 100 เป็น 50ms
};

const vIntersection = {
  mounted(el) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          el.classList.add('visible');
          if (el.querySelector('.typing-text')) startTyping();
          observer.unobserve(el);
        }
      });
    }, { threshold: 0.1 });
    observer.observe(el);
  }
};

onMounted(() => {
  if (videoPlayer.value) {
    // บังคับให้ Muted อีกรอบเพื่อความชัวร์
    videoPlayer.value.muted = true
    // สั่งให้เล่น
    videoPlayer.value.play().catch(error => {
      console.error("Video play failed:", error)
    })
  }
})
</script>

<style scoped>
.font-sans {
  font-family: 'Tahoma', 'Sarabun', sans-serif;
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fade-in-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 1s ease-out forwards;
}

.animate-fade-in-up {
  animation: fade-in-up 0.8s cubic-bezier(0.2, 0, 0, 1) forwards;
}

.delay-100 {
  animation-delay: 0.1s;
}

.delay-200 {
  animation-delay: 0.2s;
}

/* Hover reveal animation */
.hover-reveal {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.hover-reveal:hover {
  transform: translateY(-5px);
}

@keyframes blink {
  50% { opacity: 0; }
}

.cursor {
  animation: blink 1s step-end infinite;
  color: #2563EB;
}
</style>
