import '../../utility/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';
import 'provider/user_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FlutterLogin(
      loginAfterSignUp: false,
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (loginData) async {
        bool isLoggedIn =
            await userProvider.login(loginData.name, loginData.password);
        return isLoggedIn ? null : 'Login gagal. Periksa email dan password.';
      },
      onSignup: (_) async => null,
      onSubmitAnimationCompleted: () {
        if (userProvider.getLoginUsr()?.sId != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      },
      onRecoverPassword: (_) async => null,
      hideForgotPasswordButton: true,
      theme: LoginTheme(
        primaryColor: AppColor.darkGrey,
        accentColor: AppColor.darkOrange,
        buttonTheme: const LoginButtonTheme(
          backgroundColor: AppColor.darkOrange,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        titleStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
