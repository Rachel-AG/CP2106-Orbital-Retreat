import 'package:retreat/constants/app_colors.dart';

import 'package:flutter/material.dart';

class TextStyles {
  static const headerTextStyle = TextStyle(
    color: AppColors.whiteshade,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const textFieldHeading = TextStyle(
    color: AppColors.darkblue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const textFieldHintStyle = TextStyle(
    color: AppColors.hintText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const buttonTextStyle = TextStyle(
    color: AppColors.whiteshade,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const optionTextStyle = TextStyle(
    color: AppColors.darkblue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const optionCategoryStyle = TextStyle(
    color: AppColors.darkblue,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static TextStyle chartLabelStyle() => TextStyle(
      color: AppColors.darkblue,
      background: Paint()
        ..strokeWidth = 18.0
        ..color = Colors.white.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round);
}
