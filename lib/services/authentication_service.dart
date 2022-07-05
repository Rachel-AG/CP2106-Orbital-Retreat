import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart' as supabase;

class AuthenticationService {
  final client = Supabase.instance.client;

  Future<bool> signUpUser(context,
      {required String email, required String password}) async {
    final result1 = await client.auth.signUp(email, password);

    // check if email is registered successfully
    if (result1.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result1.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  Future<bool> signInUser(context,
      {required String email, required String password}) async {
    final result = await client.auth.signIn(email: email, password: password);

    // check if user has logged in successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  Future<bool> signOutUser(context) async {
    final result = await client.auth.signOut();

    // check if user has logged out successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  Future<bool> magicLink(context, {required String email}) async {
    final result = await client.auth.signIn(
        email: email,
        options: supabase.AuthOptions(
            redirectTo:
                kIsWeb ? null : 'io.supabase.retreat://login-callback/'));

    // check if login link is sent successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  Future<bool> changePassword(context, {required String password}) async {
    final result = await client.auth.update(UserAttributes(password: password));

    // check if pasword is changed successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }
}
