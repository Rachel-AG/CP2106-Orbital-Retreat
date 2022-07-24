import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retreat/models/gamestat.dart';
import 'package:retreat/services/gamestat_service.dart';

class GamestatChangeNotifier extends ChangeNotifier {
  Gamestat _gamestat = Gamestat('null', 'null', 1, 0, 1, 0);
  Gamestat get gamestat {
    isUpToDate ? true : getGamestat();
    return _gamestat;
  }

  bool isUpToDate = false;

  Future<void> getGamestat() async {
    _gamestat = await GamestatService.getCurrentGamestat();
    isUpToDate = true;
    notifyListeners();
  }

  Future<void> insertGamestat(context) async {
    await GamestatService.insertGamestat();
    isUpToDate = false;
    getGamestat();
  }

  Future<void> updateGamestat(
      {required String whichStat,
      required int updatedValue}) async {
    await GamestatService.updateGamestat(
      whichStat: whichStat, 
      updatedValue: updatedValue
    );
    isUpToDate = false;
    getGamestat();
  }

  void reset() {
    _gamestat = Gamestat('null', 'null', 1, 0, 1, 0);
    isUpToDate = false;
  }
}
