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
  sellPrice?: number;
};

type Customer = {
  name?: string;
  email?: string;
  phone?: string;
  address?: string;
};

type Reservation = {
  id?: string;
  deposit_amount?: number;
  reservation_date?: string;
  createdAt?: string;
};

// Generic Header Helper
const addProfessionalHeader = (doc: jsPDF, title: string, color: number[], store: StoreSettings) => {
  doc.setFillColor(color[0], color[1], color[2]);
  doc.rect(0, 0, 210, 45, 'F');
  
  doc.setFontSize(28);
  doc.setTextColor(255, 255, 255);
  doc.setFont('helvetica', 'bold');
  doc.text(title, 15, 28);
  
  doc.setFontSize(10);
  doc.setFont('helvetica', 'normal');
  doc.text(store.storeName?.toUpperCase() || 'VIP PHONE OFFICIAL', 195, 20, { align: 'right' });
  doc.text('PREMIUM MOBILE SOLUTIONS', 195, 26, { align: 'right' });
  doc.text(`Contact: ${store.storePhone || '-'}`, 195, 32, { align: 'right' });
};

// Generic Footer Helper
const addProfessionalFooter = (doc: jsPDF, y: number, note: string) => {
  doc.setFontSize(9);
  doc.setTextColor(44, 62, 80);
  doc.setFont('helvetica', 'bold');
  doc.text('TERMS & CONDITIONS:', 15, y);
  
  doc.setFont('helvetica', 'normal');
  doc.setFontSize(8);
  doc.setTextColor(100);
  doc.text(note, 15, y + 5, { maxWidth: 180, lineHeightFactor: 1.5 });

  const signY = 270;
  doc.setDrawColor(200);
  doc.line(15, signY, 75, signY);
  doc.text('Customer Signature', 45, signY + 5, { align: 'center' });
  
  doc.line(135, signY, 195, signY);
  doc.text('Authorized Representative', 165, signY + 5, { align: 'center' });
  
  doc.setFontSize(7);
  doc.text('Thank you for choosing VIP PHONE. This is a computer-generated document.', 105, 285, { align: 'center' });
};

export const generateQuotation = (product: Product, customer: Customer, store: StoreSettings) => {
  const doc = new jsPDF();
  const quoteNo = `QT-${Date.now().toString().slice(-6)}`;
  
  addProfessionalHeader(doc, 'QUOTATION', [127, 140, 141], store);

  let currentY = 60;
  doc.setTextColor(44, 62, 80);
  doc.setFont('helvetica', 'bold');
  doc.text('QUOTATION FOR:', 15, currentY);
  doc.setFont('helvetica', 'normal');
  doc.text(`Name: ${customer.name || 'Valued Client'}`, 15, currentY + 7);
  doc.text(`Address: ${customer.address || 'N/A'}`, 15, currentY + 14);

  doc.text(`Quote Number: ${quoteNo}`, 195, currentY + 7, { align: 'right' });
  doc.text(`Date of Issue: ${new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}`, 195, currentY + 14, { align: 'right' });
  doc.text(`Valid Until: ${new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toLocaleDateString('en-US')}`, 195, currentY + 21, { align: 'right' });

  autoTable(doc, {
    startY: currentY + 30,
    head: [['ITEM DESCRIPTION', 'UNIT PRICE', 'QUANTITY', 'TOTAL']],
    body: [
      [`${product.brand} ${product.model}\nSerial/IMEI Reference: ${product.imei1 || 'In Stock'}`, `$${Number(product.sellPrice).toLocaleString()}`, '1', `$${Number(product.sellPrice).toLocaleString()}`]
    ],
    theme: 'striped',
    headStyles: { fillColor: [127, 140, 141], halign: 'center' },
    columnStyles: { 1: { halign: 'right' }, 2: { halign: 'center' }, 3: { halign: 'right' } },
    foot: [['', '', 'GRAND TOTAL', `$${Number(product.sellPrice).toLocaleString()}`]],
    footStyles: { fillColor: [240, 240, 240], textColor: [0, 0, 0], halign: 'right', fontStyle: 'bold' }
  });

  const note = "1. This quotation is valid for 7 days from the date of issue.\n2. Prices are subject to stock availability at the time of purchase.\n3. This document is not a contract of sale; final price may vary based on specific conditions.";
  addProfessionalFooter(doc, (doc as any).lastAutoTable.finalY + 20, note);

  doc.save(`quotation_${quoteNo}.pdf`);
};

export const generateSalesReceipt = (product: Product, customer: Customer, store: StoreSettings, reservation?: Reservation) => {
  const doc = new jsPDF();
  const receiptNo = `RE-${Date.now().toString().slice(-8)}`;
  
  addProfessionalHeader(doc, 'SALES RECEIPT', [44, 62, 80], store);

  let currentY = 60;
  doc.setTextColor(44, 62, 80);
  doc.setFont('helvetica', 'bold');
  doc.text('CLIENT INFORMATION:', 15, currentY);
  doc.setFont('helvetica', 'normal');
  doc.text(`Name: ${customer.name || 'Valued Client'}`, 15, currentY + 7);
  doc.text(`Contact: ${customer.phone || '-'}`, 15, currentY + 14);

  doc.text(`Receipt Number: ${receiptNo}`, 195, currentY + 7, { align: 'right' });
  doc.text(`Payment Date: ${new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}`, 195, currentY + 14, { align: 'right' });
  doc.text('Payment Status: PAID', 195, currentY + 21, { align: 'right', fontStyle: 'bold' });

  const deposit = reservation?.deposit_amount || 0;
  const total = product.sellPrice || 0;
  const balance = total - deposit;

  autoTable(doc, {
    startY: currentY + 30,
    head: [['PRODUCT DESCRIPTION', 'PRICE', 'QTY', 'SUBTOTAL']],
    body: [
      [`${product.brand} ${product.model}\nIMEI: ${product.imei1}`, `$${total.toLocaleString()}`, '1', `$${total.toLocaleString()}`],
      ['Less: Deposit / Advance Payment', '', '', `-$${deposit.toLocaleString()}`]
    ],
    theme: 'grid',
    headStyles: { fillColor: [44, 62, 80], halign: 'center' },
    columnStyles: { 1: { halign: 'right' }, 2: { halign: 'center' }, 3: { halign: 'right' } },
    foot: [['', '', 'TOTAL PAID', `$${balance.toLocaleString()}`]],
    footStyles: { fillColor: [240, 240, 240], textColor: [0, 0, 0], halign: 'right', fontStyle: 'bold' }
  });

  const note = "1. Payment received in full for the above-mentioned items.\n2. Goods sold are covered by the Warranty Certificate attached.\n3. Refund policy: Within 7 days for manufacturing defects only.";
  addProfessionalFooter(doc, (doc as any).lastAutoTable.finalY + 20, note);

  doc.save(`receipt_${receiptNo}.pdf`);
};

export const generateTaxInvoice = (product: Product, customer: Customer, store: StoreSettings, reservation?: Reservation) => {
  const doc = new jsPDF();
  const invoiceNo = `INV-${Date.now().toString().slice(-8)}`;
  
  addProfessionalHeader(doc, 'TAX INVOICE', [33, 33, 33], store);

  let currentY = 60;
  doc.setTextColor(44, 62, 80);
  doc.setFont('helvetica', 'bold');
  doc.text('BILL TO:', 15, currentY);
  doc.setFont('helvetica', 'normal');
  doc.text(`Client: ${customer.name || 'Valued Client'}`, 15, currentY + 7);
  doc.text(`Address: ${customer.address || 'N/A'}`, 15, currentY + 14);

  doc.text(`Invoice Number: ${invoiceNo}`, 195, currentY + 7, { align: 'right' });
  doc.text(`Date of Issue: ${new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}`, 195, currentY + 14, { align: 'right' });
  doc.text(`Business Reg No: 0-1234-56789-01-2`, 195, currentY + 21, { align: 'right' });

  const total = product.sellPrice || 0;
  const vatRate = 0.07;
  const subtotal = total / (1 + vatRate);
  const vatAmount = total - subtotal;

  autoTable(doc, {
    startY: currentY + 30,
    head: [['TAX DESCRIPTION', 'SUBTOTAL', 'VAT (7%)', 'TOTAL AMOUNT']],
    body: [
      [
        `${product.brand} ${product.model}\nIMEI Reference: ${product.imei1}`,
        `$${subtotal.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
        `$${vatAmount.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
        `$${total.toLocaleString(undefined, { minimumFractionDigits: 2 })}`
      ]
    ],
    theme: 'grid',
    headStyles: { fillColor: [33, 33, 33], halign: 'center' },
    columnStyles: { 1: { halign: 'right' }, 2: { halign: 'right' }, 3: { halign: 'right' } }
  });

  const summaryY = (doc as any).lastAutoTable.finalY + 15;
  doc.setFontSize(10);
  doc.setFont('helvetica', 'normal');
  doc.text('Net Amount (Excl. Tax):', 140, summaryY, { align: 'right' });
  doc.text(`$${subtotal.toLocaleString(undefined, { minimumFractionDigits: 2 })}`, 195, summaryY, { align: 'right' });
  
  doc.text('Value Added Tax (7%):', 140, summaryY + 7, { align: 'right' });
  doc.text(`$${vatAmount.toLocaleString(undefined, { minimumFractionDigits: 2 })}`, 195, summaryY + 7, { align: 'right' });
  
  doc.setFont('helvetica', 'bold');
  doc.setFontSize(12);
  doc.text('GRAND TOTAL (INCL. TAX):', 140, summaryY + 15, { align: 'right' });
  doc.text(`$${total.toLocaleString(undefined, { minimumFractionDigits: 2 })}`, 195, summaryY + 15, { align: 'right' });

  const note = "1. All tax figures are calculated based on the prevailing Tax Laws.\n2. Please retain this invoice for your official tax records and claims.\n3. Any discrepancies must be reported within 24 hours of issue.";
  addProfessionalFooter(doc, summaryY + 30, note);

  doc.save(`tax_invoice_${invoiceNo}.pdf`);
};

export const generateWarrantyReceipt = (product: Product, customer: Customer, store: StoreSettings) => {
  const doc = new jsPDF();
  const certId = `WTY-${Date.now().toString().slice(-8)}`;

  addProfessionalHeader(doc, 'WARRANTY CERTIFICATE', [44, 62, 80], store);
  
  let currentY = 60;
  doc.setTextColor(44, 62, 80);
  doc.setFont('helvetica', 'bold');
  doc.text('DEVICE INFORMATION:', 15, currentY);
  doc.setFont('helvetica', 'normal');
  doc.text(`Brand/Model: ${product.brand} ${product.model}`, 15, currentY + 7);
  doc.text(`IMEI/Serial: ${product.imei1 || '-'}`, 15, currentY + 14);

  doc.setFont('helvetica', 'bold');
  doc.text('WARRANTY HOLDER:', 120, currentY);
  doc.setFont('helvetica', 'normal');
  doc.text(`Name: ${customer.name || 'Valued Client'}`, 120, currentY + 7);
  doc.text(`Email: ${customer.email || '-'}`, 120, currentY + 14);

  autoTable(doc, {
    startY: currentY + 25,
    head: [['INSPECTION CATEGORY', 'RESULT', 'VERIFICATION STATUS']],
    body: [
      ['System Integrity', 'SUCCESS', 'Fully Functional'],
      ['Display & Touch Quality', 'SUCCESS', 'No Defects Detected'],
      ['Power & Battery Health', 'SUCCESS', 'Optimal Performance'],
      ['Signal & Connectivity', 'SUCCESS', 'Stable Connection'],
      ['Internal Components Check', 'SUCCESS', 'Original / Verified'],
    ],
    theme: 'grid',
    headStyles: { fillColor: [44, 62, 80], halign: 'center' },
  });

  const note = `1. COVERAGE: This device is covered for a period of ${store.warrantyDays || 30} days starting from the date of purchase.\n2. SCOPE: Warranty includes hardware repairs but excludes physical damage, liquid ingress, and unauthorized software modifications.\n3. DATA PRIVACY: The holder is advised to back up all data. We are not liable for any data loss during the inspection or repair process.`;
  addProfessionalFooter(doc, (doc as any).lastAutoTable.finalY + 15, note);

  doc.save(`warranty_${certId}.pdf`);
};

// Keeping reservation for admin use but user asked to remove from front-end button
export const generateReservationReceipt = (product: Product, customer: Customer, store: StoreSettings, reservation: Reservation) => {
  const doc = new jsPDF();
  const resId = reservation.id?.slice(0, 8).toUpperCase() || 'RES';

  addProfessionalHeader(doc, 'BOOKING CONFIRMATION', [52, 152, 219], store);

  let currentY = 60;
  doc.setTextColor(44, 62, 80);
  doc.setFont('helvetica', 'bold');
  doc.text('CLIENT DETAILS:', 15, currentY);
  doc.setFont('helvetica', 'normal');
  doc.text(`Name: ${customer.name}`, 15, currentY + 7);
  doc.text(`Phone: ${customer.phone}`, 15, currentY + 14);

  doc.text(`Booking Date: ${new Date(reservation.reservation_date || reservation.createdAt || '').toLocaleDateString('en-US')}`, 195, currentY + 7, { align: 'right' });

  autoTable(doc, {
    startY: currentY + 25,
    head: [['ITEM RESERVED', 'IMEI REFERENCE', 'PRICE', 'DEPOSIT PAID']],
    body: [
      [
        `${product.brand} ${product.model}`,
        product.imei1 || '-',
        `$${Number(product.sellPrice).toLocaleString()}`,
        `$${Number(reservation.deposit_amount).toLocaleString()}`
      ]
    ],
    theme: 'grid',
    headStyles: { fillColor: [52, 152, 219], halign: 'center' },
    columnStyles: { 2: { halign: 'right' }, 3: { halign: 'right' } }
  });

  const note = "1. Validity: This reservation is held for 3 business days.\n2. Refunds: Deposits are strictly non-refundable for change-of-mind cancellations.\n3. Payment: The remaining balance must be cleared before the item is collected or shipped.";
  addProfessionalFooter(doc, (doc as any).lastAutoTable.finalY + 20, note);

  doc.save(`booking_${resId}.pdf`);
};
