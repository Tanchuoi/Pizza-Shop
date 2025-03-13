class CartItem {
  final String id;
  final String name;
  int quantity;
  final String imageUrl;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.imageUrl,
    required this.price,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
