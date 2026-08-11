import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import '../services/auth_provider.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'checkout_success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService _apiService = ApiService();
  bool _isPlacingOrder = false;
  String? _error;

  Future<void> _checkout() async {
    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();

    if (!auth.isLoggedIn) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    if (cart.items.isEmpty) return;

    setState(() {
      _isPlacingOrder = true;
      _error = null;
    });

    try {
      // Book each cart item sequentially against the API.
      for (final item in cart.items) {
        final booking = await _apiService.createBooking(
          item.provider.id,
          item.petName,
          item.date,
          item.time,
        );
        // Simulates a payment gateway confirmation step (e.g. Razorpay success callback).
        await _apiService.markBookingPaid(booking['_id']);
      }
      cart.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CheckoutSuccessScreen()),
      );
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isPlacingOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty. Book a service to get started!'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(item.provider.name),
                    subtitle: Text(
                        'Pet: ${item.petName}\n${item.date} · ${item.time}'),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${item.provider.pricePerSession.toInt()}'),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => cart.removeFromCart(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16)),
                        const Spacer(),
                        Text('₹${cart.total.toInt()}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _isPlacingOrder ? null : _checkout,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: _isPlacingOrder
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Confirm & Pay'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
