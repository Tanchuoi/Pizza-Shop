import 'package:ct312h_project/ui/shared/dialog_utils.dart';
import 'package:flutter/material.dart';
import '../../data/models/order.dart';
import '../../data/models/cart_item.dart';
import '../../data/managers/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;
  final Function(String) onViewDetails;
  final Function(String) onCancelOrder;
  final Function(String) onReorder;

  const OrderItemWidget({
    Key? key,
    required this.order,
    required this.onViewDetails,
    required this.onCancelOrder,
    required this.onReorder,
  }) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final userManager = Provider.of<UserManager>(context);
    final currentAddress =
        userManager.user?.address ?? '91 Đ. 3 Tháng 2, Hưng Lợi, Ninh Kiều';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hóa đơn #${widget.order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('dd MM, yyyy').format(widget.order.date),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.order.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.order.status == "Delivered"
                            ? 'Đã giao'
                            : widget.order.status == "Canceled"
                                ? 'Đã hủy'
                                : 'Đang giao hàng',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.order.total.toStringAsFixed(2)}đ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Địa chỉ giao hàng:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentAddress,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => widget.onViewDetails(widget.order.id),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Xem thêm'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    if (widget.order.status == "Delivered" ||
                        widget.order.status == "Canceled")
                      ElevatedButton.icon(
                        onPressed: () => widget.onReorder(widget.order.id),
                        icon: const Icon(Icons.replay_outlined, size: 16),
                        label: const Text('Đặt lại'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    if (widget.order.status == "Pending")
                      TextButton.icon(
                        onPressed: () async {
                          bool? confirm = await showConfirmDialog(
                              context,
                              'Xác nhận xóa hoá đơn',
                              'Bạn có chắc chắn muốn xóa hoá đơn này?');

                          if (confirm == true) {
                            widget.onCancelOrder(widget.order.id);
                          }
                        },
                        icon: const Icon(Icons.cancel_outlined,
                            size: 16, color: Colors.red),
                        label: const Text('Hủy',
                            style: TextStyle(color: Colors.red)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.order.items.length} món',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),

          // Expanded items list
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.order.items.length,
                itemBuilder: (ctx, i) =>
                    _buildOrderItemRow(widget.order.items[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(CartItem item) {
    double getSizePrice(String size) {
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: item.featuredImage != null && item.featuredImage!.isNotEmpty
                ? Image.network(
                    item.featuredImage!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.local_pizza, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Size: ${item.size}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Size Price:${item.quantity} x ${getSizePrice(item.size!)}đ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Amount: ${item.quantity} x ${item.price.toStringAsFixed(2)}đ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Item total
          Text(
            'Total: ${((item.price + getSizePrice(item.size!)) * item.quantity).toStringAsFixed(2)}đ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
