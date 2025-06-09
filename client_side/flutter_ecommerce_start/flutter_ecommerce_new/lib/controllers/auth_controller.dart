import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/http_services.dart'; // Ganti dengan lokasi file HttpService.dart

class AuthController extends GetxController {
  final HttpService _httpService = HttpService();
  var isLoading = false.obs;
  var loginError = ''.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    isLoading.value = true;
    loginError.value = '';

    final email = emailController.text.trim();
    final password = passwordController.text;

    final response = await _httpService.loginUser(email, password);

    if (response.statusCode == 200) {
      print('Login berhasil: ${response.body}');
      Get.snackbar('Sukses', 'Login berhasil!');
      // Tambahkan navigasi ke halaman utama (misalnya HomeScreen)
      // Get.to(HomeScreen()); // Ganti dengan nama screen yang sesuai
    } else {
      print('Login gagal: ${response.body}');
      loginError.value = 'Login gagal. Periksa email dan password.';
      Get.snackbar('Error', loginError.value);
    }

    isLoading.value = false;
  }
}
