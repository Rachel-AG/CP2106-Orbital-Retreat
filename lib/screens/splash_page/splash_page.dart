import 'package:flutter/material.dart';
import 'package:retreat/models/auth_state.dart';

/// this class represents Splash page, which decides whether a user would be brought to the Sign In
/// page or the Home page depending on whether there is an active session when user opens the app
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends AuthState<SplashPage> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
