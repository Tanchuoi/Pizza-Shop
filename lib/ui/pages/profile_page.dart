import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Center(
          child: Text(
            'Cài Đặt Tài Khoản',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10), // Add spacing
        Expanded(
          child: ListView(
            children: [
              _buildListTile('Theo dõi đơn hàng', () {
                Navigator.pushNamed(context, '/order');
              }),
              _buildListTile('Cập nhật thông tin', () {
                Navigator.pushNamed(context, '/update-profile');
              }),
              _buildListTile('Đăng xuất', () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.grey.shade300), // Add border
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
