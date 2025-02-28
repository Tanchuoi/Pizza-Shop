import 'package:ct312h_project/ui/widgets/custom_app_bar.dart';
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
      appBar: CustomAppBar(),
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
