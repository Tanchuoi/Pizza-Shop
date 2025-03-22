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
  var selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = "Male";

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to today's date
      firstDate: DateTime(1900), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        selectedDate = pickedDate; // Update the selected date
        _dateController.text = formattedDate; // Update the text field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserManager>().fetchCurrentUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final user = context.read<UserManager>().user;
          if (user == null) {
            return Center(child: Text('User not found.'));
          }

          // Pre-fill the form fields (just once)
          if (_nameController.text.isEmpty) {
            _nameController.text = user.fullName ?? '';
            _emailController.text = user.email ?? '';
            _phoneController.text = user.phoneNumber ?? '';
            _selectedGender = user.gender ?? 'Male';

            if (user.birthDate != null) {
              selectedDate = user.birthDate!;
              _dateController.text =
                  DateFormat('dd/MM/yyyy').format(user.birthDate!);
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Cập nhật thông tin"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tên của bạn*"),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text("Giới tính"),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedGender,
                    items: [
                      DropdownMenuItem(value: "Male", child: Text("Nam")),
                      DropdownMenuItem(value: "Female", child: Text("Nữ")),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  Text("Chọn ngày sinh"),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true, // Prevent manual input
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                      border: OutlineInputBorder(),
                    ),
                    onTap: () =>
                        _selectDate(context), // Show date picker when tapped
                  ),
                  SizedBox(height: 12),
                  Text("Email*"),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text("Số điện thoại*"),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey.shade700,
                      ),
                      onPressed: () async {
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
                      child: Text("Cập nhật",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Cập nhật thông tin"),
    //     leading: IconButton(
    //       icon: Icon(Icons.arrow_back),
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text("Tên của bạn*"),
    //           TextField(
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(),
    //             ),
    //           ),
    //           SizedBox(height: 12),
    //           Text("Giới tính"),
    //           DropdownButtonFormField<String>(
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(),
    //             ),
    //             value: "Nam",
    //             items: ["Nam", "Nữ"].map((String value) {
    //               return DropdownMenuItem<String>(
    //                 value: value,
    //                 child: Text(value),
    //               );
    //             }).toList(),
    //             onChanged: (String? newValue) {},
    //           ),
    //           SizedBox(height: 12),
    //           Text("Chọn ngày sinh"),
    //           TextFormField(
    //             controller: _dateController,
    //             readOnly: true, // Prevent manual input
    //             decoration: InputDecoration(
    //               suffixIcon: Icon(Icons.calendar_today), // Calendar icon
    //               border: OutlineInputBorder(),
    //             ),
    //             onTap: () =>
    //                 _selectDate(context), // Show date picker when tapped
    //           ),
    //           SizedBox(height: 12),
    //           Text("Email*"),
    //           TextField(
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(),
    //             ),
    //           ),
    //           SizedBox(height: 12),
    //           Text("Số điện thoại*"),
    //           TextField(
    //             decoration: InputDecoration(
    //               border: OutlineInputBorder(),
    //             ),
    //           ),
    //           SizedBox(height: 20),
    //           SizedBox(
    //             width: double.infinity,
    //             child: ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 padding: EdgeInsets.symmetric(vertical: 16),
    //                 backgroundColor: Theme.of(context).primaryColor,
    //               ),
    //               onPressed: () {},
    //               child:
    //                   Text("Cập nhật", style: TextStyle(color: Colors.white)),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
