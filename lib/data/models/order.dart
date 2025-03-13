import '../models/cart_item.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final String status; // "pending", "delivered", "canceled", etc.
  final String deliveryAddress;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
    required this.deliveryAddress,
  });
}
