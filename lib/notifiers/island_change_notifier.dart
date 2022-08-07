import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/services/island_service.dart';

/// this class manages the state of island for the currently authenticated user
class IslandChangeNotifier extends ChangeNotifier {
  final IslandService _islandService;
  IslandChangeNotifier(this._islandService);

  Island _island = const Island(
      'test', 0, 0, 0, 'null', [], 0, [], [], true, true, 'tester_id');
  Island get island {
    isUpToDate ? true : getIsland();
    return _island;
  }

  /// javaScriptString represent javaScript command to render the 3D island in the webview
  String _javaScriptString = '';
  String get javaScriptString {
    isUpToDate ? true : getIsland();
    return _javaScriptString;
  }

  bool isUpToDate = false;

  Future<void> getIsland() async {
    _island = await _islandService.getIsland();
    isUpToDate = true;
    var animalStrList = island.animalList.map((e) => "'" + e + "'").toList();
    var envStrList = island.envList.map((e) => "'" + e + "'").toList();
    _javaScriptString =
        "init(${island.gridRadius}, ${island.maxHeight}, ${island.steepness}, '${island.seed}', ${island.ratio}, ${island.maxAnimal}, $animalStrList, $envStrList, ${island.dayBool}, ${island.cloudBool})";
    // notify listeners when most up to date island is retrieved
    notifyListeners();
  }

  Future<void> createIsland() async {
    isUpToDate = false;
    await _islandService.createIsland();
    await getIsland();
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
    isUpToDate = false;
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
    await getIsland();
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
    _island = const Island(
        'test', 0, 0, 0, 'null', [], 0, [], [], true, true, 'tester_id');
    _javaScriptString = '';
    isUpToDate = false;
  }
}
