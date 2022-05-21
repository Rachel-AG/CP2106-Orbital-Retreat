import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/services/supabase_manager.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _supabaseClient = SupabaseManager();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get email => _emailController.text.trim().toLowerCase();
  String get password => _passwordController.text.trim();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              const SizedBox(
                height: 24,
              ),
              PasswordField(
                  helperText: 'No more than 25 characters',
                  labelText: 'Password',
                  controller: _passwordController),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                text: "Sign In",
                onTap: () async {
                  await _supabaseClient.signInUser(context,
                      email: email, password: password);
                },
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account? Sign Up",
                  style: const TextStyle(color: AppColors.darkblue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                )
              ]))
            ]),
      ),
    );
  }
}
