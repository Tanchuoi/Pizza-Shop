import '../models/order.dart';
import '../models/cart_item.dart';
import 'pocketbase_client.dart';

class OrderService {
  Future<bool> placeOrder(
    List<CartItem> cartItems,
    double total,
    String deliveryAddress,
  ) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final cartItemIds = cartItems.map((item) => item.id).toList();
      print("Cart items: $cartItemIds");

      final body = {
        'user': userId,
        'cart_items': cartItemIds,
        'amount': total,
        'status': 'Pending',
        'deliveryAddress': deliveryAddress,
        'dateTime': DateTime.now().toIso8601String(),
      };

      final record = await pb.collection('orders').create(body: body);
      print("Order placed: ${record.id}");
      return true;
    } catch (e) {
      print("Error placing order: $e");
      return false;
    }
  }

  Future<List<Order>> fetchOrders() async {
    final List<Order> orders = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final orderRecords = await pb.collection('orders').getFullList(
            filter: "user = '$userId'",
            expand: 'cart_items.product',
          );

      for (final record in orderRecords) {
        final json = record.toJson();
        print('Raw cart item json: $json');
        // Expand cart items using fromJson
        final expandedCartItems = record.expand['cart_items'] ?? [];
        json['cart_items'] = expandedCartItems.map((item) {
          final itemJson = item.toJson();

          // Attach product with featured image
          final product = item.expand['product']?.first;
          if (product != null) {
            itemJson['product'] = product.toJson();
            itemJson['product']['featuredImage'] = pb.files
                .getUrl(product, product.data['featuredImage'])
                .toString();
          }
          return itemJson;
        }).toList();

        orders.add(Order.fromJson(json));
      }

      return orders;
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    final pb = await getPocketbaseInstance();
    try {
      await pb.collection('orders').update(orderId, body: {
        'status': 'Canceled',
      });
      return true;
    } catch (e) {
      print('Error canceling order: $e');
      return false;
    }
  }

  Future<String?> reorder(String orderId) async {
    final pb = await getPocketbaseInstance();
    try {
      final orderRecord = await pb.collection('orders').getOne(orderId);
      final orderJson = orderRecord.toJson();
      orderJson.remove('id');
      orderJson['status'] = 'Pending';
      orderJson['dateTime'] = DateTime.now().toIso8601String();
      final newOrderRecord =
          await pb.collection('orders').create(body: orderJson);
      await pb.collection('orders').update(orderId, body: {
        'status': 'Deleted',
      });
      return newOrderRecord.id;
    } catch (e) {
      print('Error reordering: $e');
      return null;
    }
  }
}
