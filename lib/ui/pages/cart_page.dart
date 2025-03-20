import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/managers/cart_manager.dart';
import '../widgets/cart_item_card.dart';
import '../../data/managers/order_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<void> _fetchCartItems;
  @override
  void initState() {
    super.initState();
    _fetchCartItems = context.read<CartManager>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng của bạn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: _fetchCartItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
              );
            } else {
              return Consumer<CartManager>(
                builder: (context, cartManager, child) {
                  if (cartManager.isEmpty) {
                    return _buildEmptyCart();
                  }

                  return Column(
                    children: [
                      // List of cart items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartManager.items.length,
                          itemBuilder: (context, index) {
                            final item = cartManager.items[index];
                            return CartItemCard(
                              item: item,
                              onUpdateQuantity: cartManager.updateQuantity,
                              onRemoveItem: cartManager.removeItem,
                            );
                          },
                        ),
                      ),

                      // Order summary and checkout button
                      _buildOrderSummary(context, cartManager),
                    ],
                  );
                },
              );
            }
          }),
    );
  }

  // Empty cart widget
  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Giỏ hàng của bạn trống',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy thêm sản phẩm vào giỏ hàng của bạn',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Order summary widget
  Widget _buildOrderSummary(BuildContext context, CartManager cartManager) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subtotal row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tạm thu:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '${cartManager.subtotal.toStringAsFixed(2)}đ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Delivery fee row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Phí vận chuyển:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '${cartManager.deliveryFee.toStringAsFixed(2)}đ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${cartManager.totalPrice.toStringAsFixed(2)}đ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Save cart and navigate to checkout
                final success = await context.read<OrderManager>().placeOrder(
                      cartManager.items,
                      cartManager.totalPrice,
                      'Hà Nội, Việt Nam',
                    );
                if (success) {
                  //cartManager.markItemsAsCheckedOut(cartManager.items);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đặt hàng thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  cartManager.clearCart();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã xảy ra lỗi, vui lòng thử lại sau!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Thanh toán',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
