import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/app_theme.dart';
import 'data/managers/cart_manager.dart';
import 'data/managers/product_manager.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/cart_page.dart';
import 'ui/pages/product_list_page.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/register_page.dart';
import 'ui/shared/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pizza Shop',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/product-list': (context) => ProductListPage(),
            '/cart': (context) => CartPage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
          },
        );
      },
    );
  }
}
