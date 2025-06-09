import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/user.dart';
import '../../../services/http_services.dart';
import '../../../utility/constants.dart';

class UserProvider extends ChangeNotifier {
  final HttpService service = HttpService();
  final box = GetStorage();

  User? _loginUser;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  User? getLoginUsr() => _loginUser;

  // Login user dan simpan ke storage
  Future<bool> login(String email, String password) async {
    try {
      final response = await service.loginUser(email, password);
      if (response.statusCode == 200) {
        _loginUser = User.fromJson(jsonDecode(response.body));
        await saveLoginInfo(_loginUser!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // Simpan informasi user ke GetStorage
  Future<void> saveLoginInfo(User user) async {
    await box.write(USER_INFO_BOX, user.toJson());
    notifyListeners();
  }

  // Load info login saat app dibuka
  Future<void> loadLoginInfo() async {
    final dynamic stored = box.read(USER_INFO_BOX);
    if (stored != null && stored is Map<String, dynamic>) {
      _loginUser = User.fromJson(stored);
      print('User sudah login: ${_loginUser?.email}');
    } else {
      print('Tidak ada user yang login.');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Logout user
  void logOutUser() {
    _loginUser = null;
    box.remove(USER_INFO_BOX);
    notifyListeners();
  }
}
