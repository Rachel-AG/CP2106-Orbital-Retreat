import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/gamestat.dart';

class GamestatService {
  final client = Supabase.instance.client;

  ///Initialise gamestat to the database
  Future<void> insertGamestat(context, {required String username}) async {
    final result = await client.from('gamestats').insert([
      {
        'created_by': username,
        'island_level': 1,
        'gold': 0,
        'multiplier': 1,
        'streak': 0,
      }
    ]).execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  //whichStat can be either gold, island_level, or streak
  Future<bool> updateGamestat(context,
      {required String whichStat, required int updatedValue}) async {
    bool updateMultiplier;

    if (whichStat == 'streak') {
      updateMultiplier = true;
    } else {
      updateMultiplier = false;
    }

    final result;

    if (updateMultiplier) {
      double updatedMultiplier = 1/(1 + updatedValue); //check formula!
      result = await client
          .from('gamestats')
          .update({
            whichStat: updatedValue,
            'multiplier': updatedMultiplier,
          })
          .eq('created_by', client.auth.currentUser?.id)
          .execute();
    } else {
      result = await client
          .from('gamestats')
          .update({
            whichStat: updatedValue,
          })
          .eq('created_by', client.auth.currentUser?.id)
          .execute();
    }

    // check if gamestat is updated successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  /// Retrieves user's gamestat
  Future<Gamestat> getGamestat(context) async {
    final result = await client
        .from('gamestats')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final data = result.data;

    return data.map((e) => Gamestat.fromJson(e));
  }
}
