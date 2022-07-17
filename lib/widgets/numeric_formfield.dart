import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/text_styles.dart';

class NumericFormField extends StatelessWidget {
  const NumericFormField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      required this.controller})
      // this.initialValue})
      : super(key: key);

  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextEditingController controller;
  //final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      //initialValue: initialValue,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
      ],
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
