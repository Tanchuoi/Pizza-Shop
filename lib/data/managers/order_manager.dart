import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderManager extends ChangeNotifier {
  // Private list of orders
  final List<Order> _orders = [
    // Sample initial data
    Order(
      id: '1001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      items: [
        CartItem(
          id: '101',
          name: "Pizza Tứ Vị Xuân (Có Viền)",
          price: 318000,
          quantity: 2,
          imageUrl: "assets/images/pizza.png",
        ),
        CartItem(
          id: '102',
          name: "Pizza Hải Sản",
          quantity: 3,
          price: 289000,
          imageUrl: "assets/images/pizza.png",
        ),
      ],
      total: 1213000,
      status: 'delivered',
      deliveryAddress: 'Can Tho, Vietnam',
    ),
    Order(
      id: '1001',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      items: [
        CartItem(
          id: '101',
          name: "Pizza Tứ Vị Xuân (Có Viền)",
          price: 318000,
          quantity: 2,
          imageUrl: "assets/images/pizza.png",
        ),
        CartItem(
          id: '102',
          name: "Pizza Hải Sản",
          quantity: 3,
          price: 289000,
          imageUrl: "assets/images/pizza.png",
        ),
      ],
      total: 1213000,
      status: 'delivered',
      deliveryAddress: 'Can Tho, Vietnam',
    )
  ];

  // Getters for filtered orders
  List<Order> get allOrders => List.unmodifiable(_orders);

  List<Order> get activeOrders => _orders
      .where((order) =>
          order.status.toLowerCase() == 'pending' ||
          order.status.toLowerCase() == 'processing')
      .toList();

  List<Order> get completedOrders => _orders
      .where((order) => order.status.toLowerCase() == 'delivered')
      .toList();

  List<Order> get canceledOrders => _orders
      .where((order) => order.status.toLowerCase() == 'canceled')
      .toList();

  // Get a specific order by ID
  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new order
  void addOrder(Order order) {
    _orders.add(order);
    // Sort orders by date (newest first)
    _orders.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  // Cancel an order
  bool cancelOrder(String orderId) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      final order = _orders[orderIndex];
      // Only allow cancellation of pending orders
      if (order.status.toLowerCase() == 'pending') {
        final updatedOrder = Order(
          id: order.id,
          date: order.date,
          items: order.items,
          total: order.total,
          status: 'canceled',
          deliveryAddress: order.deliveryAddress,
        );
        _orders[orderIndex] = updatedOrder;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Update order status
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

  // Create a new order from items in a previous order (reorder)
  String? reorder(String orderId) {
    final originalOrder = getOrderById(orderId);
    if (originalOrder != null) {
      final newOrder = Order(
        id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        items: originalOrder.items,
        total: originalOrder.total,
        status: 'pending',
        deliveryAddress: originalOrder.deliveryAddress,
      );
      addOrder(newOrder);
      return newOrder.id;
    }
    return null;
  }

  // Get order history for a specific time period
  List<Order> getOrderHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _orders.where((order) {
      if (startDate != null && order.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && order.date.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  // Calculate total spent on orders
  double calculateTotalSpent({
    DateTime? startDate,
    DateTime? endDate,
    bool onlyDelivered = true,
  }) {
    return _orders.where((order) {
      if (onlyDelivered && order.status.toLowerCase() != 'delivered') {
        return false;
      }
      if (startDate != null && order.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && order.date.isAfter(endDate)) {
        return false;
      }
      return true;
    }).fold(0, (sum, order) => sum + order.total);
  }

  // Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    return {
      'totalOrders': _orders.length,
      'activeOrders': activeOrders.length,
      'completedOrders': completedOrders.length,
      'canceledOrders': canceledOrders.length,
      'totalSpent': calculateTotalSpent(),
      'averageOrderValue': _orders.isEmpty
          ? 0.0
          : calculateTotalSpent() / completedOrders.length,
    };
  }
}
