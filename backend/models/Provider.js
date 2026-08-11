const mongoose = require('mongoose');

const providerSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    category: {
      type: String,
      enum: ['vet', 'groomer', 'walker', 'boarding', 'trainer'],
      required: true,
    },
    description: { type: String },
    location: { type: String },
    pricePerSession: { type: Number, required: true },
    avgRating: { type: Number, default: 0 },
    reviewCount: { type: Number, default: 0 },
    availableSlots: [
      {
        date: String,
        time: String,
        isBooked: { type: Boolean, default: false },
      },
    ],
    imageUrl: { type: String },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Provider', providerSchema);
