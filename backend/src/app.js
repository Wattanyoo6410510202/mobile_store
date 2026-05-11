const express = require('express');
const cors = require('cors');
const path = require('path');
const sequelize = require('./config/database');
require('dotenv').config();

// Models
const User = require('./models/User');
const Product = require('./models/Product');
const ProductImage = require('./models/ProductImage');
const SellerInfo = require('./models/SellerInfo');
const SoftwareTest = require('./models/SoftwareTest');
const Settings = require('./models/Settings');

// Associations
Product.hasMany(ProductImage, { foreignKey: 'productId', as: 'images' });
ProductImage.belongsTo(Product, { foreignKey: 'productId' });

Product.hasOne(SellerInfo, { foreignKey: 'productId', as: 'seller' });
SellerInfo.belongsTo(Product, { foreignKey: 'productId' });

Product.hasMany(SoftwareTest, { foreignKey: 'productId', as: 'tests' });
SoftwareTest.belongsTo(Product, { foreignKey: 'productId' });

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/products', require('./routes/productRoutes'));
app.get('/api/settings', async (req, res) => {
    const settings = await Settings.findByPk(1) || await Settings.create({});
    res.json(settings);
});
app.put('/api/settings', async (req, res) => {
    let settings = await Settings.findByPk(1);
    settings = await settings.update(req.body);
    res.json(settings);
});

// Routes placeholder
app.get('/', (req, res) => {
  res.send('Phone Store API is running...');
});

// Sync Database and Start Server
sequelize.sync({ force: true })
  .then(() => {
    console.log('Database synced');
    
    // Seed admin if not exists (safer than force: true)
    const User = require('./models/User');
    const bcrypt = require('bcryptjs');
    bcrypt.hash('admin123', 10).then(hash => {
        User.findOrCreate({
            where: { email: 'admin@example.com' },
            defaults: {
                name: 'Administrator',
                password: hash,
                role: 'admin'
            }
        });
    });
    
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('Failed to sync database:', err);
  });
