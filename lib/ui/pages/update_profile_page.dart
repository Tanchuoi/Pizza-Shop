import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/user.dart';
import '../../data/managers/user_manager.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedGender;
  bool _isInitialized = false;

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = formattedDate;
      });
    }
  }

  // Initialize form with user data
  void _initializeForm(User user) {
    if (!_isInitialized) {
      setState(() {
        _nameController.text = user.fullName ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber ?? '';

        // Make sure gender is one of the available options
        if (user.gender == 'Male' || user.gender == 'Female') {
          _selectedGender = user.gender;
        } else {
          _selectedGender = 'Male'; // Default value
        }

        if (user.birthDate != null) {
          selectedDate = user.birthDate;
          _dateController.text =
              DateFormat('dd/MM/yyyy').format(user.birthDate!);
        }

        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserManager>().fetchCurrentUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = context.read<UserManager>().user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User not found.')),
          );
        }

        // Initialize form with user data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initializeForm(user);
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text("Cập nhật thông tin"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tên của bạn*"),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Giới tính"),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Nam")),
                      DropdownMenuItem(value: "Female", child: Text("Nữ")),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text("Chọn ngày sinh"),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 12),
                  const Text("Email*"),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Số điện thoại*"),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey.shade700,
                      ),
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Vui lòng điền đầy đủ thông tin bắt buộc.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final success =
                            await context.read<UserManager>().updateProfile(
                                  User(
                                    fullName: _nameController.text,
                                    email: _emailController.text,
                                    phoneNumber: _phoneController.text,
                                    birthDate: selectedDate,
                                    gender: _selectedGender,
                                  ),
                                );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Cập nhật thất bại. Vui lòng thử lại.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Cập nhật",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
