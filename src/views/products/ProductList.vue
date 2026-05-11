<template>
  <div class="space-y-4">
    <!-- Header with Search and Actions -->
    <div class="card bg-white p-6 rounded-2xl border border-slate-200 shadow-sm">
      <div class="flex flex-col sm:flex-row justify-between items-center gap-4 mb-6">
        <h2 class="text-xl font-black text-slate-800 tracking-tight">รายการสินค้า VIP Phone</h2>
        <div class="flex items-center space-x-3 w-full sm:w-auto">
          <input 
            v-model="searchQuery" 
            placeholder="ค้นหา..." 
            class="px-4 py-2 border rounded-xl w-full sm:w-64"
          />
          <button @click="exportToExcel" class="p-3 bg-emerald-100 text-emerald-600 rounded-xl hover:bg-emerald-200 transition" title="Export Excel">
            <Download class="w-6 h-6" />
          </button>
          <router-link to="/admin/products/scan" class="p-3 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200 transition">
            <QrCode class="w-6 h-6" />
          </router-link>
          <router-link to="/admin/products/add" class="flex items-center space-x-2 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition font-bold shadow-lg shadow-blue-200">
            <Plus class="w-5 h-5" />
            <span>เพิ่มสินค้าใหม่</span>
          </router-link>
        </div>
      </div>

      <!-- Custom Table -->
      <div class="overflow-x-auto">
        <table class="w-full text-left text-sm text-slate-600">
          <thead class="bg-slate-50 text-slate-700 uppercase text-xs font-bold">
            <tr>
              <th class="px-6 py-4">รูปปก</th>
              <th class="px-6 py-4">ยี่ห้อ</th>
              <th class="px-6 py-4">รุ่น</th>
              <th class="px-6 py-4">IMEI</th>
              <th class="px-6 py-4">วันที่เพิ่ม</th>
              <th class="px-6 py-4">ราคา</th>
              <th class="px-6 py-4">สถานะ</th>
              <th class="px-6 py-4">จัดการ</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">
            <tr v-for="product in filteredProducts" :key="product.id" class="hover:bg-slate-50 transition">
              <td class="px-6 py-4">
                <img v-if="product.thumbnail" :src="`http://localhost:5000${product.thumbnail}`" class="w-12 h-12 object-cover rounded-lg border" />
                <div v-else class="w-12 h-12 bg-slate-100 rounded-lg flex items-center justify-center text-slate-400">
                  <Smartphone class="w-6 h-6" />
                </div>
              </td>
              <td class="px-6 py-4 font-medium text-slate-800">{{ product.brand }}</td>
              <td class="px-6 py-4">{{ product.model }}</td>
              <td class="px-6 py-4">{{ product.imei1 }}</td>
              <td class="px-6 py-4 text-xs">{{ formatDate(product.createdAt) }}</td>
              <td class="px-6 py-4 font-bold text-slate-800">฿{{ Number(product.sellPrice).toLocaleString() }}</td>
              <td class="px-6 py-4">
                <span :class="statusClass(product.status)" class="px-3 py-1 rounded-full text-[10px] font-bold uppercase">
                  {{ translateStatus(product.status) }}
                </span>
              </td>
              <td class="px-6 py-4">
                <div class="flex space-x-2">
                    <button @click="printWarranty(product)" class="p-2 text-slate-400 hover:text-emerald-600 transition" title="พิมพ์ใบประกัน"><FileText class="w-4 h-4" /></button>
                    <button @click="editProduct(product.id)" class="p-2 text-slate-400 hover:text-blue-600 transition" title="แก้ไข"><Edit3 class="w-4 h-4" /></button>
                    <button @click="deleteProduct(product.id)" class="p-2 text-slate-400 hover:text-red-600 transition" title="ลบ"><Trash2 class="w-4 h-4" /></button>
                </div>
              </td>
            </tr>
            <tr v-if="filteredProducts.length === 0">
                <td colspan="8" class="px-6 py-10 text-center text-slate-400">ไม่พบข้อมูลสินค้า</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';
import { useAuthStore } from '../../store/auth';
import { useRouter } from 'vue-router';
import { 
  Search, Plus, QrCode, Smartphone, Edit3, FileText, Trash2, Download
} from 'lucide-vue-next';
import * as XLSX from 'xlsx';
import { generateWarrantyReceipt } from '../../utils/pdfGenerator';

const router = useRouter();
const authStore = useAuthStore();
const products = ref([]);
const storeSettings = ref({});
const searchQuery = ref('');

const filteredProducts = computed(() => {
    return products.value.filter(p => 
        (p.brand?.toLowerCase() || '').includes(searchQuery.value.toLowerCase()) || 
        (p.model?.toLowerCase() || '').includes(searchQuery.value.toLowerCase()) ||
        (p.imei1 || '').includes(searchQuery.value)
    );
});

const deleteProduct = async (id) => {
  if (confirm('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?')) {
    try {
      await axios.delete(`http://localhost:5000/api/products/${id}`, {
        headers: { Authorization: `Bearer ${authStore.token}` }
      });
      await fetchProducts();
    } catch (error) {
      console.error('Failed to delete product', error);
      alert('เกิดข้อผิดพลาดในการลบสินค้า');
    }
  }
};

const editProduct = (id) => {
  router.push(`/admin/products/edit/${id}`);
};

const fetchProducts = async () => {
  console.log('Fetching products, token:', authStore.token);
  if (!authStore.token) {
    console.error('No Auth Token found!');
    return;
  }
  try {
    const response = await axios.get('http://localhost:5000/api/products', {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    console.log('API Response:', response.data);
    products.value = response.data;
  } catch (error) {
    console.error('Failed to fetch products:', error);
    alert('โหลดข้อมูลล้มเหลว: ' + error.message);
  }
};

const fetchSettings = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/settings', {
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
  const map = { available: 'พร้อมขาย', sold: 'ขายแล้ว', reserved: 'จองแล้ว', repair: 'ส่งซ่อม' };
  return map[status] || status;
};

const statusClass = (status) => {
  const map = {
    available: 'bg-emerald-50 text-emerald-600',
    sold: 'bg-slate-100 text-slate-500',
    reserved: 'bg-amber-50 text-amber-600',
    repair: 'bg-red-50 text-red-600'
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
    const data = filteredProducts.value.map(p => ({
        'ยี่ห้อ': p.brand,
        'รุ่น': p.model,
        'IMEI': p.imei1,
        'ราคา': p.sellPrice,
        'สถานะ': translateStatus(p.status),
        'วันที่เพิ่ม': formatDate(p.createdAt)
    }));

    const ws = XLSX.utils.json_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Products");
    XLSX.writeFile(wb, "products_list.xlsx");
};

onMounted(() => {
    fetchProducts();
    fetchSettings();
});
</script>
