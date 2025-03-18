import '../models/product.dart';
import 'pocketbase_client.dart';

class ProductService {
  Future<List<Product>> getAllProducts() async {
    final pb = await getPocketbaseInstance();
    final productModels = await pb.collection('products').getFullList();
    return productModels
        .map((model) => Product.fromJson(model.toJson()))
        .toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final pb = await getPocketbaseInstance();
    final productModels = await pb.collection('products').getFullList(
          filter: "category = '$category'",
        );
    return productModels
        .map((model) => Product.fromJson(model.toJson()))
        .toList();
  }

  // **Get 6 Random Products**
  Future<List<Product>> getRandomProducts({int limit = 6}) async {
    final pb = await getPocketbaseInstance();
    final productModels = await pb.collection('products').getList(
          page: 1,
          perPage: limit,
          sort: "@random", // ✅ Fetch random products
        );
    return productModels.items
        .map((model) => Product.fromJson(model.toJson()))
        .toList();
  }
}
