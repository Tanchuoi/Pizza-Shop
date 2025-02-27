import 'package:flutter/material.dart';

// TODO: Implement CustomAppBar
class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final List<Widget>? leading = [];

    return AppBar(
      title: Image.asset(
        "assets/images/logo.png",
        height: 40,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }
}
