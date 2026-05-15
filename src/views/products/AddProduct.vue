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
    <div class="flex items-center space-x-2 mb-8 px-2 print-hide">
      <div v-for="step in 4" :key="step" class="flex-1 h-1.5 rounded-full transition-colors" :class="step <= currentStep ? 'bg-blue-600' : 'bg-slate-200'"></div>
    </div>

    <!-- Loading Overlay -->
    <div v-if="fetching" class="flex flex-col items-center justify-center p-20 bg-white rounded-2xl border border-slate-200 shadow-sm">
       <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mb-4"></div>
       <p class="text-slate-500 font-bold uppercase tracking-widest text-xs text-center">กำลังโหลดข้อมูลสินค้า...<br><span class="text-[10px] opacity-50">กรุณารอสักครู่</span></p>
    </div>

    <form v-else @submit.prevent="handleSubmit" enctype="multipart/form-data" class="space-y-4">
      
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
            <label>เลข IMEI 2</label>
            <input v-model="form.imei2" type="text" placeholder="เลข 15 หลัก (ถ้ามี)">
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
              <img :src="resolveUrl(existingThumbnail)" @click="previewUrl = resolveUrl(existingThumbnail)" class="w-20 h-20 object-cover rounded-lg border cursor-pointer">
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

        <!-- Hardware Functional Tests -->
        <div class="mt-6 border-t pt-6">
          <label class="text-xs font-bold text-slate-500 mb-4 block uppercase tracking-wider">ผลการทดสอบตัวเครื่อง</label>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3">
            <label v-for="test in [
              { key: 'testTouchscreen', label: 'ทัชสกรีน' },
              { key: 'testSpeaker', label: 'ลำโพง' },
              { key: 'testMic', label: 'ไมค์' },
              { key: 'testWifi', label: 'WiFi' },
              { key: 'testBluetooth', label: 'Bluetooth' },
              { key: 'testCamera', label: 'กล้อง' },
              { key: 'testFaceId', label: 'Face ID' },
              { key: 'testFingerprint', label: 'สแกนนิ้ว' },
              { key: 'testCharging', label: 'ชาร์จ' },
              { key: 'testSimCard', label: 'ซิมการ์ด' }
            ]" :key="test.key" 
            class="flex items-center justify-between p-3 rounded-xl border border-slate-100 hover:bg-slate-50 cursor-pointer transition"
            :class="form[test.key] ? 'bg-emerald-50/30 border-emerald-100' : 'bg-red-50/30 border-red-100'">
              <span class="text-xs font-bold text-slate-600">{{ test.label }}</span>
              <input type="checkbox" v-model="form[test.key]" class="w-4 h-4 rounded text-emerald-600">
            </label>
          </div>
        </div>

        <!-- Catalog Images Section -->
        <div class="mt-6 border-t pt-6">
          <label class="text-xs font-bold text-slate-500 mb-3 block">รูปถ่ายสภาพเครื่อง (แยกตามหมวดหมู่)</label>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            <div v-for="cat in imageCategories" :key="cat.key" class="relative group">
              <div class="aspect-square bg-slate-50 border-2 border-dashed border-slate-200 rounded-xl flex flex-col items-center justify-center p-2 text-center hover:border-blue-400 transition-colors relative overflow-hidden">
                <template v-if="getImageForCategory(cat.key)">
                  <img :src="getImageForCategory(cat.key)" @click="previewUrl = getImageForCategory(cat.key)" class="absolute inset-0 w-full h-full object-cover cursor-pointer">
                  <button @click.prevent="deleteCategoryImage(cat.key)" class="absolute top-1 right-1 bg-red-500 text-white p-1 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition">
                    <X class="w-3 h-3" />
                  </button>
                </template>
                <template v-else>
                  <Camera class="w-5 h-5 text-slate-400 mb-1" />
                  <span class="text-[9px] font-bold text-slate-500">{{ cat.label }}</span>
                  <input type="file" @change="e => handleCategoryFile(e, cat.key)" class="absolute inset-0 opacity-0 cursor-pointer">
                </template>
              </div>
              <p v-if="form[cat.key]" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form[cat.key].name }}</p>
            </div>
          </div>
          
          <!-- VDO 360 Section -->
          <div class="mt-6">
            <label class="text-xs font-bold text-slate-500 mb-2 block uppercase tracking-wider">วิดีโอ 360 องศา (VDO 360)</label>
            <div class="relative bg-slate-50 border-2 border-dashed border-slate-200 rounded-xl p-4 text-center hover:border-blue-400 transition-colors">
    <template v-if="form.vdo360">
      <div class="relative group">
        <video :src="resolveUrl(form.vdo360)" class="w-full max-h-48 rounded-lg bg-black" controls playsinline></video>
        <button @click.prevent="deleteVdo360" class="absolute top-2 right-2 bg-red-500 text-white p-1.5 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition">
          <Trash2 class="w-3.5 h-3.5" />
        </button>
      </div>
      <p class="text-[10px] text-emerald-600 font-medium mt-2">{{ form.vdo360.name }}</p>
    </template>
    <template v-else-if="existingVdo360">
      <div class="relative group">
        <video :src="resolveUrl(existingVdo360)" class="w-full max-h-48 rounded-lg bg-black" controls playsinline></video>
        <button @click.prevent="deleteVdo360" class="absolute top-2 right-2 bg-red-500 text-white p-1.5 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition">
          <Trash2 class="w-3.5 h-3.5" />
        </button>
      </div>
      <p class="text-[10px] text-blue-600 font-medium mt-2">มีวิดีโอเดิมอยู่แล้ว</p>
    </template>
              <template v-else>
                <Camera class="w-6 h-6 mx-auto text-slate-400 mb-2" />
                <p class="text-[10px] text-slate-500">อัปโหลดวิดีโอแสดงสภาพเครื่องรอบด้าน</p>
                <input type="file" accept="video/*" @change="e => handleSpecialFile(e, 'vdo360')" class="absolute inset-0 opacity-0 cursor-pointer">
              </template>
            </div>
          </div>

          <!-- General Images Section -->
          <div class="mt-6">
            <label class="text-xs font-bold text-slate-500 mb-3 block uppercase tracking-wider">รูปถ่ายเพิ่มเติมอื่นๆ (General Photos)</label>
            <div class="p-8 border-2 border-dashed border-slate-200 rounded-2xl bg-slate-50 flex flex-col items-center justify-center text-center relative group hover:border-blue-400 transition-colors">
              <Camera class="w-6 h-6 text-slate-400 mb-2" />
              <p class="text-[10px] text-slate-500">เลือกรูปถ่ายเพิ่มเติมที่ต้องการเก็บไว้ในระบบ</p>
              <input type="file" multiple @change="handleFileUpload" class="absolute inset-0 opacity-0 cursor-pointer">
            </div>
            
            <div v-if="existingGeneralImages.length > 0" class="mt-4">
               <p class="text-[10px] font-bold text-slate-400 mb-2 uppercase">รูปภาพเพิ่มเติมเดิม</p>
               <div class="flex flex-wrap gap-2">
                  <div v-for="img in existingGeneralImages" :key="img.id" class="relative w-16 h-16 rounded-lg overflow-hidden border group">
                     <img :src="resolveUrl(img.imageUrl)" @click="previewUrl = resolveUrl(img.imageUrl)" class="w-full h-full object-cover cursor-pointer">
                     <button @click.prevent="deleteImage(img.id)" class="absolute top-0 right-0 bg-red-500 text-white p-0.5 rounded-bl-lg opacity-0 group-hover:opacity-100 transition">
                        <X class="w-3 h-3" />
                     </button>
                  </div>
               </div>
            </div>

            <div v-if="files.length > 0" class="mt-4 flex flex-wrap gap-2">
              <div v-for="(file, index) in files" :key="index" class="w-16 h-16 rounded-lg bg-white border border-slate-200 p-1 relative shadow-sm overflow-hidden text-center flex flex-col items-center justify-center">
                 <span class="text-[7px] text-slate-400 break-all leading-none">{{ file.name }}</span>
                 <button @click.prevent="files.splice(index, 1)" class="absolute top-0 right-0 bg-red-500 text-white p-0.5 rounded-bl-lg"><X class="w-3 h-3" /></button>
              </div>
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
              <!-- ID Card -->
              <div class="relative group">
                <div class="aspect-video bg-slate-50 border-2 border-dashed border-slate-200 rounded-xl flex flex-col items-center justify-center p-2 text-center hover:border-indigo-400 transition-colors relative overflow-hidden">
                  <template v-if="getImageForCategory('idCard')">
                    <img :src="getImageForCategory('idCard')" @click="previewUrl = getImageForCategory('idCard')" class="absolute inset-0 w-full h-full object-cover cursor-pointer">
                    <button @click.prevent="deleteSellerImage('idCard')" class="absolute top-1 right-1 bg-red-500 text-white p-1 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition">
                      <X class="w-3 h-3" />
                    </button>
                  </template>
                  <template v-else>
                    <Camera class="w-5 h-5 text-slate-400 mb-1" />
                    <span class="text-[9px] font-bold text-slate-500">รูปบัตรประชาชน</span>
                    <input type="file" @change="e => { handleCategoryFile(e, 'idCard'); deletedSellerImages.idCardImage = false; }" class="absolute inset-0 opacity-0 cursor-pointer">
                  </template>
                </div>
                <p v-if="form.idCard" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form.idCard.name }}</p>
              </div>

              <!-- Seller with Phone -->
              <div class="relative group">
                <div class="aspect-video bg-slate-50 border-2 border-dashed border-slate-200 rounded-xl flex flex-col items-center justify-center p-2 text-center hover:border-indigo-400 transition-colors relative overflow-hidden">
                  <template v-if="getImageForCategory('sellerWithPhone')">
                    <img :src="getImageForCategory('sellerWithPhone')" @click="previewUrl = getImageForCategory('sellerWithPhone')" class="absolute inset-0 w-full h-full object-cover cursor-pointer">
                    <button @click.prevent="deleteSellerImage('sellerWithPhone')" class="absolute top-1 right-1 bg-red-500 text-white p-1 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition">
                      <X class="w-3 h-3" />
                    </button>
                  </template>
                  <template v-else>
                    <Camera class="w-5 h-5 text-slate-400 mb-1" />
                    <span class="text-[9px] font-bold text-slate-500">รูปคู่กับเครื่อง</span>
                    <input type="file" @change="e => { handleCategoryFile(e, 'sellerWithPhone'); deletedSellerImages.sellerWithPhoneImage = false; }" class="absolute inset-0 opacity-0 cursor-pointer">
                  </template>
                </div>
                <p v-if="form.sellerWithPhone" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form.sellerWithPhone.name }}</p>
              </div>
            </div>

            <!-- Signature -->
            <div class="relative group">
              <div class="aspect-[3/1] bg-slate-50 border-2 border-dashed border-slate-200 rounded-xl flex flex-col items-center justify-center p-2 text-center hover:border-indigo-400 transition-colors relative overflow-hidden">
                <template v-if="getImageForCategory('signature')">
                  <img :src="getImageForCategory('signature')" @click="previewUrl = getImageForCategory('signature')" class="absolute inset-0 w-full h-full object-contain cursor-pointer">
                  <button @click.prevent="deleteSellerImage('signature')" class="absolute top-1 right-1 bg-red-500 text-white p-1 rounded-full shadow-lg opacity-0 group-hover:opacity-100 transition">
                    <X class="w-3 h-3" />
                  </button>
                </template>
                <template v-else>
                  <PenTool class="w-5 h-5 text-slate-400 mb-1" />
                  <span class="text-[9px] font-bold text-slate-500">อัปโหลดรูปลายเซ็น (Signature)</span>
                  <input type="file" @change="e => { handleCategoryFile(e, 'signature'); deletedSellerImages.signature = false; }" class="absolute inset-0 opacity-0 cursor-pointer">
                </template>
              </div>
              <p v-if="form.signature" class="text-[8px] text-emerald-600 mt-1 truncate">{{ form.signature.name }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Step 4: สรุปข้อมูลการตรวจสอบ (Formal Document Style) -->
      <div v-if="currentStep === 4" class="form-section inspection-report-print animate-in fade-in slide-in-from-right-4 !p-6 bg-white border border-slate-300 shadow-sm font-sans text-slate-900 leading-tight relative">
        
        <!-- Official Header -->
        <div class="border-b-2 border-slate-900 pb-3 mb-4 flex justify-between items-start">
          <div>
            <h3 class="text-xl font-bold uppercase tracking-tight text-slate-900">ใบสรุปผลการตรวจสภาพตัวเครื่อง</h3>
            <p class="text-slate-500 text-[10px] font-medium mt-0.5 uppercase">PRODUCT INSPECTION SUMMARY REPORT</p>
          </div>
          <div class="text-right print-hide">
            <button type="button" @click="handleDownloadPDF" class="flex items-center gap-2 px-3 py-1.5 border border-slate-900 text-slate-900 hover:bg-slate-50 transition text-[10px] font-bold uppercase">
              <FileText class="w-3.5 h-3.5" />
              Print / Save A4
            </button>
            <p class="text-[9px] text-slate-400 mt-1">วันที่: {{ new Date().toLocaleDateString('th-TH') }}</p>
          </div>
        </div>

        <div class="space-y-4">
          <!-- 1. Product Core Information -->
          <div class="flex gap-6 items-start">
              <div class="w-28 h-28 border border-slate-200 p-0.5 bg-white flex-shrink-0">
                <img v-if="resolveUrl(form.thumbnail || existingThumbnail)" 
                  :src="resolveUrl(form.thumbnail || existingThumbnail)" 
                  class="w-full h-full object-contain">
                <div v-else class="w-full h-full flex items-center justify-center bg-slate-50 text-[8px] text-slate-300 uppercase font-bold text-center p-2">
                  No Photo
                </div>
             </div>
             
             <div class="flex-1">
                <table class="w-full border-collapse text-[10px]">
                   <thead>
                      <tr>
                         <th colspan="4" class="text-left py-1 px-2 bg-slate-50 border border-slate-200 font-bold uppercase text-[9px]">1. ข้อมูลพื้นฐานสินค้า (Core Specs)</th>
                      </tr>
                   </thead>
                   <tbody>
                      <tr>
                         <td class="border border-slate-200 p-1.5 font-bold bg-slate-50/50 w-24 text-slate-500 uppercase">ยี่ห้อ / รุ่น</td>
                         <td class="border border-slate-200 p-1.5 font-bold text-slate-800">{{ form.brand || '-' }} {{ form.model || '' }}</td>
                         <td class="border border-slate-200 p-1.5 font-bold bg-slate-50/50 w-24 text-slate-500 uppercase">สี / ความจุ</td>
                         <td class="border border-slate-200 p-1.5 font-bold text-slate-800">{{ form.color || '-' }} / {{ form.storage || '-' }}</td>
                      </tr>
                      <tr>
                         <td class="border border-slate-200 p-1.5 font-bold bg-slate-50/50 text-slate-500 uppercase">IMEI 1</td>
                         <td class="border border-slate-200 p-1.5 font-mono font-bold">{{ form.imei1 || '-' }}</td>
                         <td class="border border-slate-200 p-1.5 font-bold bg-slate-50/50 text-slate-500 uppercase">IMEI 2</td>
                         <td class="border border-slate-200 p-1.5 font-mono">{{ form.imei2 || '-' }}</td>
                      </tr>
                      <tr>
                         <td class="border border-slate-200 p-1.5 font-bold bg-slate-50/50 text-slate-500 uppercase">Serial No.</td>
                         <td class="border border-slate-200 p-1.5 font-mono uppercase">{{ form.serialNumber || 'N/A' }}</td>
                         <td class="border border-slate-200 p-1.5 font-bold bg-slate-50/50 text-slate-500 uppercase">แบตเตอรี่</td>
                         <td class="border border-slate-200 p-1.5 font-bold text-emerald-600">{{ form.batteryHealth || '100' }}%</td>
                      </tr>
                   </tbody>
                </table>
             </div>
          </div>

          <!-- 2. Software & Identity -->
          <div class="grid grid-cols-2 gap-6">
             <div class="space-y-2">
                <h4 class="text-[9px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 pb-1">2. ตรวจสอบซอฟต์แวร์ (Software)</h4>
                <div class="grid grid-cols-1 gap-1">
                   <div v-for="chk in [
                     { label: 'iCloud / Google Lock', val: form.isCloudLocked, neg: true, text: 'ติดล็อก', safe: 'ไม่ติดล็อก' },
                     { label: 'Reset System', val: form.isResetReady, neg: false, text: 'ทำได้ปกติ', safe: 'ทำไม่ได้' },
                     { label: 'MDM Lock', val: form.isMdmLocked, neg: true, text: 'ติด MDM', safe: 'ไม่มี MDM' },
                     { label: 'Hardware Authenticity', val: form.isGenuineParts, neg: false, text: 'อะไหล่แท้', safe: 'อะไหล่ไม่แท้' }
                   ]" :key="chk.label" class="flex items-center justify-between text-[10px] py-0.5">
                      <span class="text-slate-500 font-medium">{{ chk.label }}</span>
                      <span class="font-bold" :class="(chk.neg ? !chk.val : chk.val) ? 'text-slate-900' : 'text-red-600'">
                         {{ (chk.neg ? !chk.val : chk.val) ? chk.neg ? chk.safe : chk.text : chk.neg ? chk.text : chk.safe }}
                         {{ (chk.neg ? !chk.val : chk.val) ? '✓' : '✗' }}
                      </span>
                   </div>
                </div>
             </div>

             <div class="flex items-center gap-4 border border-slate-100 p-2 bg-slate-50/30">
                <div class="w-20 h-20 bg-white border border-slate-200 p-1 flex-shrink-0">
                   <img v-if="form.imei1" :src="`https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=${form.imei1}`" class="w-full h-full mx-auto">
                   <div v-else class="w-full h-full flex items-center justify-center text-[6px] text-slate-300 italic">No QR</div>
                </div>
                <div>
                   <h4 class="text-[9px] font-bold text-slate-400 uppercase tracking-wider mb-1">3. Product Identity</h4>
                   <p class="font-mono text-[10px] font-bold text-slate-900 uppercase leading-none">{{ form.brand || '-' }}</p>
                   <p class="font-mono text-[9px] text-slate-500 mt-1 uppercase">{{ form.imei1 || 'N/A' }}</p>
                </div>
             </div>
          </div>

          <!-- 3. Hardware Validation Table -->
          <div class="space-y-2">
            <h4 class="text-[9px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 pb-1">4. รายละเอียดการทดสอบฮาร์ดแวร์ (10-Point Validation)</h4>
            <div class="grid grid-cols-5 border border-slate-200 divide-x divide-y divide-slate-200">
               <div v-for="test in [
                { key: 'testTouchscreen', label: 'Touch' },
                { key: 'testSpeaker', label: 'Speaker' },
                { key: 'testMic', label: 'Mic' },
                { key: 'testWifi', label: 'WiFi' },
                { key: 'testBluetooth', label: 'BT' },
                { key: 'testCamera', label: 'Camera' },
                { key: 'testFaceId', label: 'Face/TouchID' },
                { key: 'testFingerprint', label: 'Finger' },
                { key: 'testCharging', label: 'Charge' },
                { key: 'testSimCard', label: 'SIM' }
              ]" :key="test.key" class="p-1.5 text-center flex flex-col justify-center items-center">
                  <span class="text-[8px] font-bold text-slate-400 uppercase tracking-tighter">{{ test.label }}</span>
                  <span class="text-[10px] font-black" :class="form[test.key] ? 'text-slate-900' : 'text-red-600'">
                     {{ form[test.key] ? 'PASS ✓' : 'FAIL ✗' }}
                  </span>
               </div>
            </div>
          </div>

          <!-- 4. Device Condition Catalog -->
          <div class="space-y-2">
            <h4 class="text-[9px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 pb-1">5. คลังรูปภาพประกอบการตรวจสอบ (Visual Catalog)</h4>
            <div class="grid grid-cols-5 md:grid-cols-8 gap-1 bg-slate-50 p-1 border border-slate-200">
              <div v-for="cat in imageCategories" :key="cat.key" class="aspect-square bg-white border border-slate-100 overflow-hidden flex flex-col items-center justify-center relative">
                <img v-if="getImageForCategory(cat.key)" :src="getImageForCategory(cat.key)" class="w-full h-full object-cover">
                <span v-else class="text-[6px] text-slate-300 font-bold uppercase text-center p-0.5">No Img</span>
                <div class="absolute inset-x-0 bottom-0 bg-white/90 py-0.5 border-t border-slate-100 text-center">
                   <p class="text-[7px] font-bold text-slate-500 uppercase tracking-tighter leading-none">{{ cat.label }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- 5. Verification & Signatures -->
          <div class="grid grid-cols-2 gap-10 pt-4">
             <div class="text-center space-y-2">
                <p class="text-[9px] text-slate-500 font-bold uppercase tracking-widest mb-4">ลงชื่อผู้ตรวจสอบ (Inspector)</p>
                <div class="border-b border-slate-900 mx-6 h-10 flex items-end justify-center">
                   <span class="text-slate-300 italic text-[9px]">AUTHORIZED SIGNATURE</span>
                </div>
                <p class="text-[9px] font-bold text-slate-800 uppercase">( {{ (authStore.user && authStore.user.username) || 'SYSTEM ADMIN' }} )</p>
             </div>
             
             <div class="text-center space-y-2">
                <p class="text-[9px] text-slate-500 font-bold uppercase tracking-widest mb-4">ลงชื่อผู้ขาย (Seller)</p>
                <div class="border-b border-slate-900 mx-6 h-10 flex items-end justify-center pb-1">
                   <img v-if="resolveUrl(form.signature || existingSellerImages.signatureUrl)" 
                     :src="resolveUrl(form.signature || existingSellerImages.signatureUrl)" 
                     class="max-h-8 object-contain">
                   <span v-else class="text-slate-300 italic text-[9px]">SIGNATURE REQUIRED</span>
                </div>
                <p class="text-[9px] font-bold text-slate-800 uppercase">( {{ form.sellerFullName || 'ผู้ขาย' }} )</p>
             </div>
          </div>
        </div>

        <!-- Official Footer -->
        <div class="mt-6 pt-3 border-t border-slate-200 text-center">
           <p class="text-[7px] text-slate-300 mt-0.5 italic">เอกสารฉบับนี้จัดทำขึ้นโดยระบบอัตโนมัติ เพื่อใช้เป็นข้อมูลยืนยันสถานะสินค้า ณ วันที่ทำการตรวจสอบเท่านั้น</p>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="flex items-center justify-between pt-6 border-t mt-8 print-hide" :style="{ borderColor: 'var(--gh-border-default)' }">
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
          {{ loading ? 'กำลังบันทึก...' : (isEdit ? 'บันทึกการแก้ไข' : 'ยืนยันและบันทึก') }}
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
  UserCheck, CheckCircle2, AlertTriangle, PenTool, FileText, Check,
  Trash2
} from 'lucide-vue-next';
import { getApiBasePath, assetUrl } from '../../config/api';
import { useToast } from 'vue-toastification';

const authStore = useAuthStore();
const router = useRouter();
const route = useRoute();
const toast = useToast();
const currentStep = ref(1);
const loading = ref(false);
const fetching = ref(false);
const files = ref([]);

const isEdit = computed(() => !!route.params.id);

const previewUrl = ref(null);
const existingImages = ref([]);
const existingThumbnail = ref(null);
const existingBarcode = ref(null);
const existingSellerImages = reactive({
  idCardImageUrl: null,
  sellerWithPhoneImageUrl: null,
  signatureUrl: null
});

const deletedSellerImages = reactive({
  idCardImage: false,
  sellerWithPhoneImage: false,
  signature: false
});

const stepTitles = [
  'ข้อมูลพื้นฐานตัวเครื่อง',
  'รายการตรวจสอบสภาพ',
  'ยืนยันตัวตนผู้ขาย',
  'สรุปข้อมูล'
];

const imageCategories = [
  { key: 'front', label: 'หน้า' },
  { key: 'back', label: 'หลัง' },
  { key: 'left', label: 'ข้างซ้าย' },
  { key: 'right', label: 'ข้างขวา' },
  { key: 'bottomLeft', label: 'มุมล่างซ้าย' },
  { key: 'bottomRight', label: 'มุมล่างขวา' },
  { key: 'topEdge', label: 'ขอบบน' },
  { key: 'bottomEdge', label: 'ขอบล่าง' },
  { key: 'about1', label: 'เกี่ยวกับ 1' },
  { key: 'about2', label: 'เกี่ยวกับ 2' },
  { key: 'battery', label: 'แบต' },
  { key: 'rearCamera', label: 'กล้องหลัง' },
  { key: 'frontCamera', label: 'กล้องหน้า' },
  { key: 'screen', label: 'หน้าจอ' },
  { key: 'lens', label: 'เลนส์' }
];

const form = reactive({
  brand: '',
  model: '',
  color: '',
  storage: '',
  imei1: '',
  imei2: '',
  serialNumber: '',
  purchasePrice: '',
  sellPrice: '',
  batteryHealth: 100,
  status: 'available',
  condition: 'used',
  hasWarranty: true,
  warrantyType: 'shop',
  warrantyEndDate: '',
  isCloudLocked: false,
  isResetReady: true,
  isMdmLocked: false,
  isPromoAttached: false,
  isGenuineParts: true,
  testTouchscreen: true,
  testSpeaker: true,
  testMic: true,
  testWifi: true,
  testBluetooth: true,
  testCamera: true,
  testFaceId: true,
  testFingerprint: true,
  testCharging: true,
  testSimCard: true,
  conditionNote: '',
  sellerFullName: '',
  sellerPhone: '',
  sellerIdCardNumber: '',
  idCardImage: null,
  sellerWithPhoneImage: null,
  signature: null,
  thumbnail: null,
  vdo360: null,
  barcode: null,
  front: null,
  back: null,
  left: null,
  right: null,
  bottomLeft: null,
  bottomRight: null,
  topEdge: null,
  bottomEdge: null,
  about1: null,
  about2: null,
  battery: null,
  rearCamera: null,
  frontCamera: null,
  screen: null,
  lens: null
});

const resolveUrl = (path) => {
  if (!path) return null;
  if (path instanceof File) {
    try { return URL.createObjectURL(path); } catch (e) { return null; }
  }
  if (typeof path !== 'string') return null;
  return path.startsWith('http') ? path : assetUrl(path);
};

const getImageForCategory = (category) => {
  if (form[category] instanceof File) return resolveUrl(form[category]);
  if (Array.isArray(existingImages.value)) {
    const existing = existingImages.value.find(img => img.type === category);
    if (existing && existing.imageUrl) return resolveUrl(existing.imageUrl);
  }
  // Fallback for thumbnail
  if (category === 'thumbnail' && existingThumbnail.value) return resolveUrl(existingThumbnail.value);
  // Fallback for seller images
  if (category === 'idCard' && existingSellerImages.idCardImageUrl) return resolveUrl(existingSellerImages.idCardImageUrl);
  if (category === 'sellerWithPhone' && existingSellerImages.sellerWithPhoneImageUrl) return resolveUrl(existingSellerImages.sellerWithPhoneImageUrl);
  if (category === 'signature' && existingSellerImages.signatureUrl) return resolveUrl(existingSellerImages.signatureUrl);
  return null;
};

const handleDownloadPDF = () => {
  window.print();
};

const handleSpecialFile = (event, field) => {
  form[field] = event.target.files[0];
};

const existingVdo360 = computed(() => form.vdo360 && typeof form.vdo360 === 'string' ? form.vdo360 : null);

const existingGeneralImages = computed(() => {
  if (!Array.isArray(existingImages.value)) return [];
  return existingImages.value.filter(img => img.type === 'general');
});

const handleCategoryFile = (event, category) => {
  form[category] = event.target.files[0];
};

const deleteCategoryImage = async (category) => {
  const existing = existingImages.value.find(img => img.type === category);
  if (existing) {
    if (!confirm(`ยืนยันการลบรูปภาพหมวดหมู่ ${category}?`)) return;
    try {
      await axios.delete(`${getApiBasePath()}/products/images/${existing.id}`, {
        headers: { Authorization: `Bearer ${authStore.token}` }
      });
      existingImages.value = existingImages.value.filter(img => img.id !== existing.id);
      toast.success('ลบรูปภาพสำเร็จ');
    } catch (error) {
      toast.error('ไม่สามารถลบรูปภาพได้');
    }
  } else {
    form[category] = null;
  }
};

const deleteSellerImage = (type) => {
  if (!confirm(`ยืนยันการลบรูป${type === 'idCard' ? 'บัตรประชาชน' : type === 'sellerWithPhone' ? 'คู่กับเครื่อง' : 'ลายเซ็น'}?`)) return;
  if (type === 'idCard') {
    existingSellerImages.idCardImageUrl = null;
    deletedSellerImages.idCardImage = true;
  } else if (type === 'sellerWithPhone') {
    existingSellerImages.sellerWithPhoneImageUrl = null;
    deletedSellerImages.sellerWithPhoneImage = true;
  } else if (type === 'signature') {
    existingSellerImages.signatureUrl = null;
    deletedSellerImages.signature = true;
  }
  toast.success('ลบรูปภาพสำเร็จ');
};

const deleteVdo360 = async () => {
  if (!confirm('ยืนยันการลบวิดีโอ 360?')) return;
  try {
    const id = route.params.id;
    await axios.delete(`${getApiBasePath()}/products/vdo/${id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    // Reset ทั้ง form และ logic เพื่อให้ UI อัปเดต
    form.vdo360 = null;
    // เพิ่มการอัปเดต state ถ้าจำเป็น
    toast.success('ลบวิดีโอสำเร็จ');
  } catch (error) {
    console.error('Delete VDO failed:', error);
    toast.error('ไม่สามารถลบวิดีโอได้');
  }
};

const fetchProduct = async () => {
  if (!isEdit.value) return;
  fetching.value = true;
  try {
    const id = route.params.id;
    const response = await axios.get(`${getApiBasePath()}/products/${id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    const data = response.data;
    
    Object.keys(form).forEach(key => {
      if (data[key] !== undefined) form[key] = data[key];
    });

    if (data.thumbnail) existingThumbnail.value = data.thumbnail;
    if (data.barcode) {
      existingBarcode.value = data.barcode;
      form.barcode = data.barcode;
    }
    if (data.images && Array.isArray(data.images)) {
      existingImages.value = data.images;
    }
    
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
    toast.error('ไม่พบข้อมูลสินค้า');
    router.push('/admin/products');
  } finally {
    fetching.value = false;
  }
};

const handleFileUpload = (event) => {
  files.value = [...files.value, ...Array.from(event.target.files)];
};

const deleteImage = async (imageId) => {
  if (!confirm('ยืนยันการลบรูปภาพนี้?')) return;
  try {
    await axios.delete(`${getApiBasePath()}/products/images/${imageId}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    existingImages.value = existingImages.value.filter(img => img.id !== imageId);
    toast.success('ลบรูปภาพเพิ่มเติมสำเร็จ');
  } catch (error) {
    toast.error('ไม่สามารถลบรูปภาพได้');
  }
};

const deleteImageThumbnail = async () => {
  if (!confirm('ยืนยันการลบรูปปกนี้?')) return;
  try {
    const id = route.params.id;
    await axios.put(`${getApiBasePath()}/products/${id}`, { thumbnail: null }, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    existingThumbnail.value = null;
    toast.success('ลบรูปปกสำเร็จ');
  } catch (error) {
    console.error('Delete thumbnail failed:', error);
    toast.error('ไม่สามารถลบรูปปกได้');
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
        } else {
          formData.append(key, val);
        }
      }
    });
    
    files.value.forEach(file => {
      formData.append('images', file);
    });
    
    // Add seller image deletion flags
    if (deletedSellerImages.idCardImage) formData.append('deleteIdCardImage', 'true');
    if (deletedSellerImages.sellerWithPhoneImage) formData.append('deleteSellerWithPhoneImage', 'true');
    if (deletedSellerImages.signature) formData.append('deleteSignatureImage', 'true');
    
    const url = isEdit.value 
      ? `${getApiBasePath()}/products/${route.params.id}`
      : `${getApiBasePath()}/products`;
      
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
    
    toast.success(isEdit.value ? 'อัปเดตข้อมูลสำเร็จ' : 'เพิ่มสินค้าสำเร็จ');
    router.push('/admin/products');
  } catch (error) {
    console.error('Save failed:', error.response?.data || error.message);
    toast.error('ผิดพลาด: ' + (error.response?.data?.message || error.message));
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

<style scoped>
@media print {
  .print-hide, header, nav, .progress-bar, button {
    display: none !important;
  }
  body * {
    visibility: hidden;
  }
  .inspection-report-print, .inspection-report-print * {
    visibility: visible;
  }
  .inspection-report-print {
    position: absolute;
    left: 0;
    top: 0;
    width: 210mm;
    min-height: 297mm;
    margin: 0 !important;
    padding: 10mm !important;
    border: none !important;
    box-shadow: none !important;
    background: white !important;
    z-index: 9999;
  }
  body {
    background: white !important;
  }
  @page {
    size: A4;
    margin: 0;
  }
}
</style>
