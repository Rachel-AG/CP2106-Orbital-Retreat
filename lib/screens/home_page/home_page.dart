import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/profile_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  final _profileClient = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.steelteal,
          elevation: 4.0,
          icon: const Icon(
            Icons.add,
            color: AppColors.whiteshade,
          ),
          label: const Text(
            'Record Transaction',
            style: TextStyles.buttonTextStyle,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/record');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: AppColors.darkblue,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transactionlist');
                  },
                  icon: const Icon(
                    Icons.analytics_rounded,
                    color: AppColors.whiteshade,
                  )),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home/settings');
                },
                icon: const Icon(Icons.more_horiz),
                color: AppColors.whiteshade,
              )
            ],
          ),
        ));
  }
}
