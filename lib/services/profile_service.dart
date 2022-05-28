import 'package:flutter/material.dart';
import 'package:retreat/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final client = Supabase.instance.client;

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
    final result = await client
        .from('profiles')
        .select()
        .eq('id', client.auth.currentUser?.id)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    if (dataList.isEmpty) {
      return Profile('000', '000', '000', '000');
    }

    return dataList.map((e) => Profile.fromJson(e)).toList().elementAt(0);
  }
}
