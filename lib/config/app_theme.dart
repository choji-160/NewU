import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF630068),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF630068),
      secondary: Color(0xFFF57C00),
      surface: Colors.white,
    ),
    fontFamily: 'Inter',
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF823386),
    scaffoldBackgroundColor: const Color(0xFF140016),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF823386),
      secondary: Color(0xFFF57C00),
      surface: Color(0xFF2D1B2E),
    ),
    fontFamily: 'Inter',
    useMaterial3: true,
  );
}
