import 'package:ct312h_project/data/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/product.dart';
import '../../data/managers/cart_manager.dart';
import '../pages/product_detail_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String selectedSize = "M";
  int quantity = 1;

  final Map<String, double> sizePriceMap = {
    "S": 0,
    "M": 5000,
    "L": 10000,
  };

  final Map<String, String> sizeDisplayMap = {
    "S": "Nhỏ",
    "M": "Vừa",
    "L": "Lớn",
  };

  double calculateTotalPrice() {
    double basePrice = widget.product.price;
    double sizePrice = sizePriceMap[selectedSize] ?? 0;
    return (basePrice + sizePrice) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    print("Image URL: ${widget.product.featuredImage}");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product),
          ),
        );
      },
      child: SizedBox(
        // Adjust height to prevent overflow
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.product.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: (widget.product.featuredImage != '' &&
                          widget.product.featuredImage!.isNotEmpty)
                      ? Image.network(
                          widget.product.featuredImage!,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[300],
                          child:
                              const Icon(Icons.local_pizza, color: Colors.grey),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(widget.product.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        widget.product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 8),
                    // **Dropdowns for Pizza Size**

                    if (widget.product.category == "pizza") ...[
                      Text("Chọn cỡ bánh"),
                      SizedBox(height: 8),
                      _buildDropdownButton(sizeDisplayMap),
                    ],

                    SizedBox(height: 8),

                    FilledButton(
                      onPressed: () async {
                        final cartItem = CartItem(
                          id: widget.product.id,
                          name: widget.product.name,
                          quantity: 1,
                          featuredImage: widget.product.featuredImage!,
                          price: widget.product.price,
                          size: widget.product.category == "pizza"
                              ? selectedSize
                              : "",
                          category: widget.product.category,
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
                            Text("${calculateTotalPrice()}đ"),
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

  Widget _buildDropdownButton(Map<String, String> displayMap) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedSize, // Default selection
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedSize = newValue!;
        });
      },
      items: displayMap.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value, style: TextStyle(fontSize: 14)),
        );
      }).toList(),
    );
  }
}
