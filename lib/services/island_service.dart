import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:retreat/models/island.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IslandService {
  // TODO: connect to Database
  static final client = Supabase.instance.client;

  static Future<bool> createIsland(context) async {
    final result = await client.from('islands').insert([
      {
        'created_by': client.auth.currentUser?.id,
        'grid_radius': 3,
        'max_height': 10,
        'steepness': 1,
        'seed': _generateRandomStr(10),
        'ratio': jsonEncode([0.0, 0.2, 2.0, 0.6, 2.0]),
        'max_animal': 0,
        'animal_list': jsonEncode([]),
        'env_list': jsonEncode([]),
        'day_bool': true,
        'cloud_bool': false,
      }
    ]).execute();

    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  static Future<Island> getIsland() async {
    final result = await client
        .from('islands')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    final dataList = result.data as List;
    print("Data from Supabase: $dataList");
    return dataList.map((e) => Island.fromJson(e)).toList().elementAt(0);
  }

  static String _generateRandomStr(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
