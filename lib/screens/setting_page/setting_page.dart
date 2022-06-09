import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/screens/setting_page/setting_option.dart';
import 'package:retreat/screens/setting_page/setting_title.dart';
import 'package:retreat/services/authentication_service.dart';
import 'package:retreat/widgets/custom_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends AuthRequiredState<SettingPage> {
  final _supabaseClient = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          const SizedBox(
            height: 8,
          ),
          const SettingTitle(text: "Account", icon: Icons.person),
          SettingOption(onTap: () {}, text: "Change Username"),
          SettingOption(onTap: () {}, text: "Change Avatar"),
          SettingOption(
              onTap: () {
                Navigator.pushNamed(context, '/changepassword');
              },
              text: "Change Password"),
          CustomButton(
              text: 'Sign out',
              onTap: () async {
                await _supabaseClient.signOutUser(context);
              }),
        ]),
      ),
    );
  }
}
