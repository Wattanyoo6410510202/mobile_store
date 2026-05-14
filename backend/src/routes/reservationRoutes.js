const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');
const auth = require('../middleware/auth');
const checkRole = require('../middleware/checkRole');

router.get('/', auth, checkRole('admin'), reservationController.getAllReservations);
router.put('/:id/status', auth, checkRole('admin'), reservationController.updateReservationStatus);

module.exports = router;
