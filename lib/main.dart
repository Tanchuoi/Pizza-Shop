import 'package:ct312h_project/data/managers/user_manager.dart';
import 'package:ct312h_project/ui/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/app_theme.dart';
import 'data/managers/cart_manager.dart';
import 'data/managers/order_manager.dart';
import 'data/managers/user_manager.dart';
import 'data/managers/product_manager.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/cart_page.dart';
import 'ui/pages/product_list_page.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/profile_page.dart';
import 'ui/pages/register_page.dart';
import 'ui/shared/theme_notifier.dart';
import 'ui/pages/order_page.dart';
import 'ui/pages/update_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ThemeNotifier.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserManager()),
        ChangeNotifierProvider(create: (context) => CartManager()),
        ChangeNotifierProvider(create: (context) => OrderManager()),
        ChangeNotifierProvider(create: (context) => ProductManager()),
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
            initialRoute: '/login',
            routes: {
              '/main': (context) => const MainPage(),
              '/home': (context) => HomePage(),
              '/product-list': (context) => ProductListPage(),
              '/cart': (context) => CartPage(),
              '/login': (context) => LoginPage(),
              '/register': (context) => RegisterPage(),
              '/profile': (context) => ProfilePage(),
              '/order': (BuildContext context) => OrderPage(),
              '/update-profile': (context) => UpdateProfilePage(),
            },
          );
        },
      ),
    );
  }
}
