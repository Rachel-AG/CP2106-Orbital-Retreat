import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          const SizedBox(
            height: 8.0,
          ),
          settingTitle(
              "Account",
              const Icon(
                Icons.person,
                color: AppColors.darkblue,
              )),
          settingOption("Update Profile", () {
            Navigator.pushNamed(context, '/home/settings/updateprofile');
          }),
          settingOption("Change Password", () {
            Navigator.pushNamed(context, '/home/settings/changepassword');
          }),
          const SizedBox(
            height: 12.0,
          ),
          settingTitle(
              "Others",
              const Icon(
                Icons.article_rounded,
                color: AppColors.darkblue,
              )),
          CustomButton(
              text: 'Sign out',
              onTap: () async {
                await _supabaseClient.signOutUser(context);
              }),
        ]),
      ),
    );
  }

  Widget settingTitle(String text, Icon icon) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyles.optionCategoryStyle,
            )
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
        ),
      ],
    );
  }

  Widget settingOption(String text, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyles.optionTextStyle,
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}