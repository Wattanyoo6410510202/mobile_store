<template>
  <div class="space-y-6 max-w-5xl mx-auto">
    <!-- Header Section -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-slate-900 tracking-tight flex items-center gap-2">
          <Users class="w-6 h-6 text-slate-400" />
          จัดการพนักงาน
        </h1>
        <p class="text-sm text-slate-500 font-medium">ดูแลรายชื่อพนักงานและสิทธิ์การเข้าถึงระบบ VIP Phone</p>
      </div>
      <button @click="isAddModalOpen = true" class="gh-btn bg-[#2da44e] text-white hover:bg-[#2c974b] border-[#1b1f2326] shadow-sm flex items-center gap-2 px-4 py-2">
        <UserPlus class="w-4 h-4" />
        เพิ่มพนักงานใหม่
      </button>
    </div>

    <!-- User List Card -->
    <div class="gh-card bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden">
      <!-- Card Header / Search Bar Placeholder if needed -->
      <div class="bg-slate-50 border-b border-slate-200 px-6 py-4 flex items-center justify-between">
        <h3 class="text-[10px] font-black uppercase tracking-widest text-slate-500">บัญชีผู้ใช้ทั้งหมด ({{ users.length }})</h3>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
          <thead>
            <tr class="text-[10px] font-bold text-slate-400 uppercase tracking-widest bg-white">
              <th class="px-6 py-3 border-b border-slate-100">ชื่อพนักงาน</th>
              <th class="px-6 py-3 border-b border-slate-100">บัญชีผู้ใช้ (Username)</th>
              <th class="px-6 py-3 border-b border-slate-100">ระดับสิทธิ์</th>
              <th class="px-6 py-3 border-b border-slate-100">วันที่ลงทะเบียน</th>
              <th class="px-6 py-3 border-b border-slate-100 text-right">การจัดการ</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-50">
            <tr v-for="user in users" :key="user.id" class="hover:bg-slate-50/80 transition-colors group">
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-slate-400 text-xs font-bold border border-slate-200 uppercase">
                    {{ user.name.substring(0, 2) }}
                  </div>
                  <span class="font-bold text-slate-800 text-sm">{{ user.name }}</span>
                </div>
              </td>
              <td class="px-6 py-4">
                <code class="text-[11px] bg-slate-100 px-2 py-1 rounded-md text-slate-600 font-mono">{{ user.email }}</code>
              </td>
              <td class="px-6 py-4">
                <div class="flex flex-col gap-2">
                  <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase border shadow-sm w-fit"
                    :class="user.role === 'admin' ? 'bg-purple-50 text-purple-600 border-purple-100' : 'bg-blue-50 text-blue-600 border-blue-100'">
                    <ShieldCheck v-if="user.role === 'admin'" class="w-3 h-3" />
                    <UserCircle2 v-else class="w-3 h-3" />
                    {{ user.role === 'admin' ? 'ผู้ดูแลระบบ' : 'พนักงาน' }}
                  </span>
                  <span v-if="user.isCustomer" class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase border border-green-100 bg-green-50 text-green-600 shadow-sm w-fit">
                    ลูกค้า
                  </span>
                </div>
              </td>
              <td class="px-6 py-4 text-slate-500 text-xs font-medium">
                {{ new Date(user.createdAt).toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: 'numeric' }) }}
              </td>
              <td class="px-6 py-4 text-right">
                <button 
                  @click="deleteUser(user.id)" 
                  class="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all opacity-0 group-hover:opacity-100 disabled:opacity-0"
                  :disabled="user.role === 'admin' && users.filter(u => u.role === 'admin').length <= 1"
                  title="ลบผู้ใช้"
                >
                  <Trash2 class="w-4 h-4" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- Empty State -->
        <div v-if="users.length === 0" class="flex flex-col items-center justify-center py-20 text-center">
          <div class="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center mb-4">
            <Users class="w-8 h-8 text-slate-200" />
          </div>
          <h4 class="text-sm font-bold text-slate-800">ไม่พบรายชื่อพนักงาน</h4>
          <p class="text-xs text-slate-400 mt-1">เริ่มเพิ่มพนักงานคนแรกเพื่อเข้าใช้งานระบบ</p>
        </div>
      </div>
    </div>

    <!-- Footer Notice -->
    <div class="flex items-start gap-3 p-4 bg-blue-50 rounded-xl border border-blue-100">
      <ShieldAlert class="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
      <p class="text-[11px] text-blue-700 leading-relaxed font-medium">
        <strong class="block uppercase tracking-wider mb-0.5">Security Notice</strong>
        บัญชีระดับผู้ดูแลระบบ (Admin) สามารถเข้าถึงข้อมูลต้นทุนและจัดการพนักงานท่านอื่นได้ กรุณากำหนดสิทธิ์ให้พนักงานอย่างระมัดระวัง
      </p>
    </div>

    <!-- Add User Modal (GitHub Style Dialog) -->
    <div v-if="isAddModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden border border-slate-200 animate-in fade-in zoom-in-95 duration-200">
        <!-- Modal Header -->
        <div class="px-6 py-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
          <h3 class="font-bold text-slate-900 text-sm flex items-center gap-2">
            <UserPlus class="w-4 h-4 text-slate-400" />
            เพิ่มพนักงานใหม่
          </h3>
          <button @click="isAddModalOpen = false" class="p-1 hover:bg-slate-200 rounded-md transition text-slate-400">
            <X class="w-4 h-4" />
          </button>
        </div>

        <!-- Modal Body -->
        <form @submit.prevent="handleAddUser" class="p-6 space-y-4">
          <div class="flex flex-col gap-1">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">ชื่อ-นามสกุลจริง</label>
            <input v-model="newUser.name" type="text" required placeholder="เช่น สมชาย ใจดี" class="bg-white border border-slate-300 rounded-lg p-2.5 text-sm focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 focus:outline-none transition-all">
          </div>
          <div class="flex flex-col gap-1">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">ชื่อผู้ใช้ (Username)</label>
            <input v-model="newUser.email" type="text" required placeholder="ใช้สำหรับเข้าสู่ระบบ" class="bg-white border border-slate-300 rounded-lg p-2.5 text-sm focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 focus:outline-none transition-all">
          </div>
          <div class="flex flex-col gap-1">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">รหัสผ่านเริ่มต้น</label>
            <input v-model="newUser.password" type="password" required placeholder="อย่างน้อย 4 ตัวอักษร" class="bg-white border border-slate-300 rounded-lg p-2.5 text-sm focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 focus:outline-none transition-all">
          </div>
          <div class="flex flex-col gap-1">
            <label class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">ระดับสิทธิ์การใช้งาน</label>
            <div class="grid grid-cols-2 gap-2 mt-1">
              <label class="relative flex flex-col p-3 rounded-lg border-2 cursor-pointer transition"
                :class="newUser.role === 'staff' ? 'bg-blue-50/50 border-blue-500 shadow-sm' : 'border-slate-100 hover:bg-slate-50'">
                <input type="radio" v-model="newUser.role" value="staff" class="sr-only">
                <span class="text-[10px] font-black uppercase" :class="newUser.role === 'staff' ? 'text-blue-700' : 'text-slate-400'">Staff</span>
                <span class="text-[8px] text-slate-500 mt-0.5">ใช้งานทั่วไป</span>
              </label>
              <label class="relative flex flex-col p-3 rounded-lg border-2 cursor-pointer transition"
                :class="newUser.role === 'admin' ? 'bg-purple-50/50 border-purple-500 shadow-sm' : 'border-slate-100 hover:bg-slate-50'">
                <input type="radio" v-model="newUser.role" value="admin" class="sr-only">
                <span class="text-[10px] font-black uppercase" :class="newUser.role === 'admin' ? 'text-purple-700' : 'text-slate-400'">Admin</span>
                <span class="text-[8px] text-slate-500 mt-0.5">คุมระบบทั้งหมด</span>
              </label>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="flex gap-3 pt-6 mt-4 border-t border-slate-100">
            <button type="button" @click="isAddModalOpen = false" class="gh-btn px-4 py-2 flex-1">ยกเลิก</button>
            <button type="submit" class="gh-btn bg-[#2da44e] text-white hover:bg-[#2c974b] border-[#1b1f2326] shadow-sm px-4 py-2 flex-1" :disabled="loading">
              <Loader2 v-if="loading" class="w-4 h-4 animate-spin inline mr-2" />
              {{ loading ? 'กำลังบันทึก...' : 'บันทึกข้อมูล' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue';
import axios from 'axios';
import { useAuthStore } from '../../store/auth';
import { getApiBasePath } from '../../config/api';
import { 
  Users, 
  UserPlus, 
  Trash2, 
  X, 
  ShieldCheck, 
  UserCircle2, 
  ShieldAlert,
  Loader2 
} from 'lucide-vue-next';
import { useToast } from 'vue-toastification';

const authStore = useAuthStore();
const toast = useToast();
const users = ref([]);
const isAddModalOpen = ref(false);
const loading = ref(false);

const newUser = reactive({
  name: '',
  email: '',
  password: '',
  role: 'staff'
});

const fetchUsers = async () => {
  try {
    const response = await axios.get(`${getApiBasePath()}/auth/users`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    users.value = response.data;
  } catch (error) {
    console.error('Fetch users failed', error);
  }
};

const handleAddUser = async () => {
  loading.value = true;
  try {
    await axios.post(`${getApiBasePath()}/auth/register`, newUser, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    await fetchUsers();
    toast.success('เพิ่มพนักงานสำเร็จ');
    isAddModalOpen.value = false;
    // Reset form
    newUser.name = '';
    newUser.email = '';
    newUser.password = '';
    newUser.role = 'staff';
  } catch (error) {
    toast.error('ผิดพลาด: ' + (error.response?.data?.message || error.message));
  } finally {
    loading.value = false;
  }
};

const deleteUser = async (id) => {
  if (!confirm('ยืนยันการลบผู้ใช้งานนี้?')) return;
  try {
    await axios.delete(`${getApiBasePath()}/auth/users/${id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    await fetchUsers();
    toast.success('ลบพนักงานสำเร็จ');
  } catch (error) {
    toast.error('ไม่สามารถลบผู้ใช้ได้');
  }
};

onMounted(fetchUsers);
</script>


