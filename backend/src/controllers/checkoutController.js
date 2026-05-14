const Cart = require('../models/Cart');
const Reservation = require('../models/Reservation');
const Customer = require('../models/Customer');
const User = require('../models/User');
const sequelize = require('../config/database');

exports.checkout = async (req, res) => {
  const transaction = await sequelize.transaction();
  try {
    const userId = req.user.id;
    console.log('Checkout starting for user:', userId);
    
    // 1. ดึงตะกร้า
    const cartItems = await Cart.findAll({ where: { user_id: userId }, transaction });
    console.log('Cart items found:', cartItems.length);
    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'ตะกร้าสินค้าว่างเปล่า' });
    }

    // 2. หาข้อมูล User เพื่อเอา email ไปหา Customer
    const user = await User.findByPk(userId, { transaction });
    const customer = await Customer.findOne({ where: { email: user.email }, transaction });
    console.log('Customer found:', !!customer);
    if (!customer) {
        return res.status(400).json({ message: 'ไม่พบข้อมูลลูกค้าในระบบ' });
    }

    // 3. สร้างรายการจองทีละรายการ
    const io = req.app.get('io');
    for (const item of cartItems) {
      console.log('Creating reservation for product:', item.product_id);
      const reservation = await Reservation.create({
        product_id: item.product_id,
        customer_id: customer.id,
        user_id: userId,
        status: 'pending'
      }, { transaction });
      
      io.emit('new_reservation', reservation);
    }

    // 4. ล้างตะกร้า
    await Cart.destroy({ where: { user_id: userId }, transaction });

    await transaction.commit();
    res.json({ message: 'จองสินค้าสำเร็จ!' });
  } catch (error) {
    await transaction.rollback();
    console.error('Checkout error:', error);
    res.status(500).json({ message: 'Checkout failed', error: error.message });
  }
};
