import 'package:ct312h_project/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/cart_item.dart';

class CartItemCard extends StatefulWidget {
  final CartItem item;
  final Function(CartItem, int) onUpdateQuantity;
  final Function(CartItem) onRemoveItem;
  final Function(CartItem, String) onUpdateSize;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onUpdateSize,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late String selectedSize;
  late double selectedPrice;

  double calculateTotalPrice() {
    double price = widget.item.price;
    return (price + selectedPrice) * widget.item.quantity;
  }

  double getSizePrice(String size) {
    if (size == "M") {
      selectedPrice = 5000;
    } else if (size == "L") {
      selectedPrice = 10000;
    } else {
      selectedPrice = 0;
    }
    return selectedPrice;
  }

  @override
  void initState() {
    super.initState();
    selectedPrice = getSizePrice(widget.item.size ?? 'S');
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onRemoveItem(widget.item);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        final confirmed = await showConfirmDialog(
          context,
          'Xác nhận xóa sản phẩm',
          'Bạn có chắc chắn muốn xóa sản phẩm này?',
        );

        if (confirmed!) {
          // Wait for the widget to dismiss first, then show snackbar
          Future.delayed(Duration(milliseconds: 300), () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã xóa sản phẩm'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          });
          return true;
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pizza image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (widget.item.featuredImage != '' &&
                        widget.item.featuredImage!.isNotEmpty)
                    ? Image.network(
                        widget.item.featuredImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child:
                            const Icon(Icons.local_pizza, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 16),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.item.price.toStringAsFixed(2)}đ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.item.category == 'pizza') ...[
                      Text(
                        'Giá kích thước: ${NumberFormat.currency(locale: "vi_VN", symbol: "đ").format(selectedPrice)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.item.quantity} x ${selectedPrice.toStringAsFixed(2)}đ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16),
                                onPressed: () => widget.onUpdateQuantity(
                                    widget.item, widget.item.quantity - 1),
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              Text(
                                '${widget.item.quantity}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16),
                                onPressed: () => widget.onUpdateQuantity(
                                    widget.item, widget.item.quantity + 1),
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Size dropdown
                        if (widget.item.category == 'pizza') ...[
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: widget.item.size,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    widget.item.size = newValue;
                                    widget.onUpdateSize(widget.item, newValue);
                                    selectedPrice = getSizePrice(newValue);
                                  });
                                }
                              },
                              items: const [
                                DropdownMenuItem(
                                  child: Text('Nhỏ'),
                                  value: 'S',
                                ),
                                DropdownMenuItem(
                                  child: Text('Vừa'),
                                  value: 'M',
                                ),
                                DropdownMenuItem(
                                  child: Text('Lớn'),
                                  value: 'L',
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
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
}
