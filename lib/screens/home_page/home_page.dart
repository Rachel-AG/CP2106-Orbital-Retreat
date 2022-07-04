import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/profile.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
import 'package:retreat/services/profile_service.dart';
import 'package:retreat/widgets/avatar.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  final Completer<WebViewPlusController> _controller =
      Completer<WebViewPlusController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          centerTitle: true,
        ),
        floatingActionButton: recordButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              profileCard(),
              refreshButton(_controller),
              Consumer<IslandChangeNotifier>(
                builder: (context, value, child) =>
                    islandWebView(value, _controller),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavBar());
  }

  FloatingActionButton recordButton() {
    return FloatingActionButton.extended(
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
        });
  }

  BottomAppBar bottomNavBar() {
    return BottomAppBar(
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
    );
  }

  Widget islandWebView(IslandChangeNotifier islandChangeNotifier,
      Completer<WebViewPlusController> _controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      child: WebViewPlus(
        zoomEnabled: false,
        initialUrl: 'assets/www/index.html',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
              name: 'messageHandler',
              onMessageReceived: (JavascriptMessage message) async {
                print("message from webview: ${message.message}");
                await _controller.future.then((controller) async {
                  await controller.webViewController
                      .runJavascriptReturningResult(
                          islandChangeNotifier.javaScriptString);
                });
              })
        },
        onWebViewCreated: (WebViewPlusController controller) async {
          await islandChangeNotifier.getJSScript();
          _controller.complete(controller);
        },
        onPageFinished: (_) async {},
      ),
    );
  }

  IconButton refreshButton(Completer<WebViewPlusController> _controller) {
    return IconButton(
        onPressed: () async {
          await _controller.future
              .then((controller) => controller.webViewController.reload());
        },
        icon: const Icon(Icons.refresh_rounded));
  }

  Card profileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: AppColors.steelteal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    style: TextStyles.profileTextStyle,
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
