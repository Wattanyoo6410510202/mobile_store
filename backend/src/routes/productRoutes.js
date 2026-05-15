const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const auth = require('../middleware/auth');
const checkRole = require('../middleware/checkRole');
const upload = require('../middleware/upload');

router.get('/', productController.getProducts);
router.get('/stats/dashboard', auth, checkRole('admin'), productController.getStats);
router.get('/:id', productController.getProduct);
router.post('/', auth, checkRole('admin'), upload.fields([
  { name: 'images', maxCount: 20 },
  { name: 'idCardImage', maxCount: 1 },
  { name: 'sellerWithPhoneImage', maxCount: 1 },
  { name: 'signature', maxCount: 1 },
  { name: 'thumbnail', maxCount: 1 },
  { name: 'vdo360', maxCount: 1 },
  { name: 'front', maxCount: 1 },
  { name: 'back', maxCount: 1 },
  { name: 'left', maxCount: 1 },
  { name: 'right', maxCount: 1 },
  { name: 'bottomLeft', maxCount: 1 },
  { name: 'bottomRight', maxCount: 1 },
  { name: 'topEdge', maxCount: 1 },
  { name: 'bottomEdge', maxCount: 1 },
  { name: 'about1', maxCount: 1 },
  { name: 'about2', maxCount: 1 },
  { name: 'battery', maxCount: 1 },
  { name: 'rearCamera', maxCount: 1 },
  { name: 'frontCamera', maxCount: 1 },
  { name: 'screen', maxCount: 1 },
  { name: 'lens', maxCount: 1 }
]), productController.createProduct);

router.put('/:id', auth, checkRole('admin'), upload.fields([
  { name: 'images', maxCount: 20 },
  { name: 'idCardImage', maxCount: 1 },
  { name: 'sellerWithPhoneImage', maxCount: 1 },
  { name: 'signature', maxCount: 1 },
  { name: 'thumbnail', maxCount: 1 },
  { name: 'vdo360', maxCount: 1 },
  { name: 'front', maxCount: 1 },
  { name: 'back', maxCount: 1 },
  { name: 'left', maxCount: 1 },
  { name: 'right', maxCount: 1 },
  { name: 'bottomLeft', maxCount: 1 },
  { name: 'bottomRight', maxCount: 1 },
  { name: 'topEdge', maxCount: 1 },
  { name: 'bottomEdge', maxCount: 1 },
  { name: 'about1', maxCount: 1 },
  { name: 'about2', maxCount: 1 },
  { name: 'battery', maxCount: 1 },
  { name: 'rearCamera', maxCount: 1 },
  { name: 'frontCamera', maxCount: 1 },
  { name: 'screen', maxCount: 1 },
  { name: 'lens', maxCount: 1 }
]), productController.updateProduct);

router.delete('/:id', auth, checkRole('admin'), productController.deleteProduct);
router.delete('/images/:imageId', auth, checkRole('admin'), productController.deleteProductImage);

module.exports = router;
