import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/models/auth_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/services/authentication_service.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';

/// this class represents Sign In page
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  "Log In",
                  style: TextStyles.title,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFormField(
                    key: const ValueKey('email-field'),
                    hintText: 'Your email address',
                    labelText: 'Email',
                    controller: _emailController),
                // password form
                const SizedBox(
                  height: 24,
                ),
                PasswordField(
                    key: const ValueKey('password-field'),
                    helperText: 'No more than 25 characters',
                    labelText: 'Password',
                    controller: _passwordController),
                CustomButton(
                  key: const ValueKey('sign-in-button'),
                  text: "Sign In",
                  onTap: () async {
                    await _supabaseClient
                        .signInUser(context, email: email, password: password)
                        .then((value) => value
                            ? Navigator.pushReplacementNamed(context, '/')
                            : null);
                  },
                ),
                TextButton(
                  key: const ValueKey('sign-up-link'),
                  onPressed: () {
                    stopAuthObserver();
                    Navigator.pushNamed(context, '/signup')
                        .then((_) => startAuthObserver());
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text("Don't have an account? Sign Up"),
                ),
                TextButton(
                  key: const ValueKey('forget-password-link'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgetpassword');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text("Forget password?"),
                ),
              ]),
        ),
      ),
    );
  }
}
