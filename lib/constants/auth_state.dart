import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signin', (route) => false);
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/changepassword', (route) => false);
  }

  @override
  void onErrorAuthenticating(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error: $message'),
      duration: const Duration(seconds: 2),
    ));
  }
}
