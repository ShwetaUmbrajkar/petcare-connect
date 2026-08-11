const Provider = require('../models/Provider');

exports.getAllProviders = async (req, res) => {
  try {
    const { category, search } = req.query;
    const filter = {};
    if (category) filter.category = category;
    if (search) filter.name = { $regex: search, $options: 'i' };

    const providers = await Provider.find(filter).sort({ avgRating: -1 });
    res.json(providers);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getProviderById = async (req, res) => {
  try {
    const provider = await Provider.findById(req.params.id);
    if (!provider) return res.status(404).json({ message: 'Provider not found' });
    res.json(provider);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.createProvider = async (req, res) => {
  try {
    const provider = await Provider.create(req.body);
    res.status(201).json(provider);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.seedDemoProviders = async (req, res) => {
  try {
    const demoData = [
      {
        name: 'Happy Paws Vet Clinic',
        category: 'vet',
        description: 'General checkups, vaccinations, and emergency care.',
        location: 'Koregaon Park, Pune',
        pricePerSession: 600,
        avgRating: 4.6,
        reviewCount: 128,
        availableSlots: [
          { date: '2026-08-15', time: '10:00 AM' },
          { date: '2026-08-15', time: '2:00 PM' },
          { date: '2026-08-16', time: '11:00 AM' },
        ],
        imageUrl: 'https://placehold.co/400x300?text=Vet+Clinic',
      },
      {
        name: 'FluffyCuts Grooming',
        category: 'groomer',
        description: 'Professional grooming for cats and dogs of all breeds.',
        location: 'Baner, Pune',
        pricePerSession: 800,
        avgRating: 4.8,
        reviewCount: 94,
        availableSlots: [
          { date: '2026-08-15', time: '9:00 AM' },
          { date: '2026-08-17', time: '3:00 PM' },
        ],
        imageUrl: 'https://placehold.co/400x300?text=Grooming',
      },
      {
        name: 'Wag Walkers',
        category: 'walker',
        description: 'Daily and on-demand dog walking services.',
        location: 'Viman Nagar, Pune',
        pricePerSession: 300,
        avgRating: 4.5,
        reviewCount: 61,
        availableSlots: [
          { date: '2026-08-15', time: '7:00 AM' },
          { date: '2026-08-15', time: '6:00 PM' },
        ],
        imageUrl: 'https://placehold.co/400x300?text=Dog+Walker',
      },
    ];
    await Provider.deleteMany({});
    const created = await Provider.insertMany(demoData);
    res.json({ message: 'Demo providers seeded', count: created.length });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
