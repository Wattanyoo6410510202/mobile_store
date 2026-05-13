<template>
  <div class="min-h-screen bg-slate-50 font-sans">
    <!-- Navbar -->
    <nav class="sticky top-0 bg-white/80 backdrop-blur-md border-b border-slate-100 z-50">
      <div class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
        <h1 class="text-2xl font-black text-slate-900 tracking-tight">VIP<span class="text-blue-600">Phone</span></h1>
        <div class="hidden md:flex space-x-8 text-sm font-bold text-slate-600">
          <a href="#about" class="hover:text-blue-600 transition">เกี่ยวกับเรา</a>
          <a href="#warranty" class="hover:text-blue-600 transition">นโยบายประกัน</a>
          <a href="#contact" class="hover:text-blue-600 transition">ติดต่อ</a>
        </div>
        <router-link to="/login" class="px-5 py-2.5 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-slate-800 transition">
          เข้าสู่ระบบพนักงาน
        </router-link>
      </div>
    </nav>

    <!-- Hero Section -->
    <header class="relative bg-white pt-20 pb-32 overflow-hidden">
      <div class="max-w-4xl mx-auto text-center px-6 relative z-10">
        <span class="px-4 py-1.5 bg-blue-50 text-blue-600 text-[10px] font-bold uppercase tracking-widest rounded-full">เปิดให้บริการทุกวัน</span>
        <h2 class="text-5xl lg:text-7xl font-black text-slate-900 mt-6 leading-tight">มือถือสภาพนางฟ้า <br/><span class="text-blue-600">ราคามิตรภาพ</span></h2>
        <p class="text-lg text-slate-500 mt-8 max-w-2xl mx-auto">คัดสรรเครื่องเกรด A ผ่านการทดสอบคุณภาพทุกเครื่อง พร้อมประกันร้านที่เชื่อถือได้</p>
        <div class="mt-10 flex justify-center space-x-4">
          <a href="#contact" class="px-8 py-4 bg-blue-600 text-white font-bold rounded-2xl shadow-lg shadow-blue-200 hover:bg-blue-700 transition">สอบถามสินค้า</a>
        </div>
      </div>
      <!-- Decorative -->
      <div class="absolute bottom-0 left-0 w-full h-1/2 bg-gradient-to-t from-slate-50 to-transparent"></div>
    </header>

    <!-- Services -->
    <section id="about" class="py-20 max-w-6xl mx-auto px-6 grid md:grid-cols-3 gap-8">
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
        <div class="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center text-blue-600 mb-6">
          <CheckCircle class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-slate-800">เครื่องเกรด A</h3>
        <p class="text-sm text-slate-500 mt-2">ผ่านการตรวจสอบมากกว่า 20 จุด มั่นใจได้ในคุณภาพ</p>
      </div>
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
        <div class="w-12 h-12 bg-emerald-50 rounded-2xl flex items-center justify-center text-emerald-600 mb-6">
          <ShieldCheck class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-slate-800">ประกันยาวนาน</h3>
        <p class="text-sm text-slate-500 mt-2">อุ่นใจด้วยการรับประกันคุณภาพจากทางร้าน VIP Phone</p>
      </div>
      <div class="bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
        <div class="w-12 h-12 bg-indigo-50 rounded-2xl flex items-center justify-center text-indigo-600 mb-6">
          <Headphones class="w-6 h-6" />
        </div>
        <h3 class="text-lg font-bold text-slate-800">ดูแลหลังการขาย</h3>
        <p class="text-sm text-slate-500 mt-2">ให้คำปรึกษาและแก้ไขปัญหาการใช้งานตลอดอายุประกัน</p>
      </div>
    </section>

    <!-- Product Showcase -->
    <section id="products" class="py-20 max-w-6xl mx-auto px-6">
      <div class="flex items-center justify-between mb-10">
        <h2 class="text-3xl font-black text-slate-900 tracking-tight">สินค้าแนะนำ</h2>
        <a href="#contact" class="text-sm font-bold text-blue-600 hover:underline">ดูสินค้าทั้งหมด</a>
      </div>
      
      <div class="flex gap-8">
        <!-- Sidebar Filter -->
        <aside class="w-64 flex-shrink-0 hidden md:block">
          <div class="bg-white rounded-2xl p-6 border border-slate-100 shadow-sm sticky top-24">
             <h3 class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-4">ยี่ห้อ (Brand)</h3>
             <ul class="space-y-2">
                <li>
                  <button @click="selectedBrand = null" :class="selectedBrand === null ? 'text-blue-600 font-bold' : 'text-slate-600'" class="text-sm hover:text-blue-600 transition">ทั้งหมด</button>
                </li>
                <li v-for="brand in uniqueBrands" :key="brand">
                  <button @click="selectedBrand = brand" :class="selectedBrand === brand ? 'text-blue-600 font-bold' : 'text-slate-600'" class="text-sm hover:text-blue-600 transition">{{ brand }}</button>
                </li>
             </ul>
          </div>
        </aside>

        <!-- Product Grid -->
        <div class="flex-1">
          <div v-if="loading" class="text-center text-slate-500 py-20">กำลังโหลดสินค้า...</div>
          <div v-else-if="filteredProducts.length === 0" class="text-center text-slate-500 py-20">ไม่พบสินค้าพร้อมขายในขณะนี้</div>
          <div v-else class="grid grid-cols-2 lg:grid-cols-3 gap-6">
            <div v-for="product in filteredProducts" :key="product.id" class="bg-white rounded-2xl p-3 border border-slate-100 shadow-sm hover:shadow-lg transition-all duration-300">
              <div class="relative overflow-hidden rounded-xl mb-3 bg-slate-100 aspect-square">
                 <img v-if="product.thumbnail" :src="`http://localhost:5000${product.thumbnail}`" class="w-full h-full object-cover" />
                 <div v-else class="w-full h-full flex items-center justify-center text-slate-400">
                    <Smartphone class="w-8 h-8" />
                 </div>
              </div>
              <div class="px-1">
                <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-0.5">{{ product.brand }}</p>
                <p class="text-sm font-bold text-slate-900 truncate mb-2">{{ product.model }}</p>
                <p class="text-sm font-black text-slate-900 tracking-tight">฿{{ Number(product.sellPrice).toLocaleString() }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Warranty Footer -->
    <section id="warranty" class="py-20 bg-slate-900 text-white text-center">
      <div class="max-w-2xl mx-auto px-6">
        <h2 class="text-3xl font-bold mb-6">นโยบายการรับประกัน</h2>
        <p class="text-slate-400 text-sm">เราใส่ใจทุกรายละเอียด เครื่องทุกเครื่องได้รับใบรับประกันจากระบบมาตรฐาน VIP Phone เพื่อให้คุณมั่นใจว่าเครื่องที่คุณซื้อไป คือเครื่องที่ตรวจสอบแล้วว่าปลอดภัย 100%</p>
      </div>
    </section>

    <!-- Footer -->
    <footer id="contact" class="py-10 text-center text-slate-400 text-xs font-medium">
      <p>&copy; 2026 VIP Phone. All rights reserved.</p>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import { CheckCircle, ShieldCheck, Headphones, Smartphone } from 'lucide-vue-next';

const availableProducts = ref([]);
const loading = ref(true);
const selectedBrand = ref(null);

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

const uniqueBrands = computed(() => {
  const brands = availableProducts.value.map(p => p.brand).filter(Boolean);
  return [...new Set(brands)].sort();
});

const filteredProducts = computed(() => {
  if (!selectedBrand.value) return availableProducts.value;
  return availableProducts.value.filter(p => p.brand === selectedBrand.value);
});

onMounted(fetchAvailableProducts);
</script>
