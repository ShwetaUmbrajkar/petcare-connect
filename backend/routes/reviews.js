const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');
const Review = require('../models/Review');
const Provider = require('../models/Provider');

router.post('/', authMiddleware, async (req, res) => {
  try {
    const { providerId, rating, comment } = req.body;
    const review = await Review.create({
      user: req.userId,
      provider: providerId,
      rating,
      comment,
    });

    const allReviews = await Review.find({ provider: providerId });
    const avg =
      allReviews.reduce((sum, r) => sum + r.rating, 0) / allReviews.length;

    await Provider.findByIdAndUpdate(providerId, {
      avgRating: avg.toFixed(1),
      reviewCount: allReviews.length,
    });

    res.status(201).json(review);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/provider/:providerId', async (req, res) => {
  try {
    const reviews = await Review.find({ provider: req.params.providerId }).populate(
      'user',
      'name'
    );
    res.json(reviews);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
