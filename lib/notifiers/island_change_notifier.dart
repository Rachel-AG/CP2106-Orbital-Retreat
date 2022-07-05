import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/services/island_service.dart';

class IslandChangeNotifier extends ChangeNotifier {
  Island _island =
      Island('test', 0, 0, 0, 'null', [], 0, [], [], true, true, 'tester_id');
  Island get island {
    isUpToDate ? true : getIsland();
    return _island;
  }

  String _javaScriptString = '';
  String get javaScriptString {
    isUpToDate ? true : getIsland();
    return _javaScriptString;
  }

  bool isUpToDate = false;

  Future<void> getIsland() async {
    _island = await IslandService.getIsland();
    _javaScriptString =
        "init(${_island.gridRadius}, ${_island.maxHeight}, ${_island.steepness}, '${_island.seed}', ${_island.ratio}, ${_island.maxAnimal}, ${_island.animalList}, ${_island.envList}, ${_island.dayBool}, ${_island.cloudBool})";
    isUpToDate = true;
    // notify listeners when most up to date island is retrieved
    notifyListeners();
  }

  Future<void> createIsland() async {
    await IslandService.createIsland();
    isUpToDate = false;
    getIsland();
  }

  Future<void> updateIsland(Island newIsland) async {
    await IslandService.updateIsland(newIsland);
    isUpToDate = false;
    getIsland();
  }

  // USE THIS FUNCTION TO GENERATE RANDOM SEED
  String _generateRandomStr(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
