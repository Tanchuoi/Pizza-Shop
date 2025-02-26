import 'package:flutter/material.dart';

import '../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Thêm"),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${product.price}đ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
