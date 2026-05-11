const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Settings = sequelize.define('Settings', {
  id: { type: DataTypes.INTEGER, primaryKey: true, defaultValue: 1 },
  storeName: { type: DataTypes.STRING, defaultValue: 'VIP Phone' },
  storePhone: { type: DataTypes.STRING },
  warrantyDays: { type: DataTypes.INTEGER, defaultValue: 30 },
  termsAndConditions: { type: DataTypes.TEXT },
});

module.exports = Settings;
