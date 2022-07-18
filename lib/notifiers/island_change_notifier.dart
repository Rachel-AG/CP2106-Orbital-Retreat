import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/services/island_service.dart';

class IslandChangeNotifier extends ChangeNotifier {
  final IslandService _islandService;
  IslandChangeNotifier(this._islandService);

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
    _island = await _islandService.getIsland();
    _javaScriptString =
        "init(${_island.gridRadius}, ${_island.maxHeight}, ${_island.steepness}, '${_island.seed}', ${_island.ratio}, ${_island.maxAnimal}, ${_island.animalList}, ${_island.envList}, ${_island.dayBool}, ${_island.cloudBool})";
    isUpToDate = true;
    // notify listeners when most up to date island is retrieved
    notifyListeners();
  }

  Future<void> createIsland() async {
    await _islandService.createIsland();
    isUpToDate = false;
    getIsland();
  }

  Future<void> updateIsland({
    int? gridRadius,
    int? maxHeight,
    int? steepness,
    String? seed,
    List? ratio,
    int? maxAnimal,
    List? animalList,
    List? envList,
    bool? dayBool,
    bool? cloudBool,
  }) async {
    final newIsland = Island(
        island.id,
        gridRadius ?? island.gridRadius,
        maxHeight ?? island.gridRadius,
        steepness ?? island.steepness,
        seed ?? island.seed,
        ratio ?? island.ratio,
        maxAnimal ?? island.maxAnimal,
        animalList ?? island.animalList,
        envList ?? island.envList,
        dayBool ?? island.dayBool,
        cloudBool ?? island.cloudBool,
        island.createdBy);
    await _islandService.updateIsland(newIsland);
    isUpToDate = false;
    getIsland();
  }

  // USE THIS FUNCTION TO GENERATE RANDOM SEED
  String generateRandomStr(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  void reset() {
    _island =
        Island('test', 0, 0, 0, 'null', [], 0, [], [], true, true, 'tester_id');
    _javaScriptString = '';
    isUpToDate = false;
  }
}
