import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../services/order_service.dart';

class OrderManager extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  // This list will be filled from PocketBase later
  final List<Order> _orders = [];

  List<Order> get allOrders => List.unmodifiable(_orders);

  List<Order> get activeOrders => _orders
      .where((order) => order.status.toLowerCase() == 'pending')
      .toList();

  List<Order> get completedOrders => _orders
      .where((order) => order.status.toLowerCase() == 'delivered')
      .toList();

  List<Order> get canceledOrders => _orders
      .where((order) => order.status.toLowerCase() == 'canceled')
      .toList();

  // 🔄 Load from PocketBase (optional: call in init)
  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await _orderService.fetchOrders();
      _orders.clear();
      _orders.addAll(fetchedOrders);
      _orders.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // ✅ Use service to place order
  Future<bool> placeOrder(
    List<CartItem> cartItems,
    double total,
    String deliveryAddress,
  ) async {
    final success = await _orderService.placeOrder(
      cartItems,
      total,
      deliveryAddress,
    );

    if (success) {
      await fetchOrders(); // Refresh order list
      return true;
    }

    return false;
  }

  // Other unchanged methods below 👇

  Future<bool> cancelOrder(String orderId) async {
    try {
      final success = await _orderService.cancelOrder(orderId);
      if (success) {
        _orders.removeWhere((order) => order.id == orderId);
        await fetchOrders();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      final order = _orders[orderIndex];
      final updatedOrder = Order(
        id: order.id,
        date: order.date,
        items: order.items,
        total: order.total,
        status: newStatus,
        deliveryAddress: order.deliveryAddress,
      );
      _orders[orderIndex] = updatedOrder;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<String?> reorder(String orderId) async {
    final newOrderId = await _orderService.reorder(orderId);

    if (newOrderId != null) {
      await fetchOrders();
      notifyListeners();
    }
    notifyListeners();
    return newOrderId;
  }

  void addOrder(Order order) {
    _orders.add(order);
    _orders.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  List<Order> getOrderHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _orders.where((order) {
      if (startDate != null && order.date.isBefore(startDate)) return false;
      if (endDate != null && order.date.isAfter(endDate)) return false;
      return true;
    }).toList();
  }

  double calculateTotalSpent({
    DateTime? startDate,
    DateTime? endDate,
    bool onlyDelivered = true,
  }) {
    return _orders.where((order) {
      if (onlyDelivered && order.status.toLowerCase() != 'delivered') {
        return false;
      }
      if (startDate != null && order.date.isBefore(startDate)) return false;
      if (endDate != null && order.date.isAfter(endDate)) return false;
      return true;
    }).fold(0, (sum, order) => sum + order.total);
  }

  Map<String, dynamic> getOrderStatistics() {
    return {
      'totalOrders': _orders.length,
      'activeOrders': activeOrders.length,
      'completedOrders': completedOrders.length,
      'canceledOrders': canceledOrders.length,
      'totalSpent': calculateTotalSpent(),
      'averageOrderValue': completedOrders.isEmpty
          ? 0.0
          : calculateTotalSpent() / completedOrders.length,
    };
  }
}
