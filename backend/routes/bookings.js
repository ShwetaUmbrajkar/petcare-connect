const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const {
  createBooking,
  getMyBookings,
  markAsPaid,
  cancelBooking,
} = require('../controllers/bookingController');

router.post('/', authMiddleware, createBooking);
router.get('/my', authMiddleware, getMyBookings);
router.patch('/:id/pay', authMiddleware, markAsPaid);
router.patch('/:id/cancel', authMiddleware, cancelBooking);

module.exports = router;
