import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/profile_service.dart';

import 'package:retreat/services/authentication_service.dart';
import 'package:retreat/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  final _profileClient = ProfileService();
  final _supabaseClient = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Retreat'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Button',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          FutureBuilder<Profile>(
            future: _profileClient.getProfile(context),
            builder: (context, AsyncSnapshot<Profile> snapshot) {
              return Card(
                color: AppColors.steelteal,
                margin: const EdgeInsets.all(24),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello, ${snapshot.data?.username}!',
                        style: TextStyles.headerTextStyle,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          CustomButton(
              text: 'Change Password',
              onTap: () {
                Navigator.pushNamed(context, '/changepassword');
              }),
          CustomButton(
              text: 'Sign out',
              onTap: () async {
                await _supabaseClient.signOutUser(context);
              }),
        ],
      ),
    );
  }
}
