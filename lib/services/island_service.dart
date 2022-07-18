import 'dart:convert';
import 'package:retreat/models/island.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO: error handling

/// A class to retrieve and modify data in Island database.
///
/// DO NOT USE DIRECTLY. Use IslandChangeNotifier instead.
class IslandService {
  static final client = Supabase.instance.client;

  Future<bool> createIsland() async {
    final result = await client.from('islands').insert([
      {
        'created_by': client.auth.currentUser?.id,
        'grid_radius': 3,
        'max_height': 10,
        'steepness': 1,
        'seed': "seed",
        'ratio': jsonEncode([0.0, 0.2, 2.0, 0.6, 2.0]),
        'max_animal': 0,
        'animal_list': jsonEncode([]),
        'env_list': jsonEncode([]),
        'day_bool': true,
        'cloud_bool': false,
      }
    ]).execute();

    if (result.error != null) return false;
    return true;
  }

  Future<Island> getIsland() async {
    final result = await client
        .from('islands')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error != null) print('Error retrieving island');

    final dataList = result.data as List;
    if (dataList.isEmpty) {
      await createIsland();
      return getIsland();
    } else {
      return dataList.map((e) => Island.fromJson(e)).toList().elementAt(0);
    }
  }

  Future<bool> updateIsland(Island newIsland) async {
    final result = await client
        .from('islands')
        .update({
          'grid_radius': newIsland.gridRadius,
          'max_height': newIsland.maxHeight,
          'steepness': newIsland.steepness,
          'seed': newIsland.seed,
          'ratio': jsonEncode(newIsland.ratio),
          'max_animal': newIsland.maxAnimal,
          'animal_list': jsonEncode(newIsland.animalList),
          'env_list': jsonEncode(newIsland.envList),
          'day_bool': newIsland.dayBool,
          'cloud_bool': newIsland.cloudBool,
        })
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error != null) return false;
    return true;
  }
}
