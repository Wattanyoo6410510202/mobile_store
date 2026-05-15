const Product = require('../models/Product');
const ProductImage = require('../models/ProductImage');
const QRCode = require('qrcode');
const path = require('path');
const fs = require('fs');

exports.getProducts = async (req, res) => {
  try {
    const products = await Product.findAll({
      include: [{ model: ProductImage, as: 'images' }],
    });
    res.json(products);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching products', error: error.message });
  }
};

exports.getStats = async (req, res) => {
  try {
    const total = await Product.count();
    const available = await Product.count({ where: { status: 'available' } });
    const sold = await Product.count({ where: { status: 'sold' } });
    
    const recent = await Product.findAll({
      limit: 5,
      order: [['updatedAt', 'DESC']],
      attributes: ['id', 'brand', 'model', 'status', 'updatedAt']
    });

    res.json({ total, available, sold, recent });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching stats', error: error.message });
  }
};

exports.getProduct = async (req, res) => {
  try {
    const product = await Product.findByPk(req.params.id, {
      include: [{ model: ProductImage, as: 'images' }],
    });
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json(product);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching product', error: error.message });
  }
};

exports.createProduct = async (req, res) => {
  try {
    const productData = { ...req.body };
    
    // Parse boolean strings and handle empty strings for MySQL
    const booleanFields = [
      'hasWarranty', 'isCloudLocked', 'isResetReady', 'isMdmLocked', 
      'isPromoAttached', 'isGenuineParts', 'testTouchscreen', 'testSpeaker',
      'testMic', 'testWifi', 'testBluetooth', 'testCamera', 'testFaceId',
      'testFingerprint', 'testCharging', 'testSimCard'
    ];
    
    const numericFields = ['batteryHealth', 'purchasePrice', 'sellPrice'];
    const dateFields = ['warrantyStartDate', 'saleDate', 'warrantyEndDate'];

    Object.keys(productData).forEach(key => {
      // Convert empty strings to null
      if (productData[key] === '') {
        productData[key] = null;
      }
      
      // Handle booleans
      if (booleanFields.includes(key)) {
        if (productData[key] === 'true') productData[key] = true;
        else if (productData[key] === 'false') productData[key] = false;
        else if (productData[key] === null) delete productData[key]; // Use default
      }

      // Handle numbers
      if (numericFields.includes(key) && productData[key] !== null) {
        productData[key] = parseFloat(productData[key]);
      }
    });

    if (req.files) {
      if (req.files.thumbnail) {
        productData.thumbnail = `/uploads/products/${req.files.thumbnail[0].filename}`;
      }
      if (req.files.vdo360) {
        productData.vdo360 = `/uploads/products/${req.files.vdo360[0].filename}`;
      }
    }

    const product = await Product.create(productData);

    // Generate QR Code from IMEI 1 (or ID if IMEI1 is missing)
    const qrData = productData.imei1 || product.id;
    const qrDir = path.join(__dirname, '../uploads/qrcodes');
    if (!fs.existsSync(qrDir)) fs.mkdirSync(qrDir, { recursive: true });
    const qrPath = path.join(qrDir, `${product.id}.png`);
    await QRCode.toFile(qrPath, qrData);

    product.barcode = `/uploads/qrcodes/${product.id}.png`;
    await product.save();

    // Handle Specific Image Categories (Including Thumbnail if it should be in gallery too)
    const imageCategories = [
      'thumbnail', 'front', 'back', 'left', 'right', 'bottomLeft', 'bottomRight',
      'topEdge', 'bottomEdge', 'about1', 'about2', 'battery',
      'rearCamera', 'frontCamera', 'screen', 'lens'
    ];

    if (req.files) {
      for (const category of imageCategories) {
        if (req.files[category]) {
          await ProductImage.create({
            productId: product.id,
            type: category,
            imageUrl: `/uploads/products/${req.files[category][0].filename}`
          });
        }
      }

      // Handle General Images
      if (req.files.images) {
        const imagePromises = req.files.images.map(file => 
          ProductImage.create({ productId: product.id, type: 'general', imageUrl: `/uploads/products/${file.filename}` })
        );
        await Promise.all(imagePromises);
      }
    }

    // Handle Seller
    if (req.body.sellerFullName) {
      const sellerData = {
        productId: product.id,
        fullName: req.body.sellerFullName,
        phoneNumber: req.body.sellerPhone,
        idCardNumber: req.body.sellerIdCardNumber,
      };

      if (req.files) {
        if (req.files.idCardImage) sellerData.idCardImageUrl = `/uploads/products/${req.files.idCardImage[0].filename}`;
        if (req.files.sellerWithPhoneImage) sellerData.sellerWithPhoneImageUrl = `/uploads/products/${req.files.sellerWithPhoneImage[0].filename}`;
        if (req.files.signature) sellerData.signatureUrl = `/uploads/products/${req.files.signature[0].filename}`;
      }
      const SellerInfo = require('../models/SellerInfo');
      await SellerInfo.create(sellerData);
    }

    const updatedProduct = await Product.findByPk(product.id, {
      include: [{ model: ProductImage, as: 'images' }, { model: require('../models/SellerInfo'), as: 'seller' }]
    });

    res.status(201).json(updatedProduct);
  } catch (error) {
    res.status(500).json({ message: 'Error creating product', error: error.message });
  }
};

exports.updateProduct = async (req, res) => {
  try {
    const product = await Product.findByPk(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });

    const updateData = typeof req.body === 'string' ? JSON.parse(req.body) : { ...req.body };

    // Parse boolean strings from FormData
    const booleanFields = [
      'hasWarranty', 'isCloudLocked', 'isResetReady', 'isMdmLocked', 
      'isPromoAttached', 'isGenuineParts', 'testTouchscreen', 'testSpeaker',
      'testMic', 'testWifi', 'testBluetooth', 'testCamera', 'testFaceId',
      'testFingerprint', 'testCharging', 'testSimCard'
    ];
    
    booleanFields.forEach(field => {
      if (updateData[field] === 'true') updateData[field] = true;
      if (updateData[field] === 'false') updateData[field] = false;
    });

    if (req.files) {
      if (req.files.thumbnail) {
        if (product.thumbnail) {
          const oldPath = path.join(__dirname, '../', product.thumbnail);
          if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
        }
        updateData.thumbnail = `/uploads/products/${req.files.thumbnail[0].filename}`;
      }
      if (req.files.vdo360) {
        if (product.vdo360) {
          const oldPath = path.join(__dirname, '../', product.vdo360);
          if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
        }
        updateData.vdo360 = `/uploads/products/${req.files.vdo360[0].filename}`;
      }
    }

    // Handle vdo360 deletion if explicitly set to null/empty in body
    if (updateData.vdo360 === null || updateData.vdo360 === 'null') {
      if (product.vdo360) {
        const oldPath = path.join(__dirname, '../', product.vdo360);
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }
      updateData.vdo360 = null;
    }

    // Ensure status is valid if provided
    if (updateData.status && !['available', 'sold', 'reserved', 'repair', 'import'].includes(updateData.status)) {
      delete updateData.status;
    }

    await product.update(updateData);

    // Handle Specific Image Categories
    const imageCategories = [
      'thumbnail', 'front', 'back', 'left', 'right', 'bottomLeft', 'bottomRight',
      'topEdge', 'bottomEdge', 'about1', 'about2', 'battery',
      'rearCamera', 'frontCamera', 'screen', 'lens'
    ];

    if (req.files) {
      for (const category of imageCategories) {
        if (req.files[category]) {
          const existing = await ProductImage.findOne({ where: { productId: product.id, type: category } });
          if (existing) {
            const filePath = path.join(__dirname, '../', existing.imageUrl);
            if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
            await existing.destroy();
          }

          await ProductImage.create({
            productId: product.id,
            type: category,
            imageUrl: `/uploads/products/${req.files[category][0].filename}`
          });
        }
      }

      // Handle New General Images
      if (req.files.images) {
        const imagePromises = req.files.images.map(file => 
          ProductImage.create({ productId: product.id, type: 'general', imageUrl: `/uploads/products/${file.filename}` })
        );
        await Promise.all(imagePromises);
      }
    }

    // Handle Seller Update
    if (updateData.sellerFullName) {
      const SellerInfo = require('../models/SellerInfo');
      let seller = await SellerInfo.findOne({ where: { productId: product.id } });
      const sellerData = {
        fullName: updateData.sellerFullName,
        phoneNumber: updateData.sellerPhone,
        idCardNumber: updateData.sellerIdCardNumber,
      };

      if (req.files) {
        if (req.files.idCardImage) sellerData.idCardImageUrl = `/uploads/products/${req.files.idCardImage[0].filename}`;
        if (req.files.sellerWithPhoneImage) sellerData.sellerWithPhoneImageUrl = `/uploads/products/${req.files.sellerWithPhoneImage[0].filename}`;
        if (req.files.signature) sellerData.signatureUrl = `/uploads/products/${req.files.signature[0].filename}`;
      }

      if (seller) await seller.update(sellerData);
      else await SellerInfo.create({ ...sellerData, productId: product.id });
    }

    res.json(product);
  } catch (error) {
    res.status(500).json({ message: 'Error updating product', error: error.message });
  }
};

exports.deleteProductImage = async (req, res) => {
  try {
    const image = await ProductImage.findByPk(req.params.imageId);
    if (!image) return res.status(404).json({ message: 'Image not found' });
    
    // Optional: Delete file from filesystem
    const filePath = path.join(__dirname, '../', image.imageUrl);
    if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
    
    await image.destroy();
    res.json({ message: 'Image deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting image', error: error.message });
  }
};

exports.deleteProduct = async (req, res) => {
  try {
    const product = await Product.findByPk(req.params.id, {
      include: [{ model: ProductImage, as: 'images' }, { model: require('../models/SellerInfo'), as: 'seller' }]
    });
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Helper to delete file
    const deleteFile = (url) => {
      if (url) {
        const filePath = path.join(__dirname, '../', url);
        if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
      }
    };

    // Delete thumbnail
    deleteFile(product.thumbnail);
    // Delete VDO
    deleteFile(product.vdo360);
    // Delete barcode
    deleteFile(product.barcode);

    // Delete gallery images
    if (product.images) {
      for (const img of product.images) {
        deleteFile(img.imageUrl);
        await img.destroy();
      }
    }

    // Delete seller images
    if (product.seller) {
      deleteFile(product.seller.idCardImageUrl);
      deleteFile(product.seller.sellerWithPhoneImageUrl);
      deleteFile(product.seller.signatureUrl);
      await product.seller.destroy();
    }

    await product.destroy();
    res.json({ message: 'Product and all associated media deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting product', error: error.message });
  }
};
