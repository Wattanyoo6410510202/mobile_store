const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');
const auth = require('../middleware/auth');
const checkRole = require('../middleware/checkRole');
const uploadReservation = require('../middleware/uploadReservation');

const reservationUploadFields = uploadReservation.fields([
  { name: 'slip_image', maxCount: 1 },
  { name: 'attachment_file', maxCount: 1 },
]);

router.get('/', auth, checkRole('admin'), reservationController.getAllReservations);
router.get('/me', auth, reservationController.getMyReservations);
router.post('/', reservationController.createReservation);
router.put('/:id/status', auth, checkRole('admin'), reservationController.updateReservationStatus);
router.put('/:id', auth, checkRole('admin'), reservationUploadFields, reservationController.updateReservation);

module.exports = router;
