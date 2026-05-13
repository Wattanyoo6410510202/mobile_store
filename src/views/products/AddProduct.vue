<template>
  <div class="max-w-4xl mx-auto pb-10">
    <!-- Full-screen Preview Modal -->
    <div v-if="previewUrl" class="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4" @click="previewUrl = null">
        <img :src="previewUrl" class="max-w-full max-h-full object-contain rounded-lg">
    </div>

    <!-- Header -->
    <div class="flex items-center space-x-3 mb-6">
      <button @click="$router.back()" class="gh-btn !p-2" aria-label="Back">
        <ArrowLeft class="w-5 h-5" />
      </button>
      <div>
        <h1 class="gh-h1">{{ isEdit ? 'แก้ไขข้อมูลสินค้า' : 'ลงทะเบียนเครื่องใหม่' }}</h1>
        <p class="gh-subtitle">ขั้นตอนที่ {{ currentStep }} จาก 4: {{ stepTitles[currentStep-1] }}</p>
      </div>
    </div>

    <!-- Step Progress Bar -->
    <div class="flex items-center space-x-2 mb-8 px-2">
      <div v-for="step in 4" :key="step" class="flex-1 h-1.5 rounded-full transition-colors" :class="step <= currentStep ? 'bg-blue-600' : 'bg-slate-200'"></div>
    </div>

    <form @submit.prevent="handleSubmit" enctype="multipart/form-data" class="space-y-4">
      
      <!-- Step 1: ข้อมูลตัวเครื่อง -->
      <div v-if="currentStep === 1" class="form-section animate-in fade-in slide-in-from-right-4 duration-300">
        <div class="section-header">
          <Smartphone class="w-5 h-5 text-blue-600" />
          <h3 class="text-sm font-bold text-slate-800">ข้อมูลสเปกตัวเครื่อง</h3>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="form-group">
            <label>ยี่ห้อ (Brand)</label>
            <input v-model="form.brand" type="text" required placeholder="เช่น Apple, Samsung">
          </div>
          <div class="form-group">
            <label>รุ่น (Model)</label>
            <input v-model="form.model" type="text" required placeholder="เช่น iPhone 15 Pro Max">
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="form-group">
              <label>สี (Color)</label>
              <input v-model="form.color" type="text" placeholder="Natural Titanium">
            </div>
            <div class="form-group">
              <label>ความจุ (Storage)</label>
              <input v-model="form.storage" type="text" placeholder="256GB">
            </div>
          </div>
          <div class="form-group">
            <label>เลข IMEI 1</label>
            <input v-model="form.imei1" type="text" required placeholder="เลข 15 หลัก">
          </div>
          <div class="form-group">
            <label>Serial Number</label>
            <input v-model="form.serialNumber" type="text" placeholder="เลขซีเรียล">
          </div>
          <div class="form-group">
            <label>สุขภาพแบตเตอรี่ (%)</label>
            <input v-model="form.batteryHealth" type="number" min="0" max="100">
          </div>
          <div class="form-group">
            <label>สถานะสินค้า (Condition)</label>
            <div class="flex space-x-4">
               <label class="flex items-center space-x-2">
                  <input type="radio" v-model="form.condition" value="new" class="text-blue-600">
                  <span>มือ 1</span>
               </label>
               <label class="flex items-center space-x-2">
                  <input type="radio" v-model="form.condition" value="used" class="text-blue-600">
                  <span>มือ 2</span>
               </label>
            </div>
          </div>
          <div class="form-group">
            <label>มีการรับประกัน</label>
            <div class="flex space-x-4">
               <label class="flex items-center space-x-2">
                  <input type="checkbox" v-model="form.hasWarranty" class="text-blue-600">
                  <span>ใช่</span>
               </label>
            </div>
          </div>
          <div v-if="form.hasWarranty" class="form-group">
            <label>ประเภทการประกัน</label>
            <select v-model="form.warrantyType" class="gh-input">
              <option value="shop">ประกันร้าน</option>
              <option value="manufacturer">ประกันศูนย์</option>
            </select>
          </div>
          <div v-if="form.hasWarranty" class="form-group">
            <label>วันสิ้นสุดประกัน</label>
            <input v-model="form.warrantyEndDate" type="date" class="gh-input">
          </div>
          <div class="form-group">
            <label>รูปปก (Thumbnail)</label>
            <div v-if="existingThumbnail" class="mb-2 relative w-20 h-20 group">
              <img :src="`http://localhost:5000${existingThumbnail}`" @click="previewUrl = `http://localhost:5000${existingThumbnail}`" class="w-20 h-20 object-cover rounded-lg border cursor-pointer">
              <button @click.prevent="deleteImageThumbnail" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition shadow-sm">
                <X class="w-4 h-4" />
              </button>
            </div>
            <input type="file" @change="e => form.thumbnail = e.target.files[0]" class="gh-input !p-2">
          </div>
        </div>
      </div>

      <!-- Step 2: สภาพและรายการตรวจสอบ -->
      <div v-if="currentStep === 2" class="form-section animate-in fade-in slide-in-from-right-4 duration-300">
        <div class="section-header">
          <ClipboardCheck class="w-5 h-5 text-emerald-600" />
          <h3 class="text-sm font-bold text-slate-800">รายการตรวจสอบสภาพ</h3>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="space-y-3">
             <label class="flex items-center space-x-3 p-3 rounded-xl border border-slate-100 hover:bg-slate-50 cursor-pointer transition">
                <input type="checkbox" v-model="form.isCloudLocked" class="w-4 h-4 rounded text-blue-600">
                <span class="text-sm font-medium text-slate-700">ติด iCloud / Google Lock</span>
             </label>
             <label class="flex items-center space-x-3 p-3 rounded-xl border border-slate-100 hover:bg-slate-50 cursor-pointer transition">
                <input type="checkbox" v-model="form.isResetReady" class="w-4 h-4 rounded text-blue-600">
                <span class="text-sm font-medium text-slate-700">ล้างเครื่องได้ปกติ (Reset)</span>
             </label>
             <label class="flex items-center space-x-3 p-3 rounded-xl border border-slate-100 hover:bg-slate-50 cursor-pointer transition">
                <input type="checkbox" v-model="form.isMdmLocked" class="w-4 h-4 rounded text-blue-600">
                <span class="text-sm font-medium text-slate-700">ติด MDM / Remote Manage</span>
             </label>
             <label class="flex items-center space-x-3 p-3 rounded-xl border border-slate-100 hover:bg-slate-50 cursor-pointer transition">
                <input type="checkbox" v-model="form.isPromoAttached" class="w-4 h-4 rounded text-blue-600">
                <span class="text-sm font-medium text-slate-700">เครื่องติดโปร / รายเดือน</span>
             </label>
             <label class="flex items-center space-x-3 p-3 rounded-xl border border-slate-100 hover:bg-slate-50 cursor-pointer transition">
                <input type="checkbox" v-model="form.isGenuineParts" class="w-4 h-4 rounded text-blue-600">
                <span class="text-sm font-medium text-slate-700">อะไหล่แท้ทั้งหมด</span>
             </label>
          </div>
          
          <div class="space-y-4">
            <div class="form-group">
              <label>ราคารับเข้า (ทุน)</label>
              <input v-model="form.purchasePrice" type="number" required placeholder="0.00">
            </div>
            <div class="form-group">
              <label>ราคาขาย</label>
              <input v-model="form.sellPrice" type="number" required placeholder="0.00" class="bg-blue-50/50">
            </div>
            <div class="form-group">
              <label>หมายเหตุสภาพเครื่อง</label>
              <textarea v-model="form.conditionNote" rows="3" class="form-input" placeholder="เช่น รอยขนแมวขอบเครื่อง..."></textarea>
            </div>
          </div>
        </div>

        <div class="mt-6 border-t pt-6">
          <label class="text-xs font-bold text-slate-500 mb-3 block">รูปถ่ายสภาพเครื่อง</label>
          <div class="p-8 border-2 border-dashed border-slate-200 rounded-2xl bg-slate-50 flex flex-col items-center justify-center text-center relative group hover:border-blue-400 transition-colors">
            <Camera class="w-6 h-6 text-slate-400 mb-2" />
            <p class="text-[10px] text-slate-500">อัปโหลดรูปหน้า, หลัง, และรอบเครื่อง</p>
            <input type="file" multiple @change="handleFileUpload" class="absolute inset-0 opacity-0 cursor-pointer">
          </div>
          
          <div v-if="existingImages.length > 0" class="mt-4">
             <p class="text-[10px] font-bold text-slate-400 mb-2 uppercase">รูปภาพที่มีอยู่เดิม</p>
             <div class="flex flex-wrap gap-2">
                <div v-for="img in existingImages" :key="img.id" class="relative w-16 h-16 rounded-lg overflow-hidden border group">
                   <img :src="`http://localhost:5000${img.imageUrl}`" @click="previewUrl = `http://localhost:5000${img.imageUrl}`" class="w-full h-full object-cover cursor-pointer">
                   <button @click.prevent="deleteImage(img.id)" class="absolute top-0 right-0 bg-red-500 text-white p-0.5 rounded-bl-lg opacity-0 group-hover:opacity-100 transition">
                      <X class="w-3 h-3" />
                   </button>
                </div>
             </div>
          </div>

          <div v-if="files.length > 0" class="mt-4 flex flex-wrap gap-2">
            <div v-for="(file, index) in files" :key="index" class="w-16 h-16 rounded-lg bg-white border border-slate-200 p-1 relative shadow-sm overflow-hidden text-center">
               <span class="text-[8px] text-slate-400 break-all">{{ file.name }}</span>
               <button @click.prevent="files.splice(index, 1)" class="absolute top-0 right-0 bg-red-500 text-white p-0.5 rounded-bl-lg"><X class="w-3 h-3" /></button>
            </div>
          </div>
        </div>
      </div>

      <!-- Step 3: ข้อมูลผู้ขาย -->
      <div v-if="currentStep === 3" class="form-section animate-in fade-in slide-in-from-right-4 duration-300">
        <div class="section-header">
          <UserCheck class="w-5 h-5 text-indigo-600" />
          <h3 class="text-sm font-bold text-slate-800">ข้อมูลผู้ขาย (เพื่อความปลอดภัย)</h3>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="space-y-4">
            <div class="form-group">
              <label>ชื่อ-นามสกุล ผู้ขาย</label>
              <input v-model="form.sellerFullName" type="text" placeholder="ระบุชื่อจริง">
            </div>
            <div class="form-group">
              <label>เบอร์โทรศัพท์</label>
              <input v-model="form.sellerPhone" type="text" placeholder="08x-xxx-xxxx">
            </div>
            <div class="form-group">
              <label>เลขบัตรประชาชน</label>
              <input v-model="form.sellerIdCardNumber" type="text" placeholder="เลข 13 หลัก">
            </div>
          </div>
          
          <div class="space-y-4">
            <label class="text-[11px] font-bold text-slate-500">เอกสารยืนยัน (รูปถ่าย)</label>
            <div class="grid grid-cols-2 gap-3">
              <div class="relative bg-slate-50 border rounded-xl p-3 text-center border-dashed">
                <span class="text-[9px] text-slate-500 block mb-2">รูปบัตรประชาชน</span>
                <Camera class="w-4 h-4 mx-auto text-slate-400" />
                <input type="file" @change="e => handleSpecialFile(e, 'idCardImage')" class="absolute inset-0 opacity-0 cursor-pointer">
                <p v-if="form.idCardImage" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form.idCardImage.name }}</p>
                <p v-else-if="existingSellerImages.idCardImageUrl" class="text-[8px] text-blue-600 mt-1">มีรูปเดิมอยู่แล้ว</p>
              </div>
              <div class="relative bg-slate-50 border rounded-xl p-3 text-center border-dashed">
                <span class="text-[9px] text-slate-500 block mb-2">รูปคู่กับเครื่อง</span>
                <Camera class="w-4 h-4 mx-auto text-slate-400" />
                <input type="file" @change="e => handleSpecialFile(e, 'sellerWithPhoneImage')" class="absolute inset-0 opacity-0 cursor-pointer">
                <p v-if="form.sellerWithPhoneImage" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form.sellerWithPhoneImage.name }}</p>
                <p v-else-if="existingSellerImages.sellerWithPhoneImageUrl" class="text-[8px] text-blue-600 mt-1">มีรูปเดิมอยู่แล้ว</p>
              </div>
            </div>
            <div class="relative bg-slate-50 border rounded-xl p-4 text-center border-dashed mt-2">
              <span class="text-[9px] text-slate-500 block mb-2">อัปโหลดรูปลายเซ็น (Signature)</span>
              <PenTool class="w-4 h-4 mx-auto text-slate-400" />
              <input type="file" @change="e => handleSpecialFile(e, 'signature')" class="absolute inset-0 opacity-0 cursor-pointer">
              <p v-if="form.signature" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form.signature.name }}</p>
              <p v-else-if="existingSellerImages.signatureUrl" class="text-[8px] text-blue-600 mt-1">มีรูปลายเซ็นเดิม</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Step 4: สรุปและบันทึก -->
      <div v-if="currentStep === 4" class="form-section animate-in fade-in slide-in-from-right-4 duration-300">
        <div class="section-header">
          <CheckCircle2 class="w-5 h-5 text-blue-600" />
          <h3 class="text-sm font-bold text-slate-800">ตรวจสอบข้อมูลครั้งสุดท้าย</h3>
        </div>
        
        <div class="bg-slate-50 rounded-2xl p-6 space-y-4">
          <div class="grid grid-cols-2 gap-y-3 text-sm">
            <span class="text-slate-500 font-medium">แบรนด์/รุ่น:</span>
            <span class="font-bold text-slate-800 text-right">{{ form.brand }} {{ form.model }}</span>
            <span class="text-slate-500 font-medium">IMEI:</span>
            <span class="font-bold text-slate-800 text-right">{{ form.imei1 }}</span>
            <span class="text-slate-500 font-medium">ราคาขาย:</span>
            <span class="font-bold text-blue-600 text-right">฿{{ Number(form.sellPrice).toLocaleString() }}</span>
            <span class="text-slate-500 font-medium">ผู้ขาย:</span>
            <span class="font-bold text-slate-800 text-right">{{ form.sellerFullName || 'ไม่ได้ระบุ' }}</span>
          </div>
          
          <div class="border-t pt-4">
             <p class="text-[10px] text-slate-400 font-bold uppercase mb-2">สถานะการตรวจสอบ</p>
             <div class="flex flex-wrap gap-2">
                <span class="px-2 py-1 rounded-md text-[9px] font-bold" :class="form.isCloudLocked ? 'bg-red-50 text-red-600' : 'bg-emerald-50 text-emerald-600'">
                  {{ form.isCloudLocked ? 'ติด iCloud' : 'iCloud ว่าง' }}
                </span>
                <span class="px-2 py-1 rounded-md text-[9px] font-bold" :class="!form.isResetReady ? 'bg-red-50 text-red-600' : 'bg-emerald-50 text-emerald-600'">
                  {{ !form.isResetReady ? 'Reset ไม่ได้' : 'Reset ได้ปกติ' }}
                </span>
                <span class="px-2 py-1 rounded-md text-[9px] font-bold" :class="form.isMdmLocked ? 'bg-red-50 text-red-600' : 'bg-emerald-50 text-emerald-600'">
                   {{ form.isMdmLocked ? 'ติด MDM' : 'ไม่มี MDM' }}
                </span>
             </div>
          </div>

          <div class="border-t pt-4">
             <p class="text-[10px] text-slate-400 font-bold uppercase mb-2">ข้อมูลการทดสอบซอฟต์แวร์</p>
             <p class="text-[10px] text-slate-500">ข้อมูลการทดสอบจะถูกบันทึกโดยอัตโนมัติเมื่อมีการตรวจสอบผ่านระบบ</p>
          </div>
        </div>

        <div class="flex items-center space-x-2 p-4 bg-amber-50 rounded-xl border border-amber-100 text-amber-700 mt-6">
           <AlertTriangle class="w-4 h-4 flex-shrink-0" />
           <p class="text-[10px] font-medium">การกดยืนยันหมายถึงคุณได้ตรวจสอบตัวเครื่องและตัวตนผู้ขายเรียบร้อยแล้ว ระบบจะทำการเจนเนอเรท QR Code ทันที</p>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="flex items-center justify-between pt-6 border-t mt-8" :style="{ borderColor: 'var(--gh-border-default)' }">
        <button 
          type="button" 
          @click="currentStep--" 
          v-if="currentStep > 1"
          class="gh-btn !p-2"
        >
          <ArrowLeft class="w-6 h-6" />
        </button>
        <div v-else></div>

        <button 
          v-if="currentStep < 4"
          type="button" 
          @click="currentStep++"
          class="gh-btn !p-2"
        >
          <ArrowRight class="w-6 h-6" />
        </button>
        
        <button 
          v-else
          type="submit" 
          class="gh-btn px-6 py-2 bg-emerald-600 text-white hover:bg-emerald-700 active:translate-y-px disabled:opacity-50"
          :disabled="loading"
        >
          {{ loading ? 'กำลังบันทึก...' : (isEdit ? 'บันทึก' : 'ยืนยัน') }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import axios from 'axios';
import { useAuthStore } from '../../store/auth';
import { useRouter, useRoute } from 'vue-router';
import { 
  ArrowLeft, ArrowRight, Smartphone, Camera, X, ClipboardCheck, 
  UserCheck, CheckCircle2, AlertTriangle, PenTool 
} from 'lucide-vue-next';

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const currentStep = ref(1);
const loading = ref(false);
const files = ref([]);

const isEdit = computed(() => !!route.params.id);

const previewUrl = ref(null);
const existingImages = ref([]);
const existingThumbnail = ref(null);
const existingSellerImages = reactive({
  idCardImageUrl: null,
  sellerWithPhoneImageUrl: null,
  signatureUrl: null
});

const stepTitles = [
  'ข้อมูลพื้นฐานตัวเครื่อง',
  'รายการตรวจสอบสภาพ',
  'ยืนยันตัวตนผู้ขาย',
  'สรุปข้อมูล'
];

const form = reactive({
  brand: '',
  model: '',
  color: '',
  storage: '',
  imei1: '',
  serialNumber: '',
  purchasePrice: '',
  sellPrice: '',
  batteryHealth: 100,
  status: 'available',
  condition: 'used',
  
  // Warranty
  hasWarranty: true,
  warrantyType: 'shop',
  warrantyEndDate: '',
  
  // Checklist
  isCloudLocked: false,
  isResetReady: true,
  isMdmLocked: false,
  isPromoAttached: false,
  isGenuineParts: true,
  conditionNote: '',
  
  // Seller Info
  sellerFullName: '',
  sellerPhone: '',
  sellerIdCardNumber: '',
  idCardImage: null,
  sellerWithPhoneImage: null,
  signature: null,
  testData: null,
  thumbnail: null // New field
});

const fetchProduct = async () => {
  if (!isEdit.value) return;
  
  try {
    const id = route.params.id;
    const response = await axios.get(`http://localhost:5000/api/products/${id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    const data = response.data;
    
    // Fill main form
    Object.keys(form).forEach(key => {
      if (data[key] !== undefined) form[key] = data[key];
    });

    // Populate existing images/thumbnail
    if (data.thumbnail) existingThumbnail.value = data.thumbnail;
    if (data.images && Array.isArray(data.images)) {
      existingImages.value = data.images;
    }
    
    // Fill seller info if exists
    if (data.seller) {
      form.sellerFullName = data.seller.fullName;
      form.sellerPhone = data.seller.phoneNumber;
      form.sellerIdCardNumber = data.seller.idCardNumber;
      
      existingSellerImages.idCardImageUrl = data.seller.idCardImageUrl;
      existingSellerImages.sellerWithPhoneImageUrl = data.seller.sellerWithPhoneImageUrl;
      existingSellerImages.signatureUrl = data.seller.signatureUrl;
    }
  } catch (error) {
    console.error('Failed to fetch product', error);
    alert('ไม่พบข้อมูลสินค้า');
    router.push('/admin/products');
  }
};

const mockTest = () => {
  form.testData = {
    cpu: "Passed",
    battery: "98% Health",
    sensors: "All OK",
    display: "Original",
    faceId: "Functional",
    testedAt: new Date().toISOString()
  };
};

const handleFileUpload = (event) => {
  files.value = [...files.value, ...Array.from(event.target.files)];
};

const deleteImage = async (imageId) => {
  if (!confirm('ยืนยันการลบรูปภาพนี้?')) return;
  try {
    await axios.delete(`http://localhost:5000/api/products/images/${imageId}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    existingImages.value = existingImages.value.filter(img => img.id !== imageId);
  } catch (error) {
    alert('ไม่สามารถลบรูปภาพได้');
  }
};

const deleteImageThumbnail = async () => {
  if (!confirm('ยืนยันการลบรูปปกนี้?')) return;
  try {
    const id = route.params.id;
    await axios.put(`http://localhost:5000/api/products/${id}`, { thumbnail: null }, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    existingThumbnail.value = null;
  } catch (error) {
    console.error('Delete thumbnail failed:', error);
    alert('ไม่สามารถลบรูปปกได้');
  }
};

const handleSubmit = async () => {
  loading.value = true;
  try {
    const formData = new FormData();
    Object.keys(form).forEach(key => {
      const val = form[key];
      if (val !== null && val !== undefined) {
        if (val instanceof File) {
          formData.append(key, val);
        } else if (typeof val === 'object') {
          formData.append(key, JSON.stringify(val));
        } else {
          formData.append(key, val);
        }
      }
    });
    
    // Add additional files if they exist (images array)
    files.value.forEach(file => {
      formData.append('images', file);
    });
    
    // Send FormData for both Add and Edit
    const url = isEdit.value 
      ? `http://localhost:5000/api/products/${route.params.id}`
      : 'http://localhost:5000/api/products';
      
    const method = isEdit.value ? 'put' : 'post';
    
    await axios({
      method: method,
      url: url,
      data: formData,
      headers: { 
        'Content-Type': 'multipart/form-data',
        Authorization: `Bearer ${authStore.token}` 
      }
    });
    
    router.push('/admin/products');
  } catch (error) {
    console.error('Save failed:', error.response?.data || error.message);
    alert('ผิดพลาด: ' + (error.response?.data?.message || error.message));
  } finally {
    loading.value = false;
  }
};

onMounted(fetchProduct);
</script>

<style>
.form-section {
  background: white;
  padding: 1.5rem;
  border-radius: 0.75rem;
  border: 1px solid var(--gh-border-default);
  margin-bottom: 1.5rem;
}
.section-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}
.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}
.form-group label {
  font-size: 0.75rem;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
}
.form-group input, .form-input {
  background: var(--gh-canvas-default);
  border: 1px solid var(--gh-border-default);
  border-radius: 0.375rem;
  padding: 0.5rem 0.75rem;
  width: 100%;
  font-size: 0.875rem;
}
</style>
