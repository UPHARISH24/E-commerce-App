import 'package:ec/models/cart_item.dart';
import 'package:ec/models/order.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        items: cartItems,
        total: total,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
