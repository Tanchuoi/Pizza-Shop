import 'package:ct312h_project/ui/pages/product_list_page.dart'
    show ProductListPage;
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
          top: -25,
          left: MediaQuery.of(context).size.width / 2 - 35,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ProductListPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Slide from right
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                backgroundColor: Colors.white,
                elevation: 5,
                shape: const CircleBorder(),
                child: const Icon(Icons.local_pizza,
                    size: 30, color: Colors.black),
              ),
              const SizedBox(height: 4),
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
