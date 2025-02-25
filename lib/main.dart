import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/products_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.purple,
      secondary: Colors.deepOrange,
      surface: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    final themeData = ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary, // Set the AppBar color
          foregroundColor:
              colorScheme.onPrimary, // Ensure the text color contrasts well
          elevation: 4,
        ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Shop',
      theme: themeData,
      home: const ProductsListPage(),
    );
  }
}
