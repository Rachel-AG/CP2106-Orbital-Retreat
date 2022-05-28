import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart' as supabase;

import '../models/profile.dart';

class SupabaseManager {
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
    insertProfile(context, username: username);
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
    Navigator.pushReplacementNamed(context, '/signin');
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

  Future<void> insertProfile(context, {required String username}) async {
    // if no user is logged in, will an error be thrown?
    final result = await client.from('profiles').insert([
      {'id': client.auth.user()?.id, 'username': username}
    ]).execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<Profile> getProfile(context) async {
    print('current user: ${client.auth.currentUser?.id}');

    final result = await client
        .from('profiles')
        .select()
        .eq('id', client.auth.currentUser?.id)
        .execute();

    print('Data: ${result.data.toString()}');

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    print('Data: ${result.data.toString()}');

    return dataList.map((e) => Profile.fromJson(e)).toList().elementAt(0);
  }
}
