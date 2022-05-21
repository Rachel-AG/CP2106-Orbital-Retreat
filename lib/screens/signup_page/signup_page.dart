import 'package:flutter/material.dart';
import 'package:retreat/services/supabase_manager.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _supabaseClient = SupabaseManager();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get email => _emailController.text.trim().toLowerCase();
  String get password => _passwordController.text.trim();
  String get username => _usernameController.text.trim();

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
                  height: 24,
                ),
                // username form
                CustomFormField(
                    hintText: 'Your username',
                    labelText: 'Username',
                    controller: _usernameController),
                // password form
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
                // // re-type password field
                // CustomFormField(
                //     labelText: 'Re-type password',
                //     obscureText: true,
                //     controller: _passwordController),
                // const SizedBox(
                //   height: 24,
                // ),
                CustomButton(
                  text: "Sign Up",
                  onTap: () async {
                    await _supabaseClient.signUpUser(context,
                        email: email, password: password, username: username);
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
