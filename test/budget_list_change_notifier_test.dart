import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retreat/models/budget.dart';
import 'package:retreat/notifiers/budget_list_change_notifier.dart';
import 'package:retreat/services/budget_service.dart';

class MockBudgetService extends Mock implements BudgetService {}

void main() {
  late BudgetListChangeNotifier sut;
  late MockBudgetService mockBudgetService;
  late List<Budget> budgetsFromService;

  setUp(() {
    mockBudgetService = MockBudgetService();
    sut = BudgetListChangeNotifier(mockBudgetService);

    budgetsFromService = [
      const Budget('1', '2022-03-17 19:43:40.40', 'user2', 100.0, 1, 2020),
      const Budget('2', '2022-04-17 19:43:40.40', 'user2', 200.0, 2, 2021),
      const Budget('3', '2022-06-17 19:43:40.40', 'user2', 300.0, 3, 2022),
    ];
  });

  void arrangeBudgetServiceReturnBudgets() {
    when(
      () => mockBudgetService.getAllBudget(),
    ).thenAnswer((_) async => budgetsFromService);
  }

  void arrangeBudgetServiceInsertBudget(
      {required double amount, required int month, required int year}) {
    when(
      () => mockBudgetService.insertBudget(
          amount: amount, month: month, year: year),
    ).thenAnswer((_) async {
      Budget newBudget = Budget(
          '4', DateTime.now().toIso8601String(), 'user2', amount, month, year);
      budgetsFromService.add(newBudget);
      return true;
    });
  }

  void arrangeBudgetServiceUpdateBudget() {
    when(
      () => mockBudgetService.updateBudget(
          id: '1', amount: 1000.0, month: 12, year: 2022),
    ).thenAnswer((_) async {
      budgetsFromService =
          budgetsFromService.where((element) => element.id != '1').toList();
      budgetsFromService.add(Budget(
          '1', DateTime.now().toIso8601String(), 'user1', 1000.0, 12, 2022));
      return true;
    });
  }

  void arrangeBudgetServiceDeleteBudget() {
    when(
      () => mockBudgetService.deleteBudget(id: '1'),
    ).thenAnswer((_) async {
      budgetsFromService =
          budgetsFromService.where((element) => element.id != '1').toList();
      return true;
    });
  }

  test('Correct initial values', () {
    expect(sut.isUpToDate, false);
  });

  group('getAllBudget', () {
    test('get budgets using the BudgetService', () async {
      arrangeBudgetServiceReturnBudgets();
      await sut.getAllBudget();
      verify(
        () => mockBudgetService.getAllBudget(),
      ).called(1);
    });

    test('isUpToDate changes when getAllBudget is called', () async {
      arrangeBudgetServiceReturnBudgets();
      expect(sut.isUpToDate, false);
      await sut.getAllBudget();
      expect(sut.isUpToDate, true);
    });

    test('correct budget list is returned', () async {
      arrangeBudgetServiceReturnBudgets();
      await sut.getAllBudget();
      expect(sut.budgetList, budgetsFromService);
    });
  });

  group('insertBudget', () {
    test('insert budget using BudgetService', () async {
      arrangeBudgetServiceInsertBudget(amount: 400, month: 4, year: 2022);
      arrangeBudgetServiceReturnBudgets();
      await sut.insertBudget(amount: 400.0, month: 4, year: 2022);
      verify(
        () =>
            mockBudgetService.insertBudget(amount: 400.0, month: 4, year: 2022),
      ).called(1);
    });

    test('isUpToDate changes when insertBudget is called', () async {
      arrangeBudgetServiceInsertBudget(amount: 400, month: 4, year: 2022);
      arrangeBudgetServiceReturnBudgets();
      Future future = sut.insertBudget(amount: 400.0, month: 4, year: 2022);
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });
    test('correct budget list is returned', () async {
      arrangeBudgetServiceInsertBudget(amount: 400, month: 4, year: 2022);
      arrangeBudgetServiceReturnBudgets();
      await sut.insertBudget(amount: 400.0, month: 4, year: 2022);
      expect(sut.budgetList, budgetsFromService);
    });
  });

  group('updateBudget', () {
    test('update budget using BudgetService', () async {
      arrangeBudgetServiceReturnBudgets();
      arrangeBudgetServiceUpdateBudget();
      await sut.updateBudget(id: '1', amount: 1000.0, month: 12, year: 2022);
      verify(
        () => mockBudgetService.updateBudget(
            id: '1', amount: 1000.0, month: 12, year: 2022),
      ).called(1);
    });

    test('isUpToDate changes when updateBudget is called', () async {
      arrangeBudgetServiceReturnBudgets();
      arrangeBudgetServiceUpdateBudget();
      Future future =
          sut.updateBudget(id: '1', amount: 1000.0, month: 12, year: 2022);
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct budget list is returned', () async {
      arrangeBudgetServiceReturnBudgets();
      arrangeBudgetServiceUpdateBudget();
      await sut.updateBudget(id: '1', amount: 1000.0, month: 12, year: 2022);
      expect(sut.budgetList, budgetsFromService);
    });
  });

  group('deleteBudget', () {
    test('delete budget using BudgetService', () async {
      arrangeBudgetServiceReturnBudgets();
      arrangeBudgetServiceDeleteBudget();
      await sut.deleteBudget(id: '1');
      verify(
        () => mockBudgetService.deleteBudget(id: '1'),
      ).called(1);
    });

    test('isUpToDate changes when deleteBudget is called', () async {
      arrangeBudgetServiceReturnBudgets();
      arrangeBudgetServiceDeleteBudget();
      Future future = sut.deleteBudget(id: '1');
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct budget list is returned', () async {
      arrangeBudgetServiceReturnBudgets();
      arrangeBudgetServiceDeleteBudget();
      await sut.deleteBudget(id: '1');
      expect(sut.budgetList, budgetsFromService);
    });
  });
}
