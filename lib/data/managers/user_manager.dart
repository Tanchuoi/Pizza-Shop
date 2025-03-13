import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserManager extends ChangeNotifier {
  late final UserService _userService;
  User? _currentUser;

  bool get isAuth {
    return _currentUser != null;
  }

  User? get user {
    return _currentUser;
  }

  UserManager() {
    _userService = UserService(onAuthChange: (user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> fetchCurrentUser() async {
    _currentUser = await _userService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> register(User user, String password) async {
    try {
      await _userService.register(user, password);
      return true;
    } catch (e) {
      print("Registration failed: $e");
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    await _userService.login(email, password);
    await fetchCurrentUser();
  }

  Future<void> logout() async {
    await _userService.logout();
    _currentUser = null;
    notifyListeners();
  }
}
