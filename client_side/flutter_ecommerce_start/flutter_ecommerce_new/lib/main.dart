import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'core/data/data_provider.dart';
import 'screen/login_screen/provider/user_provider.dart';
import 'screen/product_favorite_screen/provider/favorite_provider.dart';
import 'screen/product_cart_screen/provider/cart_provider.dart';
import 'screen/profile_screen/provider/profile_provider.dart';

import 'screen/home_screen.dart';
import 'screen/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final dataProvider = DataProvider();
  final userProvider = UserProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(create: (_) => dataProvider),
        ChangeNotifierProvider<UserProvider>(
            create: (_) => userProvider..loadLoginInfo()),
        ChangeNotifierProvider<FavoriteProvider>(
            create: (_) => FavoriteProvider(dataProvider)),
        ChangeNotifierProvider<CartProvider>(
            create: (_) => CartProvider(userProvider)),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider(dataProvider)), // ✅ Fix
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const AppEntryPoint(),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = userProvider.getLoginUsr();
        return (user == null || user.sId == null)
            ? const LoginScreen()
            : const HomeScreen();
      },
    );
  }
}
