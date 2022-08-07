import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retreat/models/gamestat.dart';
import 'package:retreat/services/gamestat_service.dart';

/// this class manages the state of gamestat for the currently authenticated user
class GamestatChangeNotifier extends ChangeNotifier {
  final GamestatService _gamestatService;
  GamestatChangeNotifier(this._gamestatService);

  Gamestat _gamestat = Gamestat('null', 'null', 1, 0, 1, 0);
  Gamestat get gamestat {
    isUpToDate ? true : getGamestat();
    return _gamestat;
  }

  bool isUpToDate = false;

  Future<void> getGamestat() async {
    _gamestat = await _gamestatService.getCurrentGamestat();
    isUpToDate = true;
    notifyListeners();
  }

  // Future<void> insertGamestat(context) async {
  //   isUpToDate = false;
  //   await _gamestatService.insertGamestat();
  //   await getGamestat();
  // }

  Future<void> updateGamestat({int? level, int? gold, int? streak}) async {
    isUpToDate = false;
    final newMultiplier = streak == null ? null : _calculateMultiplier(streak);
    final newGameStat = Gamestat(
        gamestat.id,
        gamestat.createdBy,
        level ?? gamestat.level,
        gold ?? gamestat.gold,
        newMultiplier ?? gamestat.multiplier,
        streak ?? gamestat.streak);
    await _gamestatService.updateGamestat(newGameStat);
    await getGamestat();
  }

  void reset() {
    _gamestat = Gamestat('null', 'null', 1, 0, 1, 0);
    isUpToDate = false;
  }

  static double _calculateMultiplier(int newStreak) {
    int i = 1;
    double result = 1;
    while (i < newStreak) {
      result = result + pow((1 / (1 + i)), 2);
      i++;
    }
    return result;
  }
}
