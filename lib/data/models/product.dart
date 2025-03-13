class Product {
  final String name;
  final String description;
  final int price;
  final String category;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  Product copyWith({
    String? name,
    String? description,
    int? price,
    String? imageUrl,
  }) {
    return Product(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
