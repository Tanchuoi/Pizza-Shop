import 'package:flutter/material.dart';
import '../../data/models/order.dart';
import 'order_item.dart';

class OrderList extends StatelessWidget {
  final List<Order> orders;
  final Function(String) onViewDetails;
  final Function(String) onCancelOrder;
  final Function(String) onReorder;

  const OrderList({
    Key? key,
    required this.orders,
    required this.onViewDetails,
    required this.onCancelOrder,
    required this.onReorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (ctx, i) => OrderItemWidget(
        order: orders[i],
        onViewDetails: onViewDetails,
        onCancelOrder: onCancelOrder,
        onReorder: onReorder,
      ),
    );
  }
}
