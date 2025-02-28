import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/managers/order_manager.dart';
import '../widgets/order_list.dart';
import 'order_detail_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _viewOrderDetails(BuildContext context, String orderId) {
    final orderManager = context.read<OrderManager>();
    final order = orderManager.getOrderById(orderId);

    if (order != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(order: order),
        ),
      ).then((result) {
        if (result == 'Huỷ') {
          _cancelOrder(context, orderId);
        } else if (result == 'Đặt lại') {
          _reorder(context, orderId);
        }
      });
    }
  }

  void _cancelOrder(BuildContext context, String orderId) {
    final orderManager = context.read<OrderManager>();
    final success = orderManager.cancelOrder(orderId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hóa đơn #$orderId đã bị hủy bỏ!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể hủy bỏ hóa đơn')),
      );
    }
  }

  void _reorder(BuildContext context, String orderId) {
    final orderManager = context.read<OrderManager>();
    final newOrderId = orderManager.reorder(orderId);

    if (newOrderId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hóa đơn mới đã được tạo: #$newOrderId')),
      );
      // Switch to the active orders tab
      _tabController.animateTo(0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể đặt lại hóa đơn')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn của bạn'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hoạt động'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Đã huỷ'),
          ],
        ),
      ),
      body: Consumer<OrderManager>(
        builder: (context, orderManager, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Active orders tab
              OrderList(
                orders: orderManager.activeOrders,
                onViewDetails: (orderId) => _viewOrderDetails(context, orderId),
                onCancelOrder: (orderId) => _cancelOrder(context, orderId),
                onReorder: (orderId) => _reorder(context, orderId),
              ),

              // Completed orders tab
              OrderList(
                orders: orderManager.completedOrders,
                onViewDetails: (orderId) => _viewOrderDetails(context, orderId),
                onCancelOrder: (orderId) => _cancelOrder(context, orderId),
                onReorder: (orderId) => _reorder(context, orderId),
              ),

              // Canceled orders tab
              OrderList(
                orders: orderManager.canceledOrders,
                onViewDetails: (orderId) => _viewOrderDetails(context, orderId),
                onCancelOrder: (orderId) => _cancelOrder(context, orderId),
                onReorder: (orderId) => _reorder(context, orderId),
              ),
            ],
          );
        },
      ),
    );
  }
}
