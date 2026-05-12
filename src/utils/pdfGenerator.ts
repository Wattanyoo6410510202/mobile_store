import { jsPDF } from 'jspdf';
import 'jspdf-autotable';

type StoreSettings = {
  storeName?: string;
  storePhone?: string;
  warrantyDays?: number;
};

type Product = {
  brand?: string;
  model?: string;
  imei1?: string;
  conditionNote?: string;
};

export const generateWarrantyReceipt = (product: Product, _seller: unknown, store: StoreSettings) => {
  const doc = new jsPDF();

  doc.setFontSize(20);
  doc.text(store.storeName || 'VIP Phone', 105, 20, { align: 'center' });
  doc.setFontSize(12);
  doc.text(`Tel: ${store.storePhone || '-'}`, 105, 28, { align: 'center' });
  
  doc.line(20, 35, 190, 35);
  doc.setFontSize(16);
  doc.text('ใบรับประกันสินค้า', 105, 45, { align: 'center' });
  
  doc.setFontSize(12);
  doc.text(`สินค้า: ${product.brand || '-'} ${product.model || ''}`.trim(), 20, 60);
  doc.text(`IMEI: ${product.imei1 || '-'}`, 20, 70);
  doc.text(`วันที่ขาย: ${new Date().toLocaleDateString('th-TH')}`, 20, 80);

  doc.setFontSize(10);
  doc.text('เงื่อนไขการรับประกัน:', 20, 100);
  doc.text(`- รับประกันการใช้งานปกติ ${store.warrantyDays || 30} วัน`, 20, 110);
  doc.text('- ไม่รวมกรณีตกน้ำ หรือจอแตก', 20, 120);
  doc.text('- ต้องนำใบนี้มาแสดงเมื่อเกิดปัญหา', 20, 130);
  
  doc.text(`หมายเหตุ: ${product.conditionNote || '-'}`, 20, 145);

  doc.line(20, 180, 90, 180);
  doc.text('ลงชื่อผู้ขาย (VIP Phone)', 55, 185, { align: 'center' });
  
  doc.line(120, 180, 190, 180);
  doc.text('ลงชื่อลูกค้า', 155, 185, { align: 'center' });

  doc.save(`warranty_${product.model || 'product'}.pdf`);
};
