<template>
  <div class="space-y-4">
    <div class="gh-surface gh-card p-4 sm:p-6">
      <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-3 mb-4">
        <div>
          <h1 class="gh-h1">รายการการจอง</h1>
          <p class="gh-subtitle mt-1">ข้อมูลจากตาราง reservations (สินค้า + ลูกค้า)</p>
        </div>
        <div class="flex flex-wrap items-center gap-2 w-full sm:w-auto sm:justify-end">
          <div class="relative flex-1 min-w-[200px] sm:min-w-[240px] sm:flex-initial">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500 pointer-events-none" />
            <input
              v-model="searchQuery"
              type="search"
              placeholder="ค้นหา..."
              class="gh-input w-full pl-9"
              autocomplete="off"
            />
          </div>
          <button type="button" class="gh-btn" title="Export Excel" @click="exportToExcel">
            <Download class="w-4 h-4" />
          </button>
          <button type="button" class="gh-btn" :disabled="loading" @click="fetchReservations">
            <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />
            <span>รีเฟรช</span>
          </button>
        </div>
      </div>

      <div v-if="error" class="mb-4 rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm font-semibold text-red-800">
        {{ error }}
      </div>

      <div class="overflow-x-auto border rounded-lg" :style="{ borderColor: 'var(--gh-border-default)' }">
        <table class="w-full min-w-[820px] text-left text-sm text-slate-700">
          <thead
            class="text-slate-600 uppercase text-xs font-bold"
            :style="{ background: 'var(--gh-canvas-subtle)', borderBottom: '1px solid var(--gh-border-default)' }"
          >
            <tr>
              <th class="px-4 py-3">สินค้า</th>
              <th class="px-4 py-3">ลูกค้า</th>
              <th class="px-4 py-3">มัดจำ</th>
              <th class="px-4 py-3">วันที่จอง</th>
              <th class="px-4 py-3">หมดอายุ</th>
              <th class="px-4 py-3">สถานะ</th>
              <th class="px-4 py-3">ไฟล์</th>
              <th class="px-4 py-3">หมายเหตุ</th>
              <th class="px-4 py-3 w-24">จัดการ</th>
            </tr>
          </thead>
          <tbody class="divide-y" :style="{ borderColor: 'var(--gh-border-muted)' }">
            <tr
              v-for="row in filteredReservations"
              :key="row.id"
              class="hover:bg-[var(--gh-canvas-subtle)] transition align-top"
            >
              <td class="px-4 py-3">
                <p class="font-semibold text-slate-900">{{ productLabel(row) }}</p>
                <p class="text-xs text-slate-500 font-mono mt-0.5">{{ row.product_id }}</p>
              </td>
              <td class="px-4 py-3">
                <p class="font-medium text-slate-800">{{ customerLabel(row) }}</p>
                <p v-if="customerPhone(row)" class="text-xs text-slate-500">{{ customerPhone(row) }}</p>
              </td>
              <td class="px-4 py-3 font-semibold whitespace-nowrap">
                ฿{{ Number(row.deposit_amount ?? 0).toLocaleString() }}
              </td>
              <td class="px-4 py-3 text-xs whitespace-nowrap">{{ formatDate(row.reservation_date || row.createdAt) }}</td>
              <td class="px-4 py-3 text-xs whitespace-nowrap">{{ formatDate(row.reservation_expires_at) }}</td>
              <td class="px-4 py-3">
                <select
                  :value="row.status"
                  class="gh-input !py-1.5 !text-xs font-semibold max-w-[140px]"
                  :disabled="updatingId === row.id"
                  @change="onStatusChange(row, $event)"
                >
                  <option value="pending">รอดำเนินการ</option>
                  <option value="confirmed">ยืนยันแล้ว</option>
                  <option value="cancelled">ยกเลิก</option>
                  <option value="completed">เสร็จสิ้น</option>
                  <option value="sold">ขายแล้ว</option>
                </select>
              </td>
              <td class="px-4 py-3 text-xs">
                <div class="flex flex-col gap-1">
                  <a
                    v-if="row.slip_image"
                    :href="fileUrl(row.slip_image)"
                    target="_blank"
                    rel="noopener"
                    class="text-[var(--gh-accent-fg)] font-semibold hover:underline"
                  >สลิป</a>
                  <a
                    v-if="row.attachment_file"
                    :href="fileUrl(row.attachment_file)"
                    target="_blank"
                    rel="noopener"
                    class="text-[var(--gh-accent-fg)] font-semibold hover:underline"
                  >แนบ</a>
                  <span v-if="!row.slip_image && !row.attachment_file" class="text-slate-400">—</span>
                </div>
              </td>
              <td class="px-4 py-3 text-xs text-slate-600 max-w-[180px]">
                <span class="line-clamp-2">{{ row.notes || '—' }}</span>
              </td>
              <td class="px-4 py-3">
                <div class="flex items-center gap-1">
                  <button
                    type="button"
                    class="gh-btn !p-2"
                    title="แก้ไข"
                    @click="openEditModal(row)"
                  >
                    <Pencil class="w-4 h-4" />
                  </button>
                  <button
                    v-if="row.status === 'sold'"
                    type="button"
                    class="gh-btn !p-2 text-emerald-600"
                    title="พิมพ์ใบเสร็จ"
                    @click="printReceipt(row)"
                  >
                    <FileText class="w-4 h-4" />
                  </button>
                  <button
                    v-if="row.status === 'sold'"
                    type="button"
                    class="gh-btn !p-2 text-blue-600"
                    title="พิมพ์ใบกำกับ"
                    @click="printInvoice(row)"
                  >
                    <Printer class="w-4 h-4" />
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="!loading && reservations.length === 0">
              <td colspan="9" class="px-4 py-10 text-center text-slate-500 font-medium">ยังไม่มีรายการจอง</td>
            </tr>
            <tr v-else-if="!loading && filteredReservations.length === 0">
              <td colspan="9" class="px-4 py-10 text-center text-slate-500 font-medium">ไม่พบรายการที่ตรงกับการค้นหา</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Edit modal -->
    <div
      v-if="editModalOpen"
      class="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-0 sm:p-4 bg-slate-900/50"
      role="dialog"
      aria-modal="true"
      @click.self="closeEditModal"
    >
      <div class="bg-white rounded-t-xl sm:rounded-xl border shadow-xl w-full max-w-lg max-h-[90vh] overflow-y-auto" :style="{ borderColor: 'var(--gh-border-default)' }">
        <div class="flex items-center justify-between px-4 py-3 border-b" :style="{ borderColor: 'var(--gh-border-default)' }">
          <h2 class="text-sm font-extrabold text-slate-900">แก้ไขการจอง</h2>
          <button type="button" class="gh-btn !p-2" aria-label="ปิด" @click="closeEditModal">
            <X class="w-4 h-4" />
          </button>
        </div>
        <div v-if="editingRow" class="p-4 space-y-4">
          <div class="text-xs text-slate-600 space-y-1">
            <p><span class="font-semibold text-slate-800">สินค้า:</span> {{ productLabel(editingRow) }}</p>
            <p><span class="font-semibold text-slate-800">ลูกค้า:</span> {{ customerLabel(editingRow) }} {{ customerPhone(editingRow) }}</p>
          </div>

          <div class="space-y-1">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">ค่ามัดจำ (บาท)</label>
            <input v-model="editForm.deposit_amount" type="number" min="0" step="0.01" class="gh-input" />
          </div>

          <div class="space-y-1">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">วันหมดอายุการจอง</label>
            <input v-model="editForm.reservation_expires_at" type="datetime-local" class="gh-input" />
            <p class="text-[11px] text-slate-500">เว้นว่างได้ = ไม่กำหนดวันหมดอายุ</p>
          </div>

          <div class="space-y-1">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">สลิป / หลักฐาน (slip_image)</label>
            <input ref="slipInputRef" type="file" accept="image/*,.pdf" class="gh-input !py-2 text-xs" @change="onSlipFile" />
            <a
              v-if="editingRow.slip_image"
              :href="fileUrl(editingRow.slip_image)"
              target="_blank"
              rel="noopener"
              class="text-xs font-semibold text-[var(--gh-accent-fg)] hover:underline"
            >ดูไฟล์ปัจจุบัน</a>
          </div>

          <div class="space-y-1">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">ไฟล์แนบ (attachment_file)</label>
            <input ref="attachInputRef" type="file" class="gh-input !py-2 text-xs" @change="onAttachFile" />
            <a
              v-if="editingRow.attachment_file"
              :href="fileUrl(editingRow.attachment_file)"
              target="_blank"
              rel="noopener"
              class="text-xs font-semibold text-[var(--gh-accent-fg)] hover:underline"
            >ดูไฟล์ปัจจุบัน</a>
          </div>

          <div class="space-y-1">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wide">หมายเหตุ</label>
            <textarea v-model="editForm.notes" rows="2" class="gh-input resize-y min-h-[72px]" placeholder="—"></textarea>
          </div>

          <p v-if="editModalError" class="text-xs font-semibold text-red-700">{{ editModalError }}</p>

          <div class="flex justify-end gap-2 pt-2">
            <button type="button" class="gh-btn" :disabled="savingEdit" @click="closeEditModal">ยกเลิก</button>
            <button type="button" class="gh-btn gh-btn-primary" :disabled="savingEdit" @click="submitEdit">
              <Loader2 v-if="savingEdit" class="w-4 h-4 animate-spin" />
              <span>บันทึก</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import axios from 'axios';
import { storeToRefs } from 'pinia';
import { useRoute } from 'vue-router';
import { useAuthStore } from '../store/auth';
import { useReservationStore } from '../store/reservation';
import { getApiBasePath, assetUrl } from '../config/api';
import { Loader2, Search, Download, Pencil, X, FileText, Printer } from 'lucide-vue-next';
import * as XLSX from 'xlsx';
import { generateSalesReceipt, generateTaxInvoice } from '../utils/pdfGenerator';

const authStore = useAuthStore();
const route = useRoute();
const reservationStore = useReservationStore();
const { reservationSyncNonce } = storeToRefs(reservationStore);

const storeSettings = ref<any>({});

async function fetchSettings() {
  try {
    const { data } = await axios.get(`${getApiBasePath()}/settings`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    storeSettings.value = data;
  } catch (error) {
    console.error('Failed to fetch settings', error);
  }
}

function printReceipt(row: ReservationRow) {
  generateSalesReceipt(row.Product as any, row.Customer as any, storeSettings.value, row as any);
}

function printInvoice(row: ReservationRow) {
  generateTaxInvoice(row.Product as any, row.Customer as any, storeSettings.value, row as any);
}

type ProductRow = { brand?: string; model?: string };
type CustomerRow = { name?: string; phone?: string };
type ReservationRow = {
  id: string;
  product_id: string;
  customer_id: string;
  status: string;
  deposit_amount?: string | number;
  reservation_date?: string | null;
  reservation_expires_at?: string | null;
  notes?: string | null;
  slip_image?: string | null;
  attachment_file?: string | null;
  createdAt?: string;
  Product?: ProductRow;
  Customer?: CustomerRow;
};

const reservations = ref<ReservationRow[]>([]);
const searchQuery = ref('');
const loading = ref(false);
const updatingId = ref<string | null>(null);
const error = ref('');

const editModalOpen = ref(false);
const editingRow = ref<ReservationRow | null>(null);
const editForm = ref({ deposit_amount: '', reservation_expires_at: '', notes: '' });
const slipFile = ref<File | null>(null);
const attachFile = ref<File | null>(null);
const slipInputRef = ref<HTMLInputElement | null>(null);
const attachInputRef = ref<HTMLInputElement | null>(null);
const savingEdit = ref(false);
const editModalError = ref('');

function fileUrl(path: string) {
  if (!path) return '#';
  const u = assetUrl(path);
  return u || '#';
}

function translateReservationStatus(status: string) {
  const map: Record<string, string> = {
    pending: 'รอดำเนินการ',
    confirmed: 'ยืนยันแล้ว',
    cancelled: 'ยกเลิก',
    completed: 'เสร็จสิ้น',
    sold: 'ขายแล้ว',
  };
  return map[status] || status;
}

function rowSearchText(row: ReservationRow) {
  const q = [
    row.id,
    row.product_id,
    row.customer_id,
    row.status,
    translateReservationStatus(row.status),
    row.notes,
    row.slip_image,
    row.attachment_file,
    productLabel(row),
    row.Product?.brand,
    row.Product?.model,
    customerLabel(row),
    customerPhone(row),
    String(row.deposit_amount ?? ''),
    row.reservation_date,
    row.createdAt,
    row.reservation_expires_at,
    formatDate(row.reservation_date || row.createdAt),
    formatDate(row.reservation_expires_at),
  ]
    .filter(Boolean)
    .join(' ')
    .toLowerCase();
  return q;
}

const filteredReservations = computed(() => {
  const q = searchQuery.value.trim().toLowerCase();
  if (!q) return reservations.value;
  return reservations.value.filter((row) => rowSearchText(row).includes(q));
});

function productLabel(row: ReservationRow) {
  const p = row.Product;
  if (!p) return '—';
  return [p.brand, p.model].filter(Boolean).join(' ') || '—';
}

function customerLabel(row: ReservationRow) {
  return row.Customer?.name || '—';
}

function customerPhone(row: ReservationRow) {
  return row.Customer?.phone || '';
}

function toDatetimeLocal(iso: string | null | undefined): string {
  if (!iso) return '';
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function formatDate(value: string | null | undefined) {
  if (!value) return '—';
  return new Date(value).toLocaleString('th-TH', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

function formatDateForExcel(value: string | null | undefined) {
  if (!value) return '-';
  return new Date(value).toLocaleString('th-TH', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

function exportToExcel() {
  const data = filteredReservations.value.map((row) => ({
    'รหัสจอง': row.id,
    'สินค้า': productLabel(row),
    'รหัสสินค้า': row.product_id,
    'ลูกค้า': customerLabel(row),
    'เบอร์โทร': customerPhone(row) || '-',
    'มัดจำ': row.deposit_amount,
    'วันที่จอง': formatDateForExcel(row.reservation_date || row.createdAt),
    'หมดอายุ': formatDateForExcel(row.reservation_expires_at),
    'สถานะ': translateReservationStatus(row.status),
    'สลิป': row.slip_image || '-',
    'ไฟล์แนบ': row.attachment_file || '-',
    'หมายเหตุ': row.notes || '-',
  }));

  const ws = XLSX.utils.json_to_sheet(data);
  const range = ws['!ref'] ? XLSX.utils.decode_range(ws['!ref']) : null;
  if (range) {
    ws['!autofilter'] = { ref: XLSX.utils.encode_range(range) };
  }
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Reservations');
  XLSX.writeFile(wb, 'reservations_list.xlsx');
}

async function fetchReservations() {
  loading.value = true;
  error.value = '';
  try {
    const { data } = await axios.get<ReservationRow[]>(`${getApiBasePath()}/reservations`, {
      headers: { Authorization: `Bearer ${authStore.token}` },
    });
    reservations.value = Array.isArray(data) ? data : [];
  } catch (e: unknown) {
    const err = e as { response?: { data?: { message?: string } } };
    error.value = err.response?.data?.message || 'โหลดรายการจองไม่สำเร็จ';
    reservations.value = [];
  } finally {
    loading.value = false;
  }
}

async function onStatusChange(row: ReservationRow, e: Event) {
  const target = e.target as HTMLSelectElement;
  const newStatus = target.value;
  if (newStatus === row.status) return;
  updatingId.value = row.id;
  error.value = '';
  try {
    const { data } = await axios.put<ReservationRow>(
      `${getApiBasePath()}/reservations/${row.id}/status`,
      { status: newStatus },
      { headers: { Authorization: `Bearer ${authStore.token}` } },
    );
    mergeUpdatedRow(data);
  } catch (e: unknown) {
    const err = e as { response?: { data?: { message?: string } } };
    error.value = err.response?.data?.message || 'อัปเดตสถานะไม่สำเร็จ';
    await fetchReservations();
  } finally {
    updatingId.value = null;
  }
}

function openEditModal(row: ReservationRow) {
  editingRow.value = row;
  editForm.value = {
    deposit_amount: String(row.deposit_amount ?? '0'),
    reservation_expires_at: toDatetimeLocal(row.reservation_expires_at),
    notes: row.notes || '',
  };
  slipFile.value = null;
  attachFile.value = null;
  editModalError.value = '';
  if (slipInputRef.value) slipInputRef.value.value = '';
  if (attachInputRef.value) attachInputRef.value.value = '';
  editModalOpen.value = true;
}

function closeEditModal() {
  editModalOpen.value = false;
  editingRow.value = null;
  slipFile.value = null;
  attachFile.value = null;
}

function onSlipFile(e: Event) {
  const t = e.target as HTMLInputElement;
  slipFile.value = t.files?.[0] ?? null;
}

function onAttachFile(e: Event) {
  const t = e.target as HTMLInputElement;
  attachFile.value = t.files?.[0] ?? null;
}

function mergeUpdatedRow(updated: ReservationRow) {
  const i = reservations.value.findIndex((r) => r.id === updated.id);
  if (i >= 0) {
    const prev = reservations.value[i];
    reservations.value[i] = {
      ...prev,
      ...updated,
      Product: updated.Product ?? prev.Product,
      Customer: updated.Customer ?? prev.Customer,
    };
  }
}

/** Merge socket `reservation:sync` rows without refetching the full list. */
function mergeReservationRowsFromServer(incoming: ReservationRow[]) {
  const byId = new Map(reservations.value.map((r) => [r.id, { ...r }]));
  for (const row of incoming) {
    const prev = byId.get(row.id);
    if (prev) {
      byId.set(row.id, {
        ...prev,
        ...row,
        Product: row.Product ?? prev.Product,
        Customer: row.Customer ?? prev.Customer,
      });
    } else {
      byId.set(row.id, { ...row });
    }
  }
  const merged = Array.from(byId.values());
  merged.sort((a, b) => {
    const ta = new Date(a.createdAt ?? 0).getTime();
    const tb = new Date(b.createdAt ?? 0).getTime();
    return tb - ta;
  });
  reservations.value = merged;
}

async function submitEdit() {
  if (!editingRow.value) return;
  savingEdit.value = true;
  editModalError.value = '';
  const fd = new FormData();
  fd.append('deposit_amount', editForm.value.deposit_amount === '' ? '0' : editForm.value.deposit_amount);
  if (editForm.value.reservation_expires_at.trim()) {
    const iso = new Date(editForm.value.reservation_expires_at).toISOString();
    fd.append('reservation_expires_at', iso);
  } else {
    fd.append('reservation_expires_at', '');
  }
  fd.append('notes', editForm.value.notes);
  if (slipFile.value) fd.append('slip_image', slipFile.value);
  if (attachFile.value) fd.append('attachment_file', attachFile.value);

  try {
    const { data } = await axios.put<ReservationRow>(
      `${getApiBasePath()}/reservations/${editingRow.value.id}`,
      fd,
      {
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
      },
    );
    mergeUpdatedRow(data);
    closeEditModal();
  } catch (e: unknown) {
    const err = e as { response?: { data?: { message?: string; error?: string } } };
    editModalError.value =
      err.response?.data?.message || err.response?.data?.error || 'บันทึกไม่สำเร็จ';
  } finally {
    savingEdit.value = false;
  }
}

onMounted(() => {
  fetchReservations();
  fetchSettings();
});

watch(reservationSyncNonce, () => {
  if (route.name !== 'ReservationList') return;
  const rows = reservationStore.reservationSyncRows as ReservationRow[];
  if (!rows?.length) return;
  mergeReservationRowsFromServer(rows);
});
</script>
