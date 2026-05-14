const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

const auth = require('../middleware/auth');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.get('/users', auth, authController.getUsers);
router.delete('/users/:id', auth, authController.deleteUser);

module.exports = router;
