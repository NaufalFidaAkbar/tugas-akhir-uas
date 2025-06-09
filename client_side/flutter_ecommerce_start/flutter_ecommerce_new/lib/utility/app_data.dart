import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class AppData {
  const AppData._();

  static List<BottomNavyBarItem> bottomNavyBarItems = [
    BottomNavyBarItem(
      icon: Icon(Icons.home),
      title: Text("Home"),
      activeColor: Color(0xFFEC6813),
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.favorite),
      title: Text("Favorite"),
      activeColor: Color(0xFFEC6813),
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.shopping_cart),
      title: Text("Cart"),
      activeColor: Color(0xFFEC6813),
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.person),
      title: Text("Profile"),
      activeColor: Color(0xFFEC6813),
    ),
  ];

  static List<Color> randomPosterBgColors = [
    Color(0xFFE70D56),
    Color(0xFF9006A4),
    Color(0xFF137C0B),
    Color(0xFF0F2EDE),
    Color(0xFFECBE23),
    Color(0xFFA60FF1),
    Color(0xFF0AE5CF),
    Color(0xFFE518D1),
  ];
}
