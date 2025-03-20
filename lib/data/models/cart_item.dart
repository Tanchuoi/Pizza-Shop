class CartItem {
  final String id;
  final String name;
  int quantity;
  final String? featuredImage;
  final double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.featuredImage,
    required this.price,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    String? featuredImage,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      featuredImage: featuredImage ?? this.featuredImage,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'featuredImage': featuredImage,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final expandedProduct = json['expand']?['product'];

    return CartItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      featuredImage: expandedProduct != null
          ? "http://10.0.2.2:8090/api/files/${expandedProduct['collectionId']}/${expandedProduct['id']}/${expandedProduct['featuredImage']}"
          : null,
    );
  }
}
