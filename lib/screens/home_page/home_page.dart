import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/services/profile_service.dart';
import 'package:retreat/widgets/avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
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
            Navigator.pushNamed(context, '/home/record');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Container(
          padding: const EdgeInsets.all(24.0),
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: AppColors.steelteal,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FutureBuilder<Profile>(
                future: ProfileService.getCurrentUserProfile(context),
                builder: (context, AsyncSnapshot<Profile> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (snapshot.data?.avatarUrl != null)
                          Avatar(
                            imageUrl: snapshot.data!.avatarUrl!,
                          )
                        else
                          const Avatar(),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          'Hello, ${snapshot.data?.username}!',
                          style: TextStyles.headerTextStyle,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: AppColors.darkblue,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home/transactionlist');
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
