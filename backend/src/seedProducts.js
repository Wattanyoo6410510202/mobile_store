const Product = require('./models/Product');
const ProductImage = require('./models/ProductImage');
const SellerInfo = require('./models/SellerInfo');
const sequelize = require('./config/database');
const { v4: uuidv4 } = require('uuid');

const sampleProducts = [
  {
    brand: 'Apple',
    model: 'iPhone 15 Pro Max',
    color: 'Natural Titanium',
    storage: '256GB',
    imei1: '358901234567891',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 100,
    purchasePrice: 35000,
    sellPrice: 42900,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Apple',
    model: 'iPhone 14 Pro',
    color: 'Deep Purple',
    storage: '128GB',
    imei1: '358901234567892',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 92,
    purchasePrice: 25000,
    sellPrice: 29900,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Samsung',
    model: 'Galaxy S24 Ultra',
    color: 'Titanium Gray',
    storage: '512GB',
    imei1: '358901234567893',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 100,
    purchasePrice: 32000,
    sellPrice: 38500,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Apple',
    model: 'iPhone 13',
    color: 'Starlight',
    storage: '128GB',
    imei1: '358901234567894',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 88,
    purchasePrice: 14000,
    sellPrice: 17900,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Samsung',
    model: 'Galaxy Z Fold 5',
    color: 'Phantom Black',
    storage: '256GB',
    imei1: '358901234567895',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 98,
    purchasePrice: 28000,
    sellPrice: 34900,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Apple',
    model: 'iPhone 15',
    color: 'Pink',
    storage: '128GB',
    imei1: '358901234567896',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 100,
    purchasePrice: 22000,
    sellPrice: 26500,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Google',
    model: 'Pixel 8 Pro',
    color: 'Obsidian',
    storage: '128GB',
    imei1: '358901234567897',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 99,
    purchasePrice: 19000,
    sellPrice: 23900,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  },
  {
    brand: 'Apple',
    model: 'iPhone 12 Pro',
    color: 'Pacific Blue',
    storage: '256GB',
    imei1: '358901234567898',
    serialNumber: 'SN' + Math.random().toString(36).substring(7).toUpperCase(),
    batteryHealth: 85,
    purchasePrice: 12000,
    sellPrice: 15500,
    condition: 'used',
    status: 'available',
    thumbnail: '/uploads/products/default.jpg'
  }
];

const seedProducts = async () => {
  try {
    await sequelize.sync();
    console.log('Database synced for seeding products...');

    for (const p of sampleProducts) {
      const product = await Product.create({
        id: uuidv4(),
        ...p,
        hasWarranty: true,
        warrantyType: 'shop',
        warrantyEndDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
        isResetReady: true,
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
        testSimCard: true
      });

      // Add dummy seller info
      await SellerInfo.create({
        productId: product.id,
        fullName: 'คุณสมชาย ใจดี',
        phoneNumber: '0812345678'
      });

      console.log(`Added: ${p.brand} ${p.model}`);
    }

    console.log('Successfully seeded 8 products!');
    process.exit(0);
  } catch (error) {
    console.error('Seeding products failed:', error);
    process.exit(1);
  }
};

seedProducts();
