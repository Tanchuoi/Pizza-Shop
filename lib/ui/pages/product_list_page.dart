import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../widgets/product_card.dart';
import '../../data/managers/product_manager.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<String> categories = [
    "PIZZA",
    "GHIỀN GÀ",
    "MÓN KHAI VỊ",
    "THỨC UỐNG",
  ];

  String selectedCategory = "PIZZA"; // Default selected category
  List<Product> products = []; // Will be populated in initState

  @override
  void initState() {
    super.initState();
    // Initialize products with the selected category
    products = ProductManager.getProductsByCategory(selectedCategory);
  }

  // Method to update products when category changes
  void _updateProductsByCategory(String category) {
    setState(() {
      selectedCategory = category;
      products = ProductManager.getProductsByCategory(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
        bottom: _productCategoryNavbar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: products.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("Không có sản phẩm nào trong danh mục này"),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              print("da them san pham");
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("Thanh toán: 4 món")),
                  Text("123,966,667đ")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _productCategoryNavbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        height: 50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories
                .map((category) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: selectedCategory == category,
                        selectedColor: Colors.red,
                        backgroundColor: Colors.white,
                        onSelected: (selected) {
                          if (selected) {
                            _updateProductsByCategory(category);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
