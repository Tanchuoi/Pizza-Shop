import 'package:flutter_dotenv/flutter_dotenv.dart';

class CartItem {
  final String id;
  final String name;
  int quantity;
  final String? featuredImage;
  final double price;
  String? size;
  String? category;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.featuredImage,
    required this.price,
    this.category,
    this.size,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    String? featuredImage,
    int? quantity,
    double? price,
    String? category,
    String? size,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      featuredImage: featuredImage ?? this.featuredImage,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      size: size ?? this.size,
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
          ? "${dotenv.env['POCKETBASE_URL']}api/files/${expandedProduct['collectionId']}/${expandedProduct['id']}/${expandedProduct['featuredImage']}"
          : null,
      category: expandedProduct != null ? expandedProduct['category'] : null,
      size: json['size'],
    );
  }
}
