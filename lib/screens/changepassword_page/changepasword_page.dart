import 'package:flutter/material.dart';
import 'package:retreat/models/auth_required_state.dart';
import 'package:retreat/services/authentication_service.dart';
import 'package:retreat/widgets/custom_button.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/widgets/password_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends AuthRequiredState<ChangePasswordPage> {
  final _supabaseClient = AuthenticationService();
  final TextEditingController _passwordCopyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get passwordCopy => _passwordCopyController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  void dispose() {
    _passwordCopyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool validatePassword() {
    return password == passwordCopy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 24,
              ),
              // email form

              PasswordField(
                  helperText: 'No more than 25 characters',
                  labelText: 'New Password',
                  controller: _passwordController),
              CustomFormField(
                labelText: 'Re-type Your Password',
                controller: _passwordCopyController,
                obscureText: true,
              ),
              CustomButton(
                text: "Confirm",
                onTap: () async {
                  if (validatePassword()) {
                    await _supabaseClient
                        .changePassword(context, password: password)
                        .then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Successfully changed password'),
                          duration: Duration(seconds: 2),
                        ));
                        Navigator.pop(context);
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Password does not match'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
              ),
            ]),
      ),
    );
  }
}
