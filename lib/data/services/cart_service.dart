import '../models/cart_item.dart';
import 'pocketbase_client.dart';
import 'package:pocketbase/pocketbase.dart';

class CartService {
  Future<String> getImageUrl(CartItem item) async {
    final pb = await getPocketbaseInstance();
    final record = await pb.collection('cart_items').getOne(item.id);
    final imageUrl =
        pb.files.getUrl(record, record.data['featuredImage']).toString();
    return imageUrl;
  }

  Future<List<CartItem>> fetchCartItems() async {
    final List<CartItem> items = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      print('User ID: $userId');
      final cartItemModels = await pb
          .collection('cart_items')
          .getFullList(filter: "user = '$userId'");
      print('Cart items: $cartItemModels');
      for (final cartItemModel in cartItemModels) {
        final item = CartItem.fromJson(cartItemModel.toJson());
        final imageUrl = await getImageUrl(item);
        items.add(item.copyWith(imageUrl: imageUrl));
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
      await pb.collection('cart_items').create(body: {
        'user': userId,
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
    final pb = await getPocketbaseInstance();
    await pb.collection('cart_items').delete(item.id);
  }

  Future<void> clearCart() async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;
    final cartItemModels = await pb
        .collection('cart_items')
        .getFullList(filter: "user = '$userId'");
    for (final cartItemModel in cartItemModels) {
      await pb.collection('cart_items').delete(cartItemModel.id);
    }
  }

  Future<void> saveCart(List<CartItem> items) async {
    final pb = await getPocketbaseInstance();
    final userId = pb.authStore.record!.id;
    final cartItemModels = await pb
        .collection('cart_items')
        .getFullList(filter: "user = '$userId'");
    for (final cartItemModel in cartItemModels) {
      await pb.collection('cart_items').delete(cartItemModel.id);
    }
    for (final item in items) {
      await addCartItem(item);
    }
  }
}
