const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const auth = require('../middleware/auth');
const upload = require('../middleware/upload');

router.get('/', productController.getProducts);
router.get('/:id', productController.getProduct);
router.post('/', auth, upload.fields([
  { name: 'images', maxCount: 20 },
  { name: 'idCardImage', maxCount: 1 },
  { name: 'sellerWithPhoneImage', maxCount: 1 },
  { name: 'signature', maxCount: 1 },
  { name: 'thumbnail', maxCount: 1 }
]), productController.createProduct);

router.put('/:id', auth, upload.fields([
  { name: 'images', maxCount: 20 },
  { name: 'idCardImage', maxCount: 1 },
  { name: 'sellerWithPhoneImage', maxCount: 1 },
  { name: 'signature', maxCount: 1 },
  { name: 'thumbnail', maxCount: 1 }
]), productController.updateProduct);

router.delete('/:id', auth, productController.deleteProduct);
router.delete('/images/:imageId', auth, productController.deleteProductImage);

module.exports = router;
