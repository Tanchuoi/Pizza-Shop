import 'package:ct312h_project/ui/pages/login_page.dart';
import 'package:ct312h_project/ui/pages/register_page.dart';
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/product_list_page.dart';
import 'ui/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Shop',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // home: LoginPage(),

      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/product-list': (context) => ProductListPage(),
      },
    );
  }
}
