import 'package:flutter/material.dart';

import '../../data/models/product.dart';
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
