import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_state.dart';
import 'package:retreat/services/authentication_service.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends AuthState<SignInPage> {
  final _supabaseClient = AuthenticationService();
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
              CustomButton(
                text: "Sign In",
                onTap: () async {
                  await _supabaseClient
                      .signInUser(context, email: email, password: password)
                      .then((value) => value
                          ? Navigator.pushReplacementNamed(context, '/')
                          : null);
                },
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account? Sign Up",
                  style: const TextStyle(color: AppColors.darkblue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      stopAuthObserver();
                      Navigator.pushNamed(context, '/signup')
                          .then((_) => startAuthObserver());
                    },
                )
              ])),
              const SizedBox(
                height: 16,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Forget password?",
                  style: const TextStyle(color: AppColors.darkblue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, '/forgetpassword');
                    },
                )
              ]))
            ]),
      ),
    );
  }
}
