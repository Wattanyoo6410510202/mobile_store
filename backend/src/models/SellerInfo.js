const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const SellerInfo = sequelize.define('SellerInfo', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  productId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  fullName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  phoneNumber: {
    type: DataTypes.STRING,
  },
  idCardNumber: {
    type: DataTypes.STRING,
  },
  idCardImageUrl: {
    type: DataTypes.STRING,
  },
  sellerWithPhoneImageUrl: {
    type: DataTypes.STRING,
  },
  signatureUrl: {
    type: DataTypes.STRING,
  },
}, {
  timestamps: true,
});

module.exports = SellerInfo;
