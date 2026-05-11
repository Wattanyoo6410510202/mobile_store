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
    const productData = req.body;
    
    if (req.files && req.files.thumbnail) {
      productData.thumbnail = `/uploads/products/${req.files.thumbnail[0].filename}`;
    }

    const product = await Product.create(productData);

    // Generate QR Code
    const qrData = JSON.stringify({ id: product.id, model: product.model });
    const qrDir = path.join(__dirname, '../uploads/qrcodes');
    if (!fs.existsSync(qrDir)) fs.mkdirSync(qrDir, { recursive: true });
    const qrPath = path.join(qrDir, `${product.id}.png`);
    await QRCode.toFile(qrPath, qrData);

    product.barcode = `/uploads/qrcodes/${product.id}.png`;
    await product.save();

    // Handle Images
    if (req.files && req.files.images) {
      const imagePromises = req.files.images.map(file => 
        ProductImage.create({ productId: product.id, type: 'general', imageUrl: `/uploads/products/${file.filename}` })
      );
      await Promise.all(imagePromises);
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

    const updateData = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;

    if (req.files) {
      if (req.files.thumbnail) {
        updateData.thumbnail = `/uploads/products/${req.files.thumbnail[0].filename}`;
      }
    }

    await product.update(updateData);

    // Handle New Images
    if (req.files && req.files.images) {
      const imagePromises = req.files.images.map(file => 
        ProductImage.create({ productId: product.id, type: 'general', imageUrl: `/uploads/products/${file.filename}` })
      );
      await Promise.all(imagePromises);
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
    const product = await Product.findByPk(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    await product.destroy();
    res.json({ message: 'Product deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting product', error: error.message });
  }
};
