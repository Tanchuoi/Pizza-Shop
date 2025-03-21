import 'package:ct312h_project/data/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final fullName = _fullNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mật khẩu không khớp")),
      );
      return;
    }

    final user = User(
      fullName: fullName,
      username: username,
      email: email,
      phoneNumber: phone,
    );

    final success = await context.read<UserManager>().register(user, password);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công")),
      );
      Navigator.pushNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thất bại. Vui lòng thử lại.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double inputWidth =
        MediaQuery.of(context).size.width > 600 ? 600 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 40),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: _fullNameController,
                decoration: _inputDecoration('Họ và tên'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: _usernameController,
                decoration: _inputDecoration('Tên đăng nhập'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: _phoneController,
                decoration: _inputDecoration('Số điện thoại'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration('Mật khẩu').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: inputWidth,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: _inputDecoration('Xác nhận mật khẩu').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: inputWidth,
              child: OutlinedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _handleRegister,
                child: const Text('Đăng ký'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bạn đã có tài khoản?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Đăng nhập'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
