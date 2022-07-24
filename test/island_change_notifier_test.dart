import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
import 'package:retreat/services/island_service.dart';

class MockIslandService extends Mock implements IslandService {}

void main() {
  late IslandChangeNotifier sut;
  late MockIslandService mockIslandService;
  late Island islandFromService;

  setUp(() {
    mockIslandService = MockIslandService();
    sut = IslandChangeNotifier(mockIslandService);

    islandFromService = const Island(
        'test', 0, 0, 0, 'null', [], 0, [], [], true, true, 'tester_id');
  });

  void arrangeIslandServiceReturnIsland() {
    when(
      () => mockIslandService.getIsland(),
    ).thenAnswer((_) async => islandFromService);
  }

  void arrangeIslandServiceInsertIsland() {
    when(
      () => mockIslandService.createIsland(),
    ).thenAnswer((_) async {
      islandFromService = const Island('1', 5, 10, 1, 'null',
          [0.0, 0.2, 2.0, 0.6, 2.0], 5, [], [], true, true, 'user1');
      return true;
    });
  }

  void arrangeIslandServiceUpdateIsland(
      {required Island prevIsland,
      required int gridRadius,
      required String seed}) {
    when(
      () => mockIslandService.updateIsland(Island(
          prevIsland.id,
          10,
          prevIsland.maxHeight,
          prevIsland.steepness,
          'testingtesting',
          prevIsland.ratio,
          prevIsland.maxAnimal,
          prevIsland.animalList,
          prevIsland.envList,
          prevIsland.dayBool,
          prevIsland.cloudBool,
          prevIsland.createdBy)),
    ).thenAnswer((_) async {
      islandFromService = Island(
          prevIsland.id,
          10,
          prevIsland.maxHeight,
          prevIsland.steepness,
          'testingtesting',
          prevIsland.ratio,
          prevIsland.maxAnimal,
          prevIsland.animalList,
          prevIsland.envList,
          prevIsland.dayBool,
          prevIsland.cloudBool,
          prevIsland.createdBy);
      return true;
    });
  }

  test('Correct initial values', () {
    expect(sut.isUpToDate, false);
  });

  group('getIsland', () {
    test('get island using the IslandService', () async {
      arrangeIslandServiceReturnIsland();
      await sut.getIsland();
      verify(
        () => mockIslandService.getIsland(),
      ).called(1);
    });

    test('isUpToDate changes when getIsland is called', () async {
      arrangeIslandServiceReturnIsland();
      expect(sut.isUpToDate, false);
      await sut.getIsland();
      expect(sut.isUpToDate, true);
    });

    test('correct island list is returned', () async {
      arrangeIslandServiceReturnIsland();
      await sut.getIsland();
      expect(sut.island, islandFromService);
    });
  });

  group('createIsland', () {
    test('create island using IslandService', () async {
      arrangeIslandServiceInsertIsland();
      arrangeIslandServiceReturnIsland();
      await sut.createIsland();
      verify(() => mockIslandService.createIsland()).called(1);
    });

    test('isUpToDate changes when createIsland is called', () async {
      arrangeIslandServiceInsertIsland();
      arrangeIslandServiceReturnIsland();
      Future future = sut.createIsland();
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct island is returned', () async {
      arrangeIslandServiceInsertIsland();
      arrangeIslandServiceReturnIsland();
      await sut.createIsland();
      expect(sut.island, islandFromService);
      expect(sut.javaScriptString,
          "init(5, 10, 1, 'null', [0.0, 0.2, 2.0, 0.6, 2.0], 5, [], [], true, true)");
    });
  });

  group('updateIsland', () {
    test('update island using IslandService', () async {
      arrangeIslandServiceReturnIsland();
      arrangeIslandServiceUpdateIsland(
          prevIsland: islandFromService,
          gridRadius: 10,
          seed: 'testingtesting');
      await sut.updateIsland(gridRadius: 10, seed: 'testingtesting');
      verify(
        () => mockIslandService.updateIsland(Island(
            islandFromService.id,
            10,
            islandFromService.maxHeight,
            islandFromService.steepness,
            'testingtesting',
            islandFromService.ratio,
            islandFromService.maxAnimal,
            islandFromService.animalList,
            islandFromService.envList,
            islandFromService.dayBool,
            islandFromService.cloudBool,
            islandFromService.createdBy)),
      ).called(1);
    });

    test('isUpToDate changes when updateIsland is called', () async {
      arrangeIslandServiceReturnIsland();
      arrangeIslandServiceUpdateIsland(
          prevIsland: islandFromService,
          gridRadius: 10,
          seed: 'testingtesting');
      Future future = sut.updateIsland(gridRadius: 10, seed: 'testingtesting');
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct island is returned', () async {
      arrangeIslandServiceReturnIsland();
      arrangeIslandServiceUpdateIsland(
          prevIsland: islandFromService,
          gridRadius: 10,
          seed: 'testingtesting');
      await sut.updateIsland(gridRadius: 10, seed: 'testingtesting');
      expect(sut.island, islandFromService);
      expect(sut.javaScriptString,
          "init(10, 0, 0, 'testingtesting', [], 0, [], [], true, true)");
    });
  });
}
