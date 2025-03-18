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
    print("Product data: ${product.toJson()}");
    print("Image URL: ${product.featuredImage}");

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
        height: 350, // Adjust height to prevent overflow
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: product.featuredImage != null
                    ? Image.network(
                        product.featuredImage!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading image: $error");
                          return Image.asset(
                            'assets/images/pizza.png', // Fallback image
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/pizza.png', // Default image when URL is null
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
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

                    // **Dropdowns for Pizza Size and Crust**
                    Text("Chọn cỡ bánh"),
                    _buildDropdownButton(["Nhỏ", "Vừa", "Lớn"]),

                    SizedBox(height: 8),
                    // **Button to Add to Cart**
                    FilledButton(
                      onPressed: () async {
                        final cartItem = CartItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: product.name,
                          quantity: 1,
                          imageUrl: product.featuredImage ??
                              'assets/images/pizza.png',
                          price: product.price.toDouble(),
                        );
                        await context.read<CartManager>().addItem(cartItem);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
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
                            Text("Thêm"),
                            Text("${product.price}đ"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(List<String> options) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: options.first, // Default selection
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (String? newValue) {},
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontSize: 14)),
        );
      }).toList(),
    );
  }
}
