const Product = require('../models/Product');
const { Op } = require('sequelize');

exports.getReportData = async (req, res) => {
  try {
    const products = await Product.findAll();
    console.log('DEBUG: All products count:', products.length);

    // 1. Sales Performance (แสดงข้อมูลสินค้าทั้งหมดเพื่อทดสอบ)
    const salesData = products.reduce((acc, p) => {
      const date = new Date(p.createdAt).toLocaleDateString('en-US', { month: 'short' });
      acc[date] = (acc[date] || 0) + Number(p.sellPrice || 0);
      return acc;
    }, {});

    // 2. Inventory Status (ทุกสถานะ)
    const statusCount = products.reduce((acc, p) => {
      acc[p.status] = (acc[p.status] || 0) + 1;
      return acc;
    }, {});

    res.json({
      salesData: {
        labels: Object.keys(salesData),
        values: Object.values(salesData)
      },
      inventoryData: {
        labels: Object.keys(statusCount),
        values: Object.values(statusCount)
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Error generating report', error: error.message });
  }
};
