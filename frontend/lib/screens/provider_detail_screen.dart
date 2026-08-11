import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider_model.dart';
import '../services/api_service.dart';
import '../services/cart_provider.dart';
import 'cart_screen.dart';

class ProviderDetailScreen extends StatefulWidget {
  final String providerId;
  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  final ApiService _apiService = ApiService();
  final _petNameController = TextEditingController();

  ServiceProvider? _provider;
  bool _isLoading = true;
  String? _error;
  Slot? _selectedSlot;

  @override
  void initState() {
    super.initState();
    _fetchProvider();
  }

  Future<void> _fetchProvider() async {
    try {
      final data = await _apiService.getProviderById(widget.providerId);
      setState(() {
        _provider = ServiceProvider.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _addToCart() {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a slot first')));
      return;
    }
    if (_petNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter your pet\'s name')));
      return;
    }
    context.read<CartProvider>().addToCart(CartItem(
          provider: _provider!,
          date: _selectedSlot!.date,
          time: _selectedSlot!.time,
          petName: _petNameController.text.trim(),
        ));
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _provider == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: ${_error ?? "Provider not found"}')),
      );
    }

    final p = _provider!;
    final availableSlots = p.availableSlots.where((s) => !s.isBooked).toList();

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              p.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.pets, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${p.category.toUpperCase()} · ${p.location}',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              Text(' ${p.avgRating} (${p.reviewCount} reviews)'),
              const Spacer(),
              Text('₹${p.pricePerSession.toInt()} / session',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Text(p.description),
          const SizedBox(height: 24),
          const Text('Pet Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _petNameController,
            decoration: const InputDecoration(
              hintText: 'e.g. Bruno',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Available Slots', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (availableSlots.isEmpty)
            const Text('No slots available right now.', style: TextStyle(color: Colors.grey))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSlots.map((slot) {
                final selected = _selectedSlot?.date == slot.date && _selectedSlot?.time == slot.time;
                return ChoiceChip(
                  label: Text('${slot.date} · ${slot.time}'),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedSlot = slot),
                );
              }).toList(),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Booking to Cart'),
          ),
        ),
      ),
    );
  }
}
