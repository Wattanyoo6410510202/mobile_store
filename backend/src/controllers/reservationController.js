const Reservation = require('../models/Reservation');
const Product = require('../models/Product');
const Customer = require('../models/Customer');
const sequelize = require('../config/database');

exports.getAllReservations = async (req, res) => {
  try {
    const reservations = await Reservation.findAll({
      include: [Product, Customer],
      order: [['createdAt', 'DESC']]
    });
    res.json(reservations);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching reservations', error: error.message });
  }
};

exports.updateReservationStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, deposit_amount, reservation_expires_at, notes, slip_image } = req.body;
    
    const reservation = await Reservation.findByPk(id);
    if (!reservation) return res.status(404).json({ message: 'Reservation not found' });
    
    await reservation.update({ 
      status, 
      deposit_amount, 
      reservation_expires_at, 
      notes, 
      slip_image 
    });
    res.json(reservation);
  } catch (error) {
    res.status(500).json({ message: 'Error updating reservation', error: error.message });
  }
};
