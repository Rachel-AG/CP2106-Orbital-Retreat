import 'package:flutter/material.dart';

class AppColors {
  static const darkblue = Color(0xff172a3a);
  static const hintText = Color(0xffc7c7cd);
  static const red = Color.fromARGB(255, 227, 100, 100);
  static const green = Color.fromARGB(255, 90, 212, 168);

  static const MaterialColor custom =
      MaterialColor(_customPrimaryValue, <int, Color>{
    50: Color(0xfff6f7f7),
    100: Color(0xFFB9BFC4),
    200: Color(0xFF8B959D),
    300: Color(0xFF5D6A75),
    400: Color(0xFF3A4A58),
    500: Color(_customPrimaryValue),
    600: Color(0xFF142534),
    700: Color(0xFF111F2C),
    800: Color(0xFF0D1925),
    900: Color(0xFF070F18),
  });
  static const int _customPrimaryValue = 0xFF172A3A;

  static const MaterialColor customAccent =
      MaterialColor(_customAccentValue, <int, Color>{
    100: Color(0xFF5996FF),
    200: Color(_customAccentValue),
    400: Color(0xFF0058F2),
    700: Color(0xFF004FD9),
  });
  static const int _customAccentValue = 0xFF2675FF;
}
