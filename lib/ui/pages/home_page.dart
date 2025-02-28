import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onDestinationTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // if (index == 0) {
    //   Navigator.pushNamed(context, '/');
    // }

    if (index == 2) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            currentIndex: _selectedIndex,
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
            onTap: _onDestinationTapped,
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
