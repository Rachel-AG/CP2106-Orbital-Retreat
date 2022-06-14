import 'package:flutter/material.dart';

import '../constants/text_styles.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      required this.controller,
      this.initialValue})
      : super(key: key);

  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextEditingController controller;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        labelText: labelText,
        labelStyle: TextStyles.textFieldHeading,
        hintText: hintText,
        hintStyle: TextStyles.textFieldHintStyle,
      ),
    );
  }
}
