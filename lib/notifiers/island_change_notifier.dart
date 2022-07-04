import 'package:flutter/cupertino.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/services/island_service.dart';

class IslandChangeNotifier extends ChangeNotifier {
  Island _island = Island(0, 0, 0, 'null', [], 0, [], [], true, true);
  Island get island {
    isUpToDate ? true : getIsland();
    return _island;
  }

  String _javaScriptString = '';
  String get javaScriptString => _javaScriptString;

  bool isUpToDate = false;

  Future<void> getIsland() async {
    _island = await IslandService.getIsland();
    isUpToDate = true;
  }

  Future<void> getJSScript() async {
    await getIsland();
    _javaScriptString =
        "init(${_island.gridRadius}, ${_island.maxHeight}, ${_island.steepness}, '${_island.seed}', ${_island.ratios}, ${_island.maxAnimal}, ${_island.animalList}, ${_island.envList}, ${_island.dayBool}, ${_island.cloudBool})";
    notifyListeners();
  }
}
