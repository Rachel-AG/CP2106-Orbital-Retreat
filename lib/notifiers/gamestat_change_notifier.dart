import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retreat/models/gamestat.dart';
import 'package:retreat/services/gamestat_service.dart';

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

  Future<void> insertGamestat(context) async {
    await _gamestatService.insertGamestat();
    isUpToDate = false;
    getGamestat();
  }

  Future<void> updateGamestat(
      {required String whichStat,
      required int updatedValue}) async {
    await _gamestatService.updateGamestat(
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
