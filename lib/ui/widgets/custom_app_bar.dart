import 'package:ct312h_project/ui/shared/theme_notifier.dart';
import 'package:flutter/material.dart';
import '../../data/managers/cart_manager.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        cartManager.loadCart();
        return AppBar(
          leading: ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeNotifier.themeMode,
            builder: (context, themeMode, child) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black, // Ensure visibility
                ),
                onPressed: ThemeNotifier.toggleTheme,
              );
            },
          ),
          title: Image.asset("assets/images/logo.png", height: 40),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Badge.count(
                count: cartManager.productCount,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
