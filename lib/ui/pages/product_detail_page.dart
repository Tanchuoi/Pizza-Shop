import 'package:ct312h_project/data/models/cart_item.dart';

import '../../data/managers/cart_manager.dart';
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "M";
  int quantity = 1;

  double _getSizePrice(String size) {
    switch (size) {
      case "S":
        return 0;
      case "M":
        return 5000;
      case "L":
        return 10000;
      default:
        return 0;
    }
  }

  // Mapping internal value to Vietnamese label
  String _getDisplaySize(String size) {
    switch (size) {
      case "S":
        return "Nhỏ";
      case "M":
        return "Vừa";
      case "L":
        return "Lớn";
      default:
        return size;
    }
  }

  double calculateTotalPrice() {
    double basePrice = widget.product.price;
    double sizePrice = _getSizePrice(selectedSize);
    return (basePrice + sizePrice) * quantity;
  }

  final List<String> sizes = ["S", "M", "L"];

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Tùy chỉnh pizza"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Product Image with Hero Animation
          Hero(
            tag: widget.product.id,
            child: (widget.product.featuredImage != '' &&
                    widget.product.featuredImage!.isNotEmpty)
                ? Image.network(
                    widget.product.featuredImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.local_pizza, color: Colors.grey),
                  ),
          ),

          // Product Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(widget.product.description,
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),

                  // Dropdown for Pizza Size
                  if (widget.product.category == "pizza") ...[
                    Text("Chọn cỡ bánh"),
                    DropdownButton<String>(
                      value: selectedSize,
                      items: sizes.map((size) {
                        return DropdownMenuItem(
                          value: size,
                          child: Text(_getDisplaySize(size)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSize = value!;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 130,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure it takes minimum space
          children: [
            // Quantity Controls (First Row)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: decrementQuantity,
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: incrementQuantity,
                ),
              ],
            ),

            // Add to Cart Button (Second Row)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final cartItem = CartItem(
                      id: widget.product.id,
                      name: widget.product.name,
                      quantity: quantity,
                      featuredImage: widget.product.featuredImage!,
                      price: widget.product.price,
                      size: selectedSize,
                      category: widget.product.category);
                  await context.read<CartManager>().addItem(cartItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm vào giỏ hàng'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Thêm vào giỏ hàng  ${calculateTotalPrice()}đ",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
