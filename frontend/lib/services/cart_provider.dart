import 'package:flutter/material.dart';
import '../models/provider_model.dart';

class CartItem {
  final ServiceProvider provider;
  final String date;
  final String time;
  final String petName;

  CartItem({
    required this.provider,
    required this.date,
    required this.time,
    required this.petName,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total => _items.fold(0, (sum, item) => sum + item.provider.pricePerSession);

  void addToCart(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
