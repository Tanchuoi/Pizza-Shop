import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartManager extends ChangeNotifier {
  List<CartItem> _items = [
    CartItem(
      id: '1',
      name: "Pizza Tứ Vị Xuân",
      description: "Mực, tôm, thanh cua, thịt ba chỉ xô...",
      price: 249000,
      quantity: 10,
      imageUrl: "assets/images/pizza.png", // Replace with actual image URL
    ),
  ];

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return List.unmodifiable(_items);
  }

  List<CartItem> get productEntries {
    return List.unmodifiable(_items);
  }

  // Getter for cart items
  List<CartItem> get items => [..._items];

  // Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  // Calculate subtotal
  double get subtotal {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Delivery fee
  final double deliveryFee = 20000;

  // Calculate total price
  double get totalPrice => subtotal + deliveryFee;

  // Update quantity
  void updateQuantity(String id, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(id);
      return;
    }

    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  // Remove item
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _items = [];
    notifyListeners();
  }

  // Add item to cart
  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  // Save cart to database (mock implementation)
  Future<void> saveCart() async {
    // In a real app, this would save to a local database or remote server
    print('Saving cart with ${_items.length} items');
    // await database.saveCart(_items);
  }

  // Load cart from database (mock implementation)
  Future<void> loadCart() async {
    // In a real app, this would load from a local database or remote server
    print('Loading cart from database');
    // _items = await database.getCartItems();
    notifyListeners();
  }
}
