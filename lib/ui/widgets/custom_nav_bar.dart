import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Empty space for floating button
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Tài Khoản',
            ),
          ],
          onTap: onTap,
        ),
        Positioned(
          top: -25, // Adjust this to move the floating button
          left: MediaQuery.of(context).size.width / 2 - 35, // Centering
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/product-list');
                },
                backgroundColor: Colors.white,
                elevation: 5,
                shape: const CircleBorder(),
                child: const Icon(Icons.local_pizza,
                    size: 30, color: Colors.black),
              ),
              const SizedBox(height: 4), // Space between button and label
              const Text(
                'Thực đơn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
