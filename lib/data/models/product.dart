import 'package:flutter_dotenv/flutter_dotenv.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? featuredImage;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.featuredImage,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '', // Ensure id is always a string
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      price: (json['price'] ?? 0).toDouble(), // Ensure it's a double
      featuredImage: json['featuredImage'] != null
          ? "${dotenv.env['POCKETBASE_URL']}api/files/${json['collectionId']}/${json['id']}/${json['featuredImage']}"
          : null, // ✅ If missing, set to null
      category: json['category'] ?? 'uncategorized',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'featuredImage': featuredImage,
      'category': category,
    };
  }
}
