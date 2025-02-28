class CartItem {
  final String id;
  final String name;
  int quantity;
  final String description;
  final String imageUrl;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.description,
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
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
