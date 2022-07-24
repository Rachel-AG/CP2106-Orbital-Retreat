import 'dart:math';

import 'package:flutter/material.dart';
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
  Future<bool> updateGamestat({required String whichStat, 
  required int updatedValue}) async {
    bool updateMultiplier;

    if (whichStat == 'streak') {
      updateMultiplier = true;
    } else {
      updateMultiplier = false;
    }

    final result;

    if (updateMultiplier) {
      double updatedMultiplier = calculateMultiplier(updatedValue);
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
    if(! data.isEmpty ) {
    return data.map((e) => Gamestat.fromJson(e)).toList().elementAt(0);
    } else {
      insertGamestat();
      Future<Gamestat> newGamestat = getCurrentGamestat();
      return newGamestat;
    }
  }

  static double calculateMultiplier(int newStreak) {
    int i = 1;
    double result = 1;
    while(i < newStreak) {
      result = result + pow((1 / (1 + i)), 2);
      i++;
    }
    return result;
  }
}
