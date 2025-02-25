import 'package:flutter/material.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.webp',
          height: 40,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Text('Products List Page11232'),
    );
  }
}
