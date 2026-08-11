const express = require('express');
const router = express.Router();
const {
  getAllProviders,
  getProviderById,
  createProvider,
  seedDemoProviders,
} = require('../controllers/providerController');

router.get('/', getAllProviders);
router.get('/:id', getProviderById);
router.post('/', createProvider);
router.post('/seed/demo', seedDemoProviders); // dev-only helper to populate demo data

module.exports = router;
