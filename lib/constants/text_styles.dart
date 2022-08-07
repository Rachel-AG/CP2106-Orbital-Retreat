import 'package:retreat/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:retreat/notifiers/theme_mode_change_notifier.dart';

/// to store the fonts used in Retreat
class TextStyles {
  static var headerTextStyle = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textFieldHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ThemeModeChangeNotifier().textDefaultColor,
  );

  static TextStyle textFieldHintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: ThemeModeChangeNotifier().textDefaultColor,
  );

  static var buttonTextStyle = const TextStyle(
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
    fontWeight: FontWeight.w500,
  );

  static const optionCategoryStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const chartTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const title = TextStyle(
    fontSize: 42,
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

  static const coinsDisplay = TextStyle(
    color: Colors.amber,
    fontWeight: FontWeight.w800,
    fontSize: 20,
  );

  static var percentage = TextStyle(color: AppColors.custom.shade100);
}
