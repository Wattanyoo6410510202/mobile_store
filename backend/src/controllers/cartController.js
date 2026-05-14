const Cart = require('../models/Cart');
const Product = require('../models/Product');

exports.getCart = async (req, res) => {
  try {
    const userId = req.user.id;
    const cartItems = await Cart.findAll({
      where: { user_id: userId },
      include: [Product]
    });
    res.json(cartItems);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching cart', error: error.message });
  }
};

exports.addToCart = async (req, res) => {
  try {
    const { product_id, quantity } = req.body;
    const userId = req.user.id;

    // Check if item already exists
    const existingItem = await Cart.findOne({ where: { user_id: userId, product_id } });
    if (existingItem) {
      return res.status(400).json({ message: 'สินค้านี้อยู่ในตะกร้าแล้ว' });
    }

    const cartItem = await Cart.create({
      user_id: userId,
      product_id,
      quantity: quantity || 1
    });

    const populatedItem = await Cart.findOne({ 
      where: { id: cartItem.id }, 
      include: [Product] 
    });

    res.status(201).json(populatedItem);
  } catch (error) {
    res.status(500).json({ message: 'Error adding to cart', error: error.message });
  }
};

exports.removeFromCart = async (req, res) => {
  try {
    const { id } = req.params;
    await Cart.destroy({ where: { id, user_id: req.user.id } });
    res.json({ message: 'Item removed from cart' });
  } catch (error) {
    res.status(500).json({ message: 'Error removing from cart', error: error.message });
  }
};
