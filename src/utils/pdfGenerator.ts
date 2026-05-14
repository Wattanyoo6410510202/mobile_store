import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

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
  qcStatus?: string;
};

type Customer = {
  name?: string;
  email?: string;
};

export const generateWarrantyReceipt = (product: Product, customer: Customer, store: StoreSettings) => {
  const doc = new jsPDF();
  const certId = `CERT-${Date.now().toString().slice(-8)}`;

  // 1. Header
  doc.setFontSize(24);
  doc.setTextColor(44, 62, 80);
  doc.text(store.storeName?.toUpperCase() || 'VIP PHONE', 15, 20);
  doc.setFontSize(10);
  doc.setTextColor(100);
  doc.text(`Certificate No: ${certId}`, 195, 20, { align: 'right' });
  doc.text(`Contact: ${store.storePhone || '-'}`, 15, 26);
  doc.line(15, 32, 195, 32);

  // 2. Title
  doc.setFontSize(18);
  doc.setTextColor(0);
  doc.text('OFFICIAL WARRANTY & INSPECTION CERTIFICATE', 105, 45, { align: 'center' });

  // 3. Customer & Product Table
  autoTable(doc, {
    startY: 55,
    head: [['CUSTOMER & SALES DATA', 'PRODUCT SPECIFICATIONS']],
    body: [
      [
        `Name: ${customer.name || 'N/A'}\nEmail: ${customer.email || 'N/A'}`,
        `Brand: ${product.brand || '-'}\nModel: ${product.model || '-'}\nIMEI: ${product.imei1 || '-'}`
      ]
    ],
    theme: 'grid',
    headStyles: { fillColor: [44, 62, 80] },
    margin: { left: 15, right: 15 },
  });

  // 4. Quality Status
  autoTable(doc, {
    startY: (doc as any).lastAutoTable.finalY + 5,
    head: [['INSPECTION CATEGORY', 'STATUS', 'REMARKS']],
    body: [
      ['Hardware Functional Test', product.qcStatus || 'PASS', 'Verified'],
      ['Battery Health/Performance', 'PASS', 'Tested'],
      ['Screen/Display Quality', 'PASS', 'No Defects'],
      ['Port/Connectivity Check', 'PASS', 'Stable'],
      ['Security/Software Integrity', 'PASS', 'Cleared'],
    ],
    theme: 'grid',
    headStyles: { fillColor: [80, 80, 80] },
    margin: { left: 15, right: 15 },
  });

  // 5. Detailed Terms & Legal
  const termsY = (doc as any).lastAutoTable.finalY + 10;
  doc.setFontSize(11);
  doc.text('Terms of Warranty & Liability:', 15, termsY);
  
  doc.setFontSize(7.5);
  doc.setTextColor(50);
  const terms = [
    '1. LIMITED WARRANTY: This device is covered against manufacturing defects for the specified warranty period.',
    '2. SCOPE OF COVERAGE: Warranty service includes repair or, at the store\'s discretion, replacement of defective components.',
    '3. EXCLUSIONS: Warranty is void if the device shows signs of liquid exposure, physical trauma, unauthorized tampering, or screen cracking.',
    '4. DATA PRIVACY: The store is not responsible for any data loss. Always maintain a cloud/local backup.',
    '5. LIMITATION OF LIABILITY: Store shall not be held liable for indirect, incidental, or consequential damages.',
    '6. MAINTENANCE TIPS: Use only certified cables/adapters. Avoid extreme heat or pressure on the display.',
    '7. RETURN/EXCHANGE: Valid only within 7 days in original, undamaged condition with full packaging.',
    '8. AUTHORIZATION: Repairs must be performed by authorized technicians only to keep the warranty active.',
    '9. ACKNOWLEDGMENT: By signing, the customer acknowledges receiving the device in satisfactory condition and accepts all terms herein.',
    `Special Condition Notes: ${product.conditionNote || 'None'}`
  ];
  doc.text(terms, 15, termsY + 6, { maxWidth: 180, lineHeightFactor: 1.6 });

  // 6. Footer (Signature Space & Stamp)
  doc.line(15, 245, 195, 245);
  doc.setFontSize(7);
  doc.text('This document is a formal record of product quality and warranty status. Non-transferable.', 105, 250, { align: 'center' });
  
  // Drawing Official Stamp
  doc.setDrawColor(200, 0, 0); 
  doc.setLineWidth(1);
  doc.circle(170, 260, 15, 'S');
  doc.setTextColor(200, 0, 0);
  doc.setFontSize(8);
  doc.text('OFFICIAL', 170, 258, { align: 'center' });
  doc.text('VIP PHONE', 170, 263, { align: 'center' });
  doc.text('VERIFIED', 170, 268, { align: 'center' });
  doc.setTextColor(0); 
  
  const signY = 275;
  doc.line(20, signY, 80, signY);
  doc.text('Sales Consultant', 50, signY + 5, { align: 'center' });
  
  doc.line(100, signY, 160, signY);
  doc.text('Customer Signature', 130, signY + 5, { align: 'center' });

  doc.save(`warranty_${certId}.pdf`);
};
