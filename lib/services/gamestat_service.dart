import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/gamestat.dart';

class GamestatService {
  static final client = Supabase.instance.client;

  ///Initialise gamestat to the database
  Future<bool> insertGamestat() async {
    final result = await client.from('gamestats').insert([
      {
        'created_by': client.auth.currentUser?.id,
        'island_level': 1,
        'gold': 0,
        'multiplier': 1,
        'streak': 0,
      }
    ]).execute();

    if (result.error?.message != null) return false;
    return true;
  }

  // whichStat can be either gold, island_level, or streak
  Future<bool> updateGamestat(Gamestat newGamestat) async {
    final result = await client
        .from('gamestats')
        .update({
          'island_level': newGamestat.level,
          'gold': newGamestat.gold,
          'multiplier': newGamestat.multiplier,
          'streak': newGamestat.streak,
        })
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error != null) return false;

    return true;
  }

  /// Retrieves user's gamestat
  Future<Gamestat> getCurrentGamestat() async {
    final result = await client
        .from('gamestats')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    final data = result.data;
    if (!data.isEmpty) {
      return data.map((e) => Gamestat.fromJson(e)).toList().elementAt(0);
    } else {
      insertGamestat();
      Future<Gamestat> newGamestat = getCurrentGamestat();
      return newGamestat;
    }
  }
}
