import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../widgets/product_card.dart';
import '../../data/managers/product_manager.dart';

class ProductListPage extends StatelessWidget {
  final List<String> categories = [
    "MUA 1 TẶNG 1",
    "PIZZA",
    "GHIỀN GÀ",
    "MUA KÈM"
  ];
  final List<Product> products = ProductManager.getProducts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map((category) => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: category == "PIZZA",
                          selectedColor: Colors.red,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: category == "PIZZA"
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (selected) {},
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                shrinkWrap: true, // Prevents infinite height error
                physics:
                    NeverScrollableScrollPhysics(), // Disables inner scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
            SizedBox(height: 10), // Space before bottom bar
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Thanh toán • 7 món",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Text("583,000đ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
