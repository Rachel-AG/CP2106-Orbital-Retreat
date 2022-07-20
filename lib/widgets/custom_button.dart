import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';

import '../constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const CustomButton({Key? key, required this.onTap, this.text = 'Button'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: AppColors.custom,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Center(
          child: Text(
            text,
            style: TextStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}
