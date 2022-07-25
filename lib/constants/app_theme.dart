import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';

class AppTheme {
  static final lightMode = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.custom,
        backgroundColor: AppColors.custom.shade50,
      ),
      scaffoldBackgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: AppColors.custom.shade50,
      ),
      cardTheme: CardTheme(
        color: AppColors.custom.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 4.0,
        margin: const EdgeInsets.all(0.0),
      ),
      textTheme: Typography.blackHelsinki,
      bottomAppBarTheme: BottomAppBarTheme(color: AppColors.custom.shade500));

  static final darkMode = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: AppColors.custom,
          backgroundColor: AppColors.custom.shade50),
      scaffoldBackgroundColor: AppColors.custom.shade600,
      iconTheme: IconThemeData(
        color: AppColors.custom.shade50,
      ),
      cardTheme: CardTheme(
        color: AppColors.custom,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 4.0,
        margin: const EdgeInsets.all(0.0),
      ),
      textTheme: Typography.whiteHelsinki,
      appBarTheme: AppBarTheme(color: AppColors.custom.shade800),
      bottomAppBarTheme: BottomAppBarTheme(color: AppColors.custom.shade800),
      inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          hintStyle: TextStyle(
            color: AppColors.custom.shade100,
          ),
          labelStyle: TextStyle(
            color: AppColors.custom.shade100,
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: AppColors.custom.shade800, // This is a custom color variable
      )),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: AppColors.custom.shade50, // This is a custom color variable
        ),
      ),
      dialogTheme: DialogTheme(backgroundColor: AppColors.custom.shade800));
}
