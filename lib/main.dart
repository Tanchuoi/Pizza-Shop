import 'package:ct312h_project/data/managers/cart_manager.dart';
import 'package:ct312h_project/data/managers/product_manager.dart';
import 'package:ct312h_project/ui/pages/login_page.dart';
import 'package:ct312h_project/ui/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/cart_page.dart';
import 'ui/pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pizza Shop',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // home: ProductListPage(),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/product-list': (context) => ProductListPage(),
          '/cart': (context) => CartPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          'cart': (context) => CartPage(),
        },
      ),
    );
   
  }
}
