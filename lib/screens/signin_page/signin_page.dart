import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retreat/screens/signup_page/signup_page.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';
import '../home_page/homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get email => _emailController.text.trim().toLowerCase();
  String get password => _passwordController.text.trim();

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
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomePage(title: 'Welcome to Retreat!')));
                },
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Don't have an account? Sign Up",
                  style: const TextStyle(color: Colors.black),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                )
              ]))
            ]),
      ),
    );
  }
}
