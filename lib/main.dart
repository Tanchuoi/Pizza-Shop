import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/product_list_page.dart';

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
      home: ProductListPage(),
    );
  }
}
