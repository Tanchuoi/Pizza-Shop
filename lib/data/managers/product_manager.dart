import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductManager with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products; // Getter for UI

  Future<void> getAllProducts() async {
    _products = await _productService.getAllProducts();
    notifyListeners(); // Notify UI about changes
  }

  Future<void> getProductsByCategory(String category) async {
    _products = await _productService.getProductsByCategory(category);
    notifyListeners(); // Notify UI about changes
  }
}
