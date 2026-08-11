const Booking = require('../models/Booking');
const Provider = require('../models/Provider');

exports.createBooking = async (req, res) => {
  try {
    const { providerId, petName, date, time } = req.body;

    const provider = await Provider.findById(providerId);
    if (!provider) return res.status(404).json({ message: 'Provider not found' });

    const slot = provider.availableSlots.find((s) => s.date === date && s.time === time);
    if (!slot || slot.isBooked) {
      return res.status(400).json({ message: 'Selected slot is not available' });
    }
    slot.isBooked = true;
    await provider.save();

    const booking = await Booking.create({
      user: req.userId,
      provider: providerId,
      petName,
      date,
      time,
      amount: provider.pricePerSession,
      status: 'confirmed',
    });

    res.status(201).json(booking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getMyBookings = async (req, res) => {
  try {
    const bookings = await Booking.find({ user: req.userId })
      .populate('provider', 'name category location imageUrl')
      .sort({ createdAt: -1 });
    res.json(bookings);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.markAsPaid = async (req, res) => {
  try {
    const booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { paymentStatus: 'paid' },
      { new: true }
    );
    res.json(booking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.cancelBooking = async (req, res) => {
  try {
    const booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { status: 'cancelled' },
      { new: true }
    );
    res.json(booking);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
