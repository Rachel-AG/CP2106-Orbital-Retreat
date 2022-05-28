import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:retreat/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart' as supabase;

class AuthenticationService {
  final client = Supabase.instance.client;

  Future<void> signUpUser(context,
      {required String email,
      required String password,
      required String username}) async {
    final result = await client.auth.signUp(email, password);

    if (result.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration successful'),
        duration: Duration(seconds: 2),
      ));
    } else if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    await ProfileService().insertProfile(context, username: username);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> signInUser(context,
      {required String email, required String password}) async {
    final result = await client.auth.signIn(email: email, password: password);

    if (result.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sign in successful'),
        duration: Duration(seconds: 2),
      ));
      Navigator.pushReplacementNamed(context, '/home');
    } else if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<void> signOutUser(context) async {
    final result = await client.auth.signOut();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<void> magicLink(context, {required String email}) async {
    final result = await client.auth.signIn(
        email: email,
        options: supabase.AuthOptions(
            redirectTo:
                kIsWeb ? null : 'io.supabase.retreat://login-callback/'));

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sent login link to email'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> changePassword(context, {required String password}) async {
    final result = await client.auth.update(UserAttributes(password: password));
    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully changed password'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
