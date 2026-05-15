<template>
  <div class="max-w-6xl mx-auto space-y-6 p-6">
    <!-- Header -->
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200 flex justify-between items-center">
      <h2 class="text-xl font-bold text-slate-800">Sales & Inventory Report</h2>
      <button @click="downloadPDF" class="gh-btn bg-emerald-600 text-white hover:bg-emerald-700 px-6">Download PDF (EN)</button>
    </div>

    <!-- Charts -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200">
        <h3 class="text-sm font-bold text-slate-800 mb-4">Sales Performance</h3>
        <Bar ref="barChart" :key="JSON.stringify(salesChartData)" :data="salesChartData" :options="chartOptions" />
      </div>
      <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-200">
        <h3 class="text-sm font-bold text-slate-800 mb-4">Inventory Status</h3>
        <Doughnut ref="doughnutChart" :key="JSON.stringify(inventoryChartData)" :data="inventoryChartData" :options="chartOptions" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { Bar, Doughnut } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement } from 'chart.js';
import jsPDF from 'jspdf';
import 'jspdf-autotable';
import axios from 'axios';
import { useAuthStore } from '../store/auth';
import { useToast } from 'vue-toastification';
import { getApiBasePath } from '../config/api';

// ต้องเรียกใช้ autoTable หลังจาก import
import autoTable from 'jspdf-autotable';

const toast = useToast();
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement);

const authStore = useAuthStore();

const salesChartData = ref({ labels: [], datasets: [{ label: 'Sales (฿)', data: [], backgroundColor: '#2563eb' }] });
const inventoryChartData = ref({ labels: [], datasets: [{ data: [], backgroundColor: ['#10b981', '#f59e0b', '#ef4444', '#8b5cf6'] }] });
const chartOptions = { responsive: true };

const fetchData = async () => {
  try {
    const res = await axios.get(`${getApiBasePath()}/reports`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    });
    
    // Update Sales Chart
    salesChartData.value.labels = res.data.salesData.labels;
    salesChartData.value.datasets[0].data = res.data.salesData.values;
    
    // Update Inventory Chart
    inventoryChartData.value.labels = res.data.inventoryData.labels;
    inventoryChartData.value.datasets[0].data = res.data.inventoryData.values;
  } catch (err) { 
    console.error('Failed to fetch report data:', err); 
    toast.error('Could not load report data');
  }
};

const barChart = ref(null);
const doughnutChart = ref(null);

const downloadPDF = () => {
  const doc = new jsPDF();
  
  // คำนวณข้อมูลสรุป
  const totalSales = salesChartData.value.datasets[0].data.reduce((a, b) => a + b, 0);
  const totalStock = inventoryChartData.value.datasets[0].data.reduce((a, b) => a + b, 0);
  
  doc.setFontSize(18);
  doc.text('Sales & Inventory Report', 14, 20);
  doc.setFontSize(12);
  doc.text(`Generated on: ${new Date().toLocaleDateString()}`, 14, 30);
  
  autoTable(doc, {
    head: [['Category', 'Value']],
    body: [
      ['Total Sales', `฿${totalSales.toLocaleString()}`],
      ['Total Stock Items', totalStock.toString()]
    ],
    startY: 40
  });

  // เพิ่มกราฟลงใน PDF หน้าเดียว
  let currentY = doc.lastAutoTable.finalY + 10;
  
  if (barChart.value?.chart) {
    const barImg = barChart.value.chart.toBase64Image();
    doc.setFontSize(12);
    doc.text('Sales Performance Chart:', 14, currentY);
    doc.addImage(barImg, 'PNG', 14, currentY + 5, 85, 60);
  }

  if (doughnutChart.value?.chart) {
    const doughnutImg = doughnutChart.value.chart.toBase64Image();
    doc.text('Inventory Status Chart:', 110, currentY);
    doc.addImage(doughnutImg, 'PNG', 110, currentY + 5, 60, 60);
  }
  
  doc.save('report_en.pdf');
};

onMounted(fetchData);
</script>
