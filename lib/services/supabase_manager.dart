import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile.dart';

const String supabaseUrl = 'https://ztjtrovgvzujvwbeipqv.supabase.co';
const String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0anRyb3Zndnp1anZ3YmVpcHF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTI2MjY0NjYsImV4cCI6MTk2ODIwMjQ2Nn0.6pgk8Fm47Sf_7mFb-UouZFqro49gUBLbesw7bQg6Ae4';

class SupabaseManager {
  final client = SupabaseClient(supabaseUrl, token);

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
      Navigator.pushReplacementNamed(context, '/home');
    } else if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }

    _insertProfile(context, username: username);
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

  Future<void> signOut(context) async {
    final result = await client.auth.signOut();
    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sign out successful'),
        duration: Duration(seconds: 2),
      ));
    }
    Navigator.pushReplacementNamed(context, 'signin');
  }

  Future<void> _insertProfile(context, {required String username}) async {
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
    final result = await client.from('profiles').select().execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }

    final dataList = result.data as List;
    return dataList.map((e) => Profile.fromJson(e)).toList().elementAt(0);
  }
}
