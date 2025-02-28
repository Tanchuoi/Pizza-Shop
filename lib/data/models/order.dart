class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
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
