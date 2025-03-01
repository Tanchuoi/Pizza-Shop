import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showOptionals;

  const ProductCard(
      {Key? key, required this.product, this.showOptionals = false})
      : super(key: key);

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
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // todo: Use hero animation for image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                product.imageUrl,
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
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey),
                    ),
                    if (showOptionals) ...[
                      _buildDropdown(["Nhỏ", "Vừa", "Lớn"], "Vừa"),
                      const SizedBox(height: 4),
                      _buildDropdown(
                          ["Đế giòn", "Viền Xúc Xích", "Viền Phô Mai"],
                          "Đế giòn"),
                    ],
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
    );
  }

  Widget _buildDropdown(List<String> options, String defaultValue) {
    return Flexible(
      child: DropdownButton<String>(
        isExpanded: true,
        value: defaultValue,
        onChanged: (String? newValue) {},
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
