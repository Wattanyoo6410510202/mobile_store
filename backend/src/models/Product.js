const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Product = sequelize.define('Product', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  barcode: {
    type: DataTypes.STRING,
    unique: true,
  },
  imei1: {
    type: DataTypes.STRING,
  },
  imei2: {
    type: DataTypes.STRING,
  },
  serialNumber: {
    type: DataTypes.STRING,
  },
  brand: {
    type: DataTypes.STRING,
  },
  model: {
    type: DataTypes.STRING,
  },
  color: {
    type: DataTypes.STRING,
  },
  storage: {
    type: DataTypes.STRING,
  },
  batteryHealth: {
    type: DataTypes.INTEGER,
  },
  purchasePrice: {
    type: DataTypes.DECIMAL(10, 2),
  },
  sellPrice: {
    type: DataTypes.DECIMAL(10, 2),
  },
  warrantyStartDate: {
    type: DataTypes.DATE,
  },
  saleDate: {
    type: DataTypes.DATE,
  },
  status: {
    type: DataTypes.ENUM('available', 'sold', 'reserved', 'repair'),
    defaultValue: 'available',
  },
  condition: {
    type: DataTypes.ENUM('new', 'used'),
    defaultValue: 'used',
  },
  // Warranty fields
  hasWarranty: { type: DataTypes.BOOLEAN, defaultValue: true },
  warrantyType: { type: DataTypes.ENUM('manufacturer', 'shop'), defaultValue: 'shop' },
  warrantyEndDate: { type: DataTypes.DATE },
  
  // Checklist fields
  isCloudLocked: { type: DataTypes.BOOLEAN, defaultValue: false },
  isResetReady: { type: DataTypes.BOOLEAN, defaultValue: true },
  isMdmLocked: { type: DataTypes.BOOLEAN, defaultValue: false },
  isPromoAttached: { type: DataTypes.BOOLEAN, defaultValue: false },
  isGenuineParts: { type: DataTypes.BOOLEAN, defaultValue: true },
  
  // Hardware test fields
  testTouchscreen: { type: DataTypes.BOOLEAN, defaultValue: true },
  testSpeaker: { type: DataTypes.BOOLEAN, defaultValue: true },
  testMic: { type: DataTypes.BOOLEAN, defaultValue: true },
  testWifi: { type: DataTypes.BOOLEAN, defaultValue: true },
  testBluetooth: { type: DataTypes.BOOLEAN, defaultValue: true },
  testCamera: { type: DataTypes.BOOLEAN, defaultValue: true },
  testFaceId: { type: DataTypes.BOOLEAN, defaultValue: true },
  testFingerprint: { type: DataTypes.BOOLEAN, defaultValue: true },
  testCharging: { type: DataTypes.BOOLEAN, defaultValue: true },
  testSimCard: { type: DataTypes.BOOLEAN, defaultValue: true },

  conditionNote: { type: DataTypes.TEXT },
  thumbnail: { type: DataTypes.STRING },
  vdo360: { type: DataTypes.STRING },
}, {
  timestamps: true,
});

module.exports = Product;
