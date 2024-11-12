import 'package:ec/models/cart_item.dart';
import 'package:ec/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  void addItem(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
