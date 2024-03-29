import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/auth_state.dart';
import 'package:retreat/notifiers/current_profile_change_notifier.dart';
import 'package:retreat/services/authentication_service.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends AuthState<SignUpPage> {
  final _supabaseClient = AuthenticationService();
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
                    key: const ValueKey('username-field'),
                    hintText: 'Your username',
                    labelText: 'Username',
                    controller: _usernameController),
                // password form
                const SizedBox(
                  height: 24,
                ),
                // email form
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
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                  key: const ValueKey('sign-up-button'),
                  text: "Sign Up",
                  onTap: () async {
                    await _supabaseClient
                        .signUpUser(context, email: email, password: password)
                        .then((value) {
                      if (value) {
                        Provider.of<CurrentProfileChangeNotifier>(context,
                                listen: false)
                            .createProfile(username);
                        Navigator.pushNamed(context, '/');
                      }
                    });
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
