import '../models/product.dart';

class ProductManager {
  // Original method to get all products
  static List<Product> getProducts() {
    return [
      Product(
        name: 'Pizza Hải Sản',
        description: 'Pizza với hải sản tươi ngon',
        price: 159000,
        category: 'PIZZA',
        imageUrl: 'assets/images/pizza.png',
      ),
      Product(
        name: 'Pizza Thịt Xông Khói',
        description: 'Pizza với thịt xông khói thơm ngon',
        price: 129000,
        category: 'PIZZA',
        imageUrl: 'assets/images/pizza.png',
      ),
      Product(
        name: 'Gà Rán',
        description: 'Gà rán giòn rụm',
        price: 79000,
        category: 'GHIỀN GÀ',
        imageUrl: 'assets/images/pizza.png',
      ),
      Product(
        name: 'Gà Nướng',
        description: 'Gà nướng thơm ngon',
        price: 89000,
        category: 'GHIỀN GÀ',
        imageUrl: 'assets/images/pizza.png',
      ),
      Product(
        name: 'Khoai Tây Chiên',
        description: 'Khoai tây chiên giòn',
        price: 39000,
        category: 'MÓN KHAI VỊ',
        imageUrl: 'assets/images/pizza.png',
      ),
      Product(
        name: 'Coca Cola',
        description: 'Nước ngọt có gas',
        price: 15000,
        category: 'THỨC UỐNG',
        imageUrl: 'assets/images/pizza.png',
      ),
    ];
  }

  // New method to filter products by category
  static List<Product> getProductsByCategory(String category) {
    return getProducts()
        .where((product) => product.category == category)
        .toList();
  }
}
