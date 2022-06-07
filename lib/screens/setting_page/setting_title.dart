import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/text_styles.dart';

class SettingTitle extends StatelessWidget {
  final String text;
  final IconData icon;

  const SettingTitle({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.darkblue,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyles.optionCategoryStyle,
            )
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
        ),
      ],
    );
  }
}
