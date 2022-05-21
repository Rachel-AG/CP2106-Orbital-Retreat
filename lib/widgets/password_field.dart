import 'package:flutter/material.dart';

import '../constants/text_styles.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldSubmmitted,
      required this.controller})
      : super(key: key);

  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmmitted;
  final TextEditingController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      maxLength: 25,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmmitted,
      controller: widget.controller,
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyles.textFieldHintStyle,
          labelText: widget.labelText,
          labelStyle: TextStyles.textFieldHeading,
          helperText: widget.helperText,
          helperStyle: TextStyles.textFieldHintStyle,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          )),
    );
  }
}
