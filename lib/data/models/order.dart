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
    DateTime? date,
    required this.items,
    required this.total,
    required this.status,
    required this.deliveryAddress,
  }) : date = date ?? DateTime.now();

  factory Order.fromJson(Map<String, dynamic> json) {
    final items = (json['cart_items'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList();

    return Order(
      id: json['id'],
      date: DateTime.parse(json['dateTime']),
      items: items,
      total: (json['amount'] as num).toDouble(),
      status: json['status'],
      deliveryAddress: json['deliveryAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': date.toIso8601String(),
      'cart_items': items.map((item) => item.toJson()).toList(),
      'amount': total,
      'status': status,
      'deliveryAddress': deliveryAddress,
    };
  }
}
