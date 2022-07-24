import 'package:retreat/constants/app_colors.dart';

import 'package:flutter/material.dart';

class TextStyles {
  static var headerTextStyle = TextStyle(
    color: AppColors.custom.shade50,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const textFieldHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const textFieldHintStyle = TextStyle(
    color: AppColors.hintText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static var buttonTextStyle = TextStyle(
    color: AppColors.custom.shade50,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const optionTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const subOptionTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300, height: 1.4);

  static const profileTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const optionCategoryStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const chartTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle chartLabelStyle() => TextStyle(
      color: AppColors.darkblue,
      background: Paint()
        ..strokeWidth = 18.0
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round);

  static const incomeAmount = TextStyle(
    fontSize: 15,
    color: AppColors.green,
    fontWeight: FontWeight.w600,
  );

  static const expenseAmount = TextStyle(
    fontSize: 15,
    color: AppColors.red,
    fontWeight: FontWeight.w600,
  );

  static var percentage = TextStyle(color: AppColors.custom.shade100);
}
