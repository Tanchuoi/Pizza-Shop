import 'package:ct312h_project/ui/pages/home_page.dart';
import 'package:ct312h_project/ui/pages/profile_page.dart';
import 'package:ct312h_project/ui/widgets/custom_app_bar.dart';
import 'package:ct312h_project/ui/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SizedBox(), // Placeholder for Floating Button
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index != 1) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
