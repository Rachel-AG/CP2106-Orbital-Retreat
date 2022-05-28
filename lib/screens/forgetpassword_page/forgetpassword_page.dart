import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_state.dart';

import 'package:retreat/services/supabase_manager.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends AuthState<ForgetPasswordPage> {
  final _supabaseClient = SupabaseManager();
  final TextEditingController _emailController = TextEditingController();

  String get email => _emailController.text.trim().toLowerCase();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 24,
              ),
              // email form
              CustomFormField(
                  hintText: 'Your email address',
                  labelText: 'Email',
                  controller: _emailController),
              // password form
              CustomButton(
                text: "Confirm",
                onTap: () async {
                  await _supabaseClient.magicLink(context, email: email);
                },
              ),
            ]),
      ),
    );
  }
}
