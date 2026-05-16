const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Product = require('./Product');
const Customer = require('./Customer');

const Reservation = sequelize.define('Reservation', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  product_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  customer_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  user_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('pending', 'confirmed', 'cancelled', 'completed', 'sold'),
    defaultValue: 'pending',
  },
  deposit_amount: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0.00,
  },
  reservation_date: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  reservation_expires_at: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  slip_image: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  attachment_file: {
    type: DataTypes.STRING,
    allowNull: true,
    comment: 'ชื่อไฟล์หรือ path เอกสารแนบ',
  },
}, {
  timestamps: true,
});

Reservation.belongsTo(Product, { foreignKey: 'product_id' });
Reservation.belongsTo(Customer, { foreignKey: 'customer_id' });

module.exports = Reservation;
