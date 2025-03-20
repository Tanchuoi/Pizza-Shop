import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartManager extends ChangeNotifier {
  final CartService cartService = CartService();
  List<CartItem> _items = [];

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

  Future<void> loadCart() async {
    try {
      _items = await cartService.fetchCartItems();
      notifyListeners();
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  // Update quantity
  Future<void> updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(item);
      return;
    }

    try {
      await cartService.updateCartItem(item, newQuantity);
      final index = _items.indexWhere((prod) => prod.id == item.id);
      if (index != -1) {
        _items[index].quantity = newQuantity;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  // Remove item
  Future<void> removeItem(CartItem item) async {
    try {
      await cartService.deleteCartItem(item);
      _items.removeWhere((prod) => prod.id == item.id);
      notifyListeners();
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Clear cart
  void clearCart() {
    _items = [];
    cartService.clearCart();
    notifyListeners();
  }

  // Add item to cart
  Future<void> addItem(CartItem item) async {
    await cartService.addCartItem(item);
    await loadCart();
    notifyListeners();
  }

  // Save cart to database (mock implementation)
  Future<void> saveCart() async {
    try {
      await cartService.saveCart(_items);
      notifyListeners();
    } catch (e) {
      print('Error saving cart: $e');
    }
  }
}
