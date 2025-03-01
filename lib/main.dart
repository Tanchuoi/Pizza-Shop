import 'package:ct312h_project/ui/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/app_theme.dart';
import 'data/managers/cart_manager.dart';
import 'data/managers/order_manager.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/cart_page.dart';
import 'ui/pages/product_list_page.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/profile_page.dart';
import 'ui/pages/register_page.dart';
import 'ui/shared/theme_notifier.dart';
import 'ui/pages/order_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartManager()),
        ChangeNotifierProvider(create: (context) => OrderManager()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeNotifier.themeMode,
        builder: (context, themeMode, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pizza Shop',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            initialRoute: '/order',
            routes: {
              '/main': (context) => const MainPage(),
              '/home': (context) => HomePage(),
              '/product-list': (context) => ProductListPage(),
              '/cart': (context) => CartPage(),
              '/login': (context) => LoginPage(),
              '/register': (context) => RegisterPage(),
              '/profile': (context) => ProfilePage(),
              '/order': (BuildContext context) => OrderPage(),
            },
          );
        },
      ),
    );
  }
}
