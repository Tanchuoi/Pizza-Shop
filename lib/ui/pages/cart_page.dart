import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/managers/cart_manager.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

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
      body: Consumer<CartManager>(
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
      ),
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
              onPressed: () {
                // Save cart and navigate to checkout
                cartManager.saveCart().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đang xử lý, vui lòng chờ...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  cartManager.clearCart();
                  // Navigate to checkout screen
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
                });
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
