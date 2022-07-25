import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/notifiers/current_profile_change_notifier.dart';
import 'package:retreat/notifiers/gamestat_change_notifier.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
import 'package:retreat/widgets/avatar.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.genIsland}) : super(key: key);

  final bool genIsland;

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
          title: const Text('Home'),
          centerTitle: true,
        ),
        floatingActionButton: recordButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<CurrentProfileChangeNotifier>(
                builder: (context, value, child) =>
                    Expanded(flex: 3, child: profileCard(value)),
              ),
              Expanded(
                flex: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      refreshButton(_controller),
                      Row(
                        children: [
                          Consumer<GamestatChangeNotifier>(
                              builder: (context, value, child) =>
                                  coinsDisplay(value)),
                          const SizedBox(
                            width: 16.0,
                          ),
                          shopButton(),
                        ],
                      ),
                    ]),
              ),
              Consumer<IslandChangeNotifier>(builder: (context, value, child) {
                return Expanded(
                    flex: 10,
                    child: widget.genIsland
                        ? islandWebView(value, _controller)
                        : const SizedBox());
              }),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavBar());
  }

  FloatingActionButton recordButton() {
    return FloatingActionButton.extended(
        key: const ValueKey('add-transaction'),
        backgroundColor: AppColors.custom.shade400,
        elevation: 4.0,
        icon: const Icon(
          Icons.add,
        ),
        label: Text(
          'Record Transaction',
          style: TextStyles.buttonTextStyle,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/home/record');
        });
  }

  BottomAppBar bottomNavBar() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              key: const ValueKey('transaction-list'),
              onPressed: () {
                Navigator.pushNamed(context, '/home/transactionlist');
              },
              icon: const Icon(
                Icons.analytics_rounded,
              )),
          IconButton(
            key: const ValueKey('settings'),
            onPressed: () {
              Navigator.pushNamed(context, '/home/settings');
            },
            icon: const Icon(
              Icons.more_horiz,
            ),
          )
        ],
      ),
    );
  }

  Widget islandWebView(IslandChangeNotifier islandChangeNotifier,
      Completer<WebViewPlusController> _controller) {
    return WebViewPlus(
      zoomEnabled: false,
      initialUrl: 'assets/www/index.html',
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
            name: 'messageHandler',
            onMessageReceived: (JavascriptMessage message) async {
              print("message from webview: ${message.message}");
              await islandChangeNotifier.getIsland();
              print(islandChangeNotifier.javaScriptString);
              await _controller.future.then((controller) async {
                await controller.webViewController.runJavascriptReturningResult(
                    islandChangeNotifier.javaScriptString);
              });
            })
      },
      onWebViewCreated: (WebViewPlusController controller) async {
        _controller.complete(controller);
      },
      onPageFinished: (_) async {},
    );
  }

  IconButton refreshButton(Completer<WebViewPlusController> controller) {
    return IconButton(
        onPressed: () async {
          await _refreshWebview(controller);
        },
        icon: const Icon(Icons.refresh_rounded));
  }

  Card profileCard(CurrentProfileChangeNotifier currProfChangeNotifier) {
    final username = currProfChangeNotifier.profile.username;
    final url = currProfChangeNotifier.profile.avatarUrl;
    return Card(
      key: const ValueKey('profile-card'),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              url != null
                  ? Avatar(
                      imageUrl: url,
                      size: 60,
                    )
                  : const Avatar(),
              const SizedBox(
                width: 16.0,
              ),
              Text(
                username,
                style: TextStyles.profileTextStyle,
              ),
            ],
          )),
    );
  }

  Widget coinsDisplay(GamestatChangeNotifier gamestatChangeNotifier) {
    return Row(
      key: const ValueKey('amount-of-coin'),
      children: [
        const Icon(
          Icons.currency_exchange,
          color: Colors.amber,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          "${gamestatChangeNotifier.gamestat.gold}",
          style: TextStyles.coinsDisplay,
        ),
      ],
    );
  }

  ElevatedButton shopButton() {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
        ),
        key: const ValueKey('shop-button'),
        child: Row(children: const [
          Icon(
            Icons.store,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text("Shop")
        ]),
        onPressed: () async {
          Navigator.pushNamed(context, '/shop');
        });
  }

  Future<void> _refreshWebview(
      Completer<WebViewPlusController> controller) async {
    await controller.future
        .then((controller) => controller.webViewController.reload());
  }
}
