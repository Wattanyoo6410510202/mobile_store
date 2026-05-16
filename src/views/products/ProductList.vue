<template>
  <div class="space-y-4">
    <!-- Header with Search and Actions -->
    <div class="gh-surface gh-card p-4 mb-6">
      <div class="flex flex-col sm:flex-row justify-between items-center gap-4">
        <div class="flex items-center space-x-3 w-full">
          <input 
            v-model="searchQuery" 
            placeholder="ค้นหา..." 
            class="gh-input w-full"
          />
          <button @click="viewMode = viewMode === 'table' ? 'card' : 'table'" class="gh-btn" title="สลับมุมมอง">
            <LayoutGrid v-if="viewMode === 'table'" class="w-4 h-4" />
            <Table v-else class="w-4 h-4" />
          </button>
          <button @click="exportToExcel" class="gh-btn" title="Export Excel">
            <Download class="w-4 h-4" />
          </button>
          <router-link to="/admin/products/scan" class="gh-btn" title="สแกน QR">
            <QrCode class="w-4 h-4" />
          </router-link>
          <router-link to="/admin/products/add" class="gh-btn gh-btn-primary px-4">
            <Plus class="w-5 h-5" />
            <span>เพิ่ม</span>
          </router-link>
        </div>
      </div>

      <!-- Table View -->
      <div v-if="viewMode === 'table'" class="mt-6 overflow-x-auto border rounded-lg" :style="{ borderColor: 'var(--gh-border-default)' }">
        <table class="w-full text-left text-sm text-slate-700">
          <thead class="text-slate-600 uppercase text-xs font-bold" :style="{ background: 'var(--gh-canvas-subtle)', borderBottom: '1px solid var(--gh-border-default)' }">
            <tr>
              <th v-for="col in columns" :key="col.key" class="px-6 py-4 cursor-pointer hover:text-slate-900" @click="sortBy(col.key)">
                <div class="flex items-center gap-1">
                  {{ col.label }}
                  <ChevronDown class="w-3 h-3" v-if="sortKey === col.key" />
                </div>
              </th>
            </tr>
          </thead>
          <tbody class="divide-y" :style="{ borderColor: 'var(--gh-border-muted)' }">
            <template v-if="isLoading">
              <tr v-for="n in 5" :key="n">
                <td colspan="9" class="p-2"><Skeleton /></td>
              </tr>
            </template>
            <template v-else>
              <tr v-for="product in sortedProducts" :key="product.id" class="hover:bg-[var(--gh-canvas-subtle)] transition">
                <td class="px-6 py-4">
                  <img v-if="product.thumbnail" :src="assetUrl(product.thumbnail)" loading="lazy" class="w-12 h-12 object-cover rounded-lg border" />
                  <div v-else class="w-12 h-12 bg-slate-100 rounded-lg flex items-center justify-center text-slate-400">
                    <Smartphone class="w-6 h-6" />
                  </div>
                </td>
                <td class="px-6 py-4 font-medium text-slate-800">{{ product.brand }}</td>
                <td class="px-6 py-4">{{ product.model }}</td>
                <td class="px-6 py-4 font-mono">{{ product.imei1 }}</td>
                <td class="px-6 py-4 text-xs">{{ formatDate(product.createdAt) }}</td>
                <td class="px-6 py-4 text-xs">{{ formatDate(product.warrantyEndDate) }}</td>
                <td class="px-6 py-4 font-bold text-slate-800">฿{{ Number(product.sellPrice).toLocaleString() }}</td>
                <td class="px-6 py-4">
                  <select 
                    :value="product.status" 
                    @change="e => updateStatus(product.id, e.target.value)"
                    :class="statusClass(product.status)"
                    class="gh-input !py-1 !px-2 !text-[10px] font-[1000] uppercase rounded-full border-none cursor-pointer focus:ring-1 focus:ring-blue-400 appearance-none text-center"
                  >
                    <option value="available">พร้อมขาย</option>
                    <option value="sold">ขายแล้ว</option>
                    <option value="reserved">จองแล้ว</option>
                    <option value="repair">ส่งซ่อม</option>
                    <option value="import">รอนำเข้า</option>
                  </select>
                </td>
                <td class="px-6 py-4">
                  <div class="flex space-x-1">
                      <button @click="showCode('qr', product.imei1)" class="p-1.5 text-slate-400 hover:text-indigo-600 transition" title="QR Code"><QrCode class="w-4 h-4" /></button>
                      <button @click="showCode('barcode', product.imei1)" class="p-1.5 text-slate-400 hover:text-indigo-600 transition" title="Barcode"><Barcode class="w-4 h-4" /></button>
                      <button @click="printWarranty(product)" class="p-1.5 text-slate-400 hover:text-emerald-600 transition" title="พิมพ์ใบประกัน"><FileText class="w-4 h-4" /></button>
                      <button @click="editProduct(product.id)" class="p-1.5 text-slate-400 hover:text-blue-600 transition" title="แก้ไข"><Edit3 class="w-4 h-4" /></button>
                      <button @click="deleteProduct(product.id)" class="p-1.5 text-slate-400 hover:text-red-600 transition" title="ลบ"><Trash2 class="w-4 h-4" /></button>
                  </div>
                </td>
              </tr>
            </template>
          </tbody>
        </table>
      </div>

      <!-- Card View -->
      <div v-else class="mt-6 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <template v-if="isLoading">
            <Skeleton v-for="n in 8" :key="n" />
          </template>
          <template v-else>
            <div v-for="product in sortedProducts" :key="product.id" class="group bg-white rounded-2xl p-5 border border-slate-100 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.08)] hover:shadow-[0_8px_30px_-6px_rgba(0,0,0,0.12)] transition-all duration-300 flex flex-col gap-4">
                <div class="flex items-start gap-4">
                    <div class="relative">
                      <img v-if="product.thumbnail" :src="assetUrl(product.thumbnail)" loading="lazy" class="w-20 h-20 object-cover rounded-xl border border-slate-100" />
                      <div v-else class="w-20 h-20 bg-slate-50 rounded-xl flex items-center justify-center text-slate-300 border border-slate-100">
                          <Smartphone class="w-8 h-8" />
                      </div>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="font-bold text-slate-900 truncate">{{ product.brand }}</p>
                        <p class="text-sm text-slate-600 truncate">{{ product.model }}</p>
                        <p class="text-[11px] text-slate-400 font-mono mt-1 bg-slate-50 inline-block px-1.5 py-0.5 rounded">IMEI: {{ product.imei1 }}</p>
                        <p class="text-[10px] text-slate-400 mt-1.5">เพิ่มเมื่อ: {{ formatDate(product.createdAt) }}</p>
                    </div>
                </div>
                
                <div class="flex items-center justify-between border-t border-slate-50 pt-4">
                  <p class="text-xl font-black text-slate-900 tracking-tight">฿{{ Number(product.sellPrice).toLocaleString() }}</p>
                  <div class="relative flex items-center group">
                    <select 
                      :value="product.status" 
                      @change="e => updateStatus(product.id, e.target.value)"
                      :class="statusClass(product.status)"
                      class="appearance-none pl-4 pr-9 py-2 text-[10px] font-black uppercase rounded-2xl border-none cursor-pointer focus:ring-4 focus:ring-blue-500/10 transition-all shadow-sm group-hover:shadow-md"
                    >
                      <option value="available">พร้อมขาย</option>
                      <option value="sold">ขายแล้ว</option>
                      <option value="reserved">จองแล้ว</option>
                      <option value="repair">ส่งซ่อม</option>
                      <option value="import">รอนำเข้า</option>
                    </select>
                    <ChevronDown class="w-3.5 h-3.5 absolute right-3 pointer-events-none opacity-50 group-hover:opacity-100 transition-opacity" />
                  </div>
                </div>

                <div class="flex items-center justify-end border-t border-slate-50 pt-3 mt-auto">
                  <div class="flex space-x-1">
                      <button @click="showCode('qr', product.imei1)" class="p-2 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors" title="QR Code"><QrCode class="w-4 h-4" /></button>
                      <button @click="showCode('barcode', product.imei1)" class="p-2 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors" title="Barcode"><Barcode class="w-4 h-4" /></button>
                      <button @click="printWarranty(product)" class="p-2 text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 rounded-lg transition-colors" title="พิมพ์ใบประกัน"><FileText class="w-4 h-4" /></button>
                      <button @click="editProduct(product.id)" class="p-2 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors" title="แก้ไข"><Edit3 class="w-4 h-4" /></button>
                      <button @click="deleteProduct(product.id)" class="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors" title="ลบ"><Trash2 class="w-4 h-4" /></button>
                  </div>
                </div>
            </div>
          </template>
      </div>
    </div>

    <!-- Code Modal -->
    <div v-if="showCodeModal" class="fixed inset-0 z-[110] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm" @click.self="showCodeModal = false">
      <div class="bg-white rounded-2xl shadow-2xl max-w-sm w-full p-6 animate-in zoom-in duration-300">
        <div class="flex items-center justify-between mb-6">
          <h3 class="font-black text-slate-900 uppercase tracking-tight">{{ codeModalTitle }}</h3>
          <button @click="showCodeModal = false" class="text-slate-400 hover:text-black transition-colors p-1"><X class="w-5 h-5" /></button>
        </div>
        <div class="flex flex-col items-center gap-6">
          <div class="bg-slate-50 p-4 rounded-xl border border-slate-100 shadow-inner">
            <img :src="codeUrl" class="max-w-full h-auto rounded-lg mix-blend-multiply" />
          </div>
          <div class="flex gap-2 w-full">
            <button @click="downloadCode" class="flex-1 py-3 bg-indigo-600 text-white font-black text-xs uppercase tracking-widest rounded-xl hover:bg-indigo-700 transition-all flex items-center justify-center gap-2">
              <Download class="w-4 h-4" /> ดาวน์โหลด
            </button>
            <button @click="showCodeModal = false" class="flex-1 py-3 bg-black text-white font-black text-xs uppercase tracking-widest rounded-xl hover:bg-slate-800 transition-all">ปิด</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import axios from 'axios';
import { useAuthStore } from '../../store/auth';
import { useRouter, useRoute } from 'vue-router';
import { 
  Search, Plus, QrCode, Smartphone, Edit3, FileText, Trash2, Download, Table, LayoutGrid, ChevronDown, Barcode, X
} from 'lucide-vue-next';
import * as XLSX from 'xlsx';
import { generateWarrantyReceipt } from '../../utils/pdfGenerator';
import { getApiBasePath, assetUrl } from '../../config/api';
import { useToast } from 'vue-toastification';
import Skeleton from '../../components/Skeleton.vue';

const router = useRouter();
const route = useRoute();
const authStore = useAuthStore();
const toast = useToast();
const products = ref([]);
const storeSettings = ref({});
const searchQuery = ref('');
const viewMode = ref('table');
const sortKey = ref('');
const sortOrder = ref(1);
const isLoading = ref(true);
const showCodeModal = ref(false);
const codeModalTitle = ref('');
const codeUrl = ref('');

const showCode = (type, imei) => {
  if (!imei) {
    toast.error('ไม่มีเลข IMEI สำหรับสินค้านี้');
    return;
  }
  if (type === 'qr') {
    codeModalTitle.value = 'QR Code - ' + imei;
    codeUrl.value = `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${imei}`;
  } else {
    codeModalTitle.value = 'Barcode - ' + imei;
    codeUrl.value = `https://bwipjs-api.metafloor.com/?bcid=code128&text=${imei}&scale=3&rotate=N&includetext`;
  }
  showCodeModal.value = true;
};

const downloadCode = async () => {
  try {
    const response = await fetch(codeUrl.value);
    const blob = await response.blob();
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `${codeModalTitle.value.replace(/\s+/g, '_')}.png`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    window.URL.revokeObjectURL(url);
  } catch (error) {
    toast.error('ดาวน์โหลดรูปภาพไม่สำเร็จ');
  }
};

const columns = [
    { key: 'thumbnail', label: 'รูปปก' },
    { key: 'brand', label: 'ยี่ห้อ' },
    { key: 'model', label: 'รุ่น' },
    { key: 'imei1', label: 'IMEI' },
    { key: 'createdAt', label: 'วันที่เพิ่ม' },
    { key: 'warrantyEndDate', label: 'วันหมดประกัน' },
    { key: 'sellPrice', label: 'ราคา' },
    { key: 'status', label: 'สถานะ' },
    { key: 'actions', label: 'จัดการ' }
];

onMounted(() => {
    fetchProducts();
    fetchSettings();
});

watch(
  () => route.path,
  () => {
    if (route.name === 'ProductList') {
        fetchProducts();
        fetchSettings();
    }
  }
);

const sortBy = (key) => {
    if (key === 'actions' || key === 'thumbnail') return;
    if (sortKey.value === key) sortOrder.value *= -1;
    else {
        sortKey.value = key;
        sortOrder.value = 1;
    }
};

const sortedProducts = computed(() => {
    const list = products.value.filter(p => 
        (p.brand?.toLowerCase() || '').includes(searchQuery.value.toLowerCase()) || 
        (p.model?.toLowerCase() || '').includes(searchQuery.value.toLowerCase()) ||
        (p.imei1 || '').includes(searchQuery.value)
    );
    if (!sortKey.value) return list;
    return list.sort((a, b) => {
        let valA = a[sortKey.value];
        let valB = b[sortKey.value];
        if (typeof valA === 'string') return valA.localeCompare(valB) * sortOrder.value;
        return (valA - valB) * sortOrder.value;
    });
});

const deleteProduct = async (id) => {
  if (confirm('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?')) {
    try {
      await axios.delete(`${getApiBasePath()}/products/${id}`, {
        headers: { Authorization: `Bearer ${authStore.token}` }
      });
      await fetchProducts();
      toast.success('ลบสินค้าสำเร็จ');
    } catch (error) {
      console.error('Failed to delete product', error);
      toast.error('เกิดข้อผิดพลาดในการลบสินค้า');
    }
  }
};

const editProduct = (id) => {
  router.push(`/admin/products/edit/${id}`);
};

const updateStatus = async (id, newStatus) => {
  const confirmMsg = newStatus === 'sold' ? 'ยืนยันการปิดการขายสินค้านี้?' : `ยืนยันการเปลี่ยนสถานะเป็น "${translateStatus(newStatus)}"?`;
  if (confirm(confirmMsg)) {
    try {
      const updateData = { status: newStatus };
      if (newStatus === 'sold') {
        updateData.saleDate = new Date().toISOString();
      }
      await axios.put(`${getApiBasePath()}/products/${id}`, updateData, {
        headers: { Authorization: `Bearer ${authStore.token}` }
      });
      
      // อัปเดตข้อมูลภายใน Array เพื่อให้หน้าจอเปลี่ยนโดยไม่ต้องโหลดใหม่
      const product = products.value.find(p => p.id === id);
      if (product) {
        product.status = newStatus;
        if (newStatus === 'sold') product.saleDate = updateData.saleDate;
      }
      toast.success('อัปเดตสถานะสินค้าสำเร็จ');
    } catch (error) {
      console.error('Failed to update product status', error);
      toast.error('เกิดข้อผิดพลาดในการอัปเดตสถานะสินค้า');
    }
  }
};

const fetchProducts = async () => {
  isLoading.value = true;
  try {
    const response = await axios.get(`${getApiBasePath()}/products`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    products.value = response.data;
  } catch (error) {
    console.error('DEBUG: Failed to fetch products:', error);
  } finally {
    isLoading.value = false;
  }
};

const fetchSettings = async () => {
  try {
    const response = await axios.get(`${getApiBasePath()}/settings`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    storeSettings.value = response.data;
  } catch (error) {
    console.error('Failed to fetch settings', error);
  }
};

const printWarranty = (product) => {
  generateWarrantyReceipt(product, product.seller || {}, storeSettings.value);
};

const translateStatus = (status) => {
  const map = { available: 'พร้อมขาย', sold: 'ขายแล้ว', reserved: 'จองแล้ว', repair: 'ส่งซ่อม', import: 'รอนำเข้า' };
  return map[status] || status;
};

const statusClass = (status) => {
  const map = {
    available: 'bg-emerald-50 text-emerald-600',
    sold: 'bg-slate-100 text-slate-500',
    reserved: 'bg-amber-50 text-amber-600',
    repair: 'bg-red-50 text-red-600',
    import: 'bg-violet-50 text-violet-600'
  };
  return map[status] || 'bg-slate-100';
};

const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('th-TH', { 
        year: 'numeric', month: 'short', day: 'numeric' 
    });
};

const exportToExcel = () => {
    const data = sortedProducts.value.map(p => ({
        'ยี่ห้อ': p.brand,
        'รุ่น': p.model,
        'IMEI': p.imei1,
        'เลขซีเรียล': p.serialNumber,
        'สี': p.color,
        'ความจุ': p.storage,
        'ราคาทุน': p.purchasePrice,
        'ราคาขาย': p.sellPrice,
        'สถานะ': translateStatus(p.status),
        'วันที่เพิ่ม': formatDate(p.createdAt),
        'วันหมดประกัน': formatDate(p.warrantyEndDate),
        'สุขภาพแบตเตอรี่': p.batteryHealth + '%',
        'สภาพ': p.condition === 'new' ? 'มือ 1' : 'มือ 2'
    }));

    const ws = XLSX.utils.json_to_sheet(data);

    // Apply auto-filter
    const range = XLSX.utils.decode_range(ws['!ref']);
    ws['!autofilter'] = { ref: XLSX.utils.encode_range(range) };

    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Products");
    XLSX.writeFile(wb, "products_list.xlsx");
};
</script>
