import 'package:ct312h_project/data/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/product.dart';
import '../../data/managers/cart_manager.dart';
import '../pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: SizedBox(
        height: 320,
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // todo: Use hero animation for image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  'assets/images/pizza.png',
                  height: 120, // Fixed height for the image
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                // ✅ Fix: Ensures Column fits within available space
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Flexible(
                        // ✅ Fix: Prevents DropdownButton from causing overflow
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: "Vừa",
                          onChanged: (String? newValue) {},
                          items: ["Nhỏ", "Vừa", "Lớn"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 4),
                      Flexible(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: "Đế Kéo Tay",
                          onChanged: (String? newValue) {},
                          items: ["Đế Kéo Tay", "Viền Đồng Tiền"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Spacer(),
                      FilledButton(
                        onPressed: () async {
                          final cartItem = CartItem(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(), // temp ID
                            name: product.name,
                            quantity: 1,
                            imageUrl: product.imageUrl,
                            price: product.price.toDouble(),
                          );
                          await context.read<CartManager>().addItem(cartItem);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm vào giỏ hàng'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text("Thêm")),
                              Text("${product.price}đ")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text("Chọn cỡ bánh"),
                      Container(
                        height: 35, // Fixed height for the dropdown
                        child: _buildDropdownButton(),
                      ),
                      SizedBox(height: 8),
                      Text("Chọn đế bánh"),
                      Container(
                        height: 45, // Fixed height for the dropdown
                        child: _buildDropdownButton(),
                      ),
                      Spacer(),
                      FilledButton(
                        //change border radius
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                              Flexible(child: Text("Thêm")),
                              Text("${product.price}đ")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: "Vừa",
      // Removed decoration to reduce height
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        isDense: true, // Makes the dropdown more compact
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (String? newValue) {},
      items:
          ["Nhỏ", "Vừa", "Lớn"].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child:
              Text(value, style: TextStyle(fontSize: 14)), // Smaller font size
        );
      }).toList(),
    );
  }
}
