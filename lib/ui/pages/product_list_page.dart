import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../data/managers/product_manager.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Map<String, String>> categories = [
    {"display": "PIZZA", "value": "pizza"},
    {"display": "GHIỀN GÀ", "value": "chicken"},
    {"display": "MÓN KHAI VỊ", "value": "appetizer"},
    {"display": "THỨC UỐNG", "value": "drink"},
  ];

  String selectedCategory = "pizza"; // Default category
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateProductsByCategory(selectedCategory);
  }

  Future<void> _updateProductsByCategory(String category) async {
    setState(() => isLoading = true);
    try {
      await Provider.of<ProductManager>(context, listen: false)
          .getProductsByCategory(category);
      setState(() {
        selectedCategory = category;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductManager>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 40),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
        bottom: _productCategoryNavbar(),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Không có sản phẩm nào trong danh mục này"),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
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
                .map(
                  (category) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: ChoiceChip(
                      label: Text(
                        category["display"]!,
                        style: TextStyle(
                          color: selectedCategory == category["value"]
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      selected: selectedCategory == category["value"],
                      selectedColor: Colors.red,
                      onSelected: (selected) {
                        if (selected) {
                          _updateProductsByCategory(category["value"]!);
                        }
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
