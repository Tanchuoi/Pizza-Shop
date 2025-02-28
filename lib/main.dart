import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/cart_page.dart';
import 'ui/pages/product_list_page.dart';
import 'data/managers/cart_manager.dart';
import 'ui/pages/order_page.dart';
import 'data/managers/order_manager.dart';
import 'data/managers/product_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrderManager(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pizza Shop',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/product-list': (context) => ProductListPage(),
          '/cart': (context) => const CartPage(), // Added cart route
          '/order': (context) => const OrderPage(),
        },
      ),
    );
  }
}
