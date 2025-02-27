import 'package:flutter/material.dart';

import '../widgets/cart_item_card.dart';
import '../../data/managers/cart_manager.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = CartManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
      ),
      body: Column(
        children: [
          CartSummary(
            cart: cart,
            onOrderNowPressed: cart.totalAmount <= 0
                ? null
                : () {
                    print('Order placed');
                  },
          ),
          const SizedBox(height: 10),
          Expanded(child: CartItemList(cart)),
        ],
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList(this.cart, {Key? key}) : super(key: key);

  final CartManager cart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cart.products
          .map((cartItem) => CartItemCard(
                productId: cartItem.id,
                cartItem: cartItem,
              ))
          .toList(),
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.cart,
    this.onOrderNowPressed,
  });

  final CartManager cart;
  final void Function()? onOrderNowPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '${cart.totalAmount.toStringAsFixed(2)} VND',
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            TextButton(
              onPressed: onOrderNowPressed,
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: const Text('Thanh Toán'),
            ),
          ],
        ),
      ),
    );
  }
}
