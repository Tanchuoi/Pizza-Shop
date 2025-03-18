import 'package:flutter/material.dart';
import '../../data/models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = "Vừa";
  String selectedCrust = "Đế Kéo Tay";
  int quantity = 1;
  int totalPrice = 0;

  double calculateTotalPrice() {
    double price = widget.product.price;
    if (selectedSize == "Vừa") {
      price += 50000;
    } else if (selectedSize == "Lớn") {
      price += 10000;
    }
    return price * quantity;
  }

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
          Image.network(
            widget.product.featuredImage!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
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
                  Text("Chọn kích thước bánh", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSize,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSize = newValue!;
                      });
                    },
                    items: ["Nhỏ", "Vừa", "Lớn"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
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
                onPressed: () {
                  print("da them san pham");
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
