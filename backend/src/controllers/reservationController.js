const Reservation = require('../models/Reservation');
const Product = require('../models/Product');
const Customer = require('../models/Customer');
const sequelize = require('../config/database');
const { emitReservationSync } = require('../utils/reservationSocket');

exports.createReservation = async (req, res) => {
  try {
    const newReservation = await Reservation.create(req.body);
    const io = req.app.get('io');
    const full = await Reservation.findByPk(newReservation.id, {
      include: [Product, Customer],
    });
    io.emit('new_reservation', full || newReservation);
    emitReservationSync(req, full ? [full] : [newReservation]);
    res.status(201).json(newReservation);
  } catch (error) {
    res.status(500).json({ message: 'Error creating reservation', error: error.message });
  }
};

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

exports.getMyReservations = async (req, res) => {
  try {
    const userId = req.user.id;
    const reservations = await Reservation.findAll({
      where: { user_id: userId },
      include: [Product, Customer],
      order: [['createdAt', 'DESC']]
    });
    res.json(reservations);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching my reservations', error: error.message });
  }
};

exports.updateReservationStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, deposit_amount, reservation_expires_at, notes, slip_image, attachment_file } = req.body;
    
    const reservation = await Reservation.findByPk(id);
    if (!reservation) return res.status(404).json({ message: 'Reservation not found' });
    
    const oldStatus = reservation.status;
    await reservation.update({ 
      status, 
      deposit_amount, 
      reservation_expires_at, 
      notes, 
      slip_image,
      attachment_file,
    });

    if (status === 'sold') {
      await Product.update({ status: 'sold', saleDate: new Date() }, { where: { id: reservation.product_id } });
    }

    const fresh = await Reservation.findByPk(id, {
      include: [Product, Customer],
    });

    // if (status === 'confirmed' && oldStatus !== 'confirmed') {
    //   const io = req.app.get('io');
    //   io.emit('new_reservation', { message: 'มีการยืนยันการจองใหม่', reservation: fresh });
    // }
    // emitReservationSync(req, fresh ? [fresh] : []); // นำออก

    res.json(fresh);
  } catch (error) {
    res.status(500).json({ message: 'Error updating reservation', error: error.message });
  }
};

/** multipart/form-data: deposit, expiry, optional slip_image & attachment_file files */
exports.updateReservation = async (req, res) => {
  try {
    const { id } = req.params;
    const reservation = await Reservation.findByPk(id);
    if (!reservation) return res.status(404).json({ message: 'Reservation not found' });

    const updates = {};

    if (req.body.status !== undefined && req.body.status !== '') {
      updates.status = req.body.status;
    }
    if (req.body.deposit_amount !== undefined && req.body.deposit_amount !== null) {
      const raw = String(req.body.deposit_amount).trim();
      if (raw !== '') {
        const d = parseFloat(raw, 10);
        if (!Number.isNaN(d)) updates.deposit_amount = d;
      }
    }
    if (req.body.reservation_expires_at !== undefined) {
      updates.reservation_expires_at = req.body.reservation_expires_at || null;
    }
    if (req.body.notes !== undefined) {
      updates.notes = req.body.notes || null;
    }

    if (req.files?.slip_image?.[0]) {
      updates.slip_image = `/uploads/reservations/${req.files.slip_image[0].filename}`;
    }
    if (req.files?.attachment_file?.[0]) {
      updates.attachment_file = `/uploads/reservations/${req.files.attachment_file[0].filename}`;
    }

    await reservation.update(updates);

    if (updates.status === 'sold') {
      await Product.update({ status: 'sold', saleDate: new Date() }, { where: { id: reservation.product_id } });
    }

    const fresh = await Reservation.findByPk(id, {
      include: [Product, Customer],
    });
    res.json(fresh);
  } catch (error) {
    res.status(500).json({ message: 'Error updating reservation', error: error.message });
  }
};

    exports.updateReservationSlip = async (req, res) => {
    try {
    const { id } = req.params;
    const reservation = await Reservation.findByPk(id);
    if (!reservation) return res.status(404).json({ message: 'Reservation not found' });

    if (req.files?.slip_image?.[0]) {
      const slip_image = `/uploads/reservations/${req.files.slip_image[0].filename}`;
      await reservation.update({ slip_image });
      const fresh = await Reservation.findByPk(id, { include: [Product, Customer] });
      res.json(fresh);
    } else {
      res.status(400).json({ message: 'No slip image uploaded' });
    }
    } catch (error) {
    res.status(500).json({ message: 'Error uploading slip', error: error.message });
    }
    };
