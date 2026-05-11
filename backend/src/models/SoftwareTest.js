const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const SoftwareTest = sequelize.define('SoftwareTest', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  productId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  testData: {
    type: DataTypes.JSON,
  },
  testedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  testerName: {
    type: DataTypes.STRING,
  },
}, {
  timestamps: true,
});

module.exports = SoftwareTest;
