import '../models/cart_item.dart';
import 'pocketbase_client.dart';

class CartService {
  Future<List<CartItem>> fetchCartItems() async {
    final List<CartItem> items = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final cartItemModels = await pb.collection('cart_items').getFullList(
          filter: "user = '$userId' && status = 'Active'", expand: 'product');
      for (final cartItemModel in cartItemModels) {
        final item = CartItem.fromJson(cartItemModel.toJson());
        final products = cartItemModel.expand['product'];
        final product = products?.first;

        final imageUrl =
            pb.files.getUrl(product!, product.data['featuredImage']).toString();
        items.add(item.copyWith(featuredImage: imageUrl));
      }
      return items;
    } catch (error) {
      print('Error fetching cart items: $error');
      return items;
    }
  }

  Future<void> addCartItem(CartItem item) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      final existingItems = await pb.collection('cart_items').getFullList(
            filter:
                "user = '$userId' && product = '${item.id}' && status = 'Active'",
          );
      if (existingItems.isNotEmpty) {
        final existingItem = existingItems.first;
        final newQuantity = existingItem.data['quantity'] + item.quantity;
        await pb.collection('cart_items').update(existingItem.id, body: {
          'quantity': newQuantity,
        });
        return;
      }
      await pb.collection('cart_items').create(body: {
        'user': userId,
        'product': item.id,
        'status': 'Active',
        ...item.toJson(),
      });
    } catch (error) {
      print('Error adding cart item: $error');
    }
  }

  Future<void> updateCartItem(CartItem item, int newQuantity) async {
    try {
      final pb = await getPocketbaseInstance();
      await pb.collection('cart_items').update(item.id, body: {
        'quantity': newQuantity,
      });
    } catch (error) {
      print('Error updating cart item: $error');
    }
  }

  Future<void> deleteCartItem(CartItem item) async {
    try {
      final pb = await getPocketbaseInstance();

      await pb.collection('cart_items').update(item.id, body: {
        'status': 'Deleted',
      });
    } catch (error) {
      print('Error soft-deleting cart item: $error');
    }
  }

  Future<void> clearCart() async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final cartItemModels = await pb.collection('cart_items').getFullList(
            filter: "user = '$userId' && status = 'Active'",
          );

      for (final cartItem in cartItemModels) {
        await pb.collection('cart_items').update(cartItem.id, body: {
          'status': 'Deleted',
        });
      }
    } catch (error) {
      print('Error clearing cart: $error');
    }
  }

  Future<void> saveCart(List<CartItem> items) async {
    await clearCart();
    for (final item in items) {
      await addCartItem(item);
    }
  }
}
