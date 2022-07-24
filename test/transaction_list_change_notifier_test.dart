import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retreat/models/transaction.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/services/transactions_service.dart';

class MockTransactionService extends Mock implements TransactionService {}

void main() {
  late TransactionListChangeNotifier sut;
  late MockTransactionService mockTransactionService;
  late List<Transaction> transactionsFromService;

  setUp(() {
    mockTransactionService = MockTransactionService();
    sut = TransactionListChangeNotifier(mockTransactionService);

    transactionsFromService = [
      const Transaction('1', 'notes1', 10.0, '2022-06-12',
          '2022-07-17 19:43:40.40', 'user1', true, 1),
      const Transaction('2', 'notes2', 20.0, '2021-07-12',
          '2022-07-18 19:43:40.40', 'user1', true, 2),
      const Transaction('3', 'notes3', 50.0, '2022-08-12',
          '2022-07-19 19:43:40.40', 'user1', false, 12),
      const Transaction('4', 'notes4', 50.0, '2022-06-12',
          '2022-07-15 19:43:40.40', 'user1', false, 12),
    ];
  });

  void arrangeTransactionServiceReturnTransactions() {
    when(
      () => mockTransactionService.getAllTransactions(),
    ).thenAnswer((_) async => transactionsFromService);
  }

  void arrangeTransactionServiceInsertTransaction() {
    when(
      () => mockTransactionService.insertTransaction(
          amount: 400.0,
          notes: 'added',
          categoryId: 2,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: true),
    ).thenAnswer((_) async {
      Transaction newTransaction = const Transaction('5', 'added', 400.0,
          '2022-07-19 19:43:40.40', '2022-07-19 19:43:40.40', 'user1', true, 2);
      transactionsFromService.add(newTransaction);
      return true;
    });
  }

  void arrangeTransactionServiceUpdateTransaction() {
    when(
      () => mockTransactionService.updateTransaction(
          id: '1',
          amount: 1000.0,
          notes: 'updated',
          categoryId: 14,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: false),
    ).thenAnswer((_) async {
      transactionsFromService = transactionsFromService
          .where((element) => element.id != '1')
          .toList();
      transactionsFromService.add(const Transaction(
          '1',
          'updated',
          1000.0,
          '2022-07-19 19:43:40.40',
          '2022-07-19 19:43:40.40',
          'user1',
          false,
          14));
      return true;
    });
  }

  void arrangeTransactionServiceDeleteTransaction() {
    when(
      () => mockTransactionService.deleteTransaction('1'),
    ).thenAnswer((_) async {
      transactionsFromService = transactionsFromService
          .where((element) => element.id != '1')
          .toList();
      return true;
    });
  }

  test('Correct initial values', () {
    expect(sut.isUpToDate, false);
  });

  group('getAllTransactions', () {
    test('get transactions using the TransactionService', () async {
      arrangeTransactionServiceReturnTransactions();
      await sut.getAllTransactions();
      verify(
        () => mockTransactionService.getAllTransactions(),
      ).called(1);
    });

    test('isUpToDate changes when getAllTransaction is called', () async {
      arrangeTransactionServiceReturnTransactions();
      expect(sut.isUpToDate, false);
      await sut.getAllTransactions();
      expect(sut.isUpToDate, true);
    });

    test('correct transaction list is returned', () async {
      arrangeTransactionServiceReturnTransactions();
      await sut.getAllTransactions();
      expect(sut.allTransactionList, transactionsFromService);
    });
  });

  group('insertTransaction', () {
    test('insert transaction using TransactionService', () async {
      arrangeTransactionServiceInsertTransaction();
      arrangeTransactionServiceReturnTransactions();
      await sut.insertTransaction(
          amount: 400.0,
          notes: 'added',
          categoryId: 2,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: true);
      verify(
        () => mockTransactionService.insertTransaction(
            amount: 400.0,
            notes: 'added',
            categoryId: 2,
            timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
            isExpense: true),
      ).called(1);
    });

    test('isUpToDate changes when insertTransaction is called', () async {
      arrangeTransactionServiceInsertTransaction();
      arrangeTransactionServiceReturnTransactions();
      Future future = sut.insertTransaction(
          amount: 400.0,
          notes: 'added',
          categoryId: 2,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: true);
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct transaction list is returned', () async {
      arrangeTransactionServiceInsertTransaction();
      arrangeTransactionServiceReturnTransactions();
      await sut.insertTransaction(
          amount: 400.0,
          notes: 'added',
          categoryId: 2,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: true);
      expect(sut.allTransactionList, transactionsFromService);
    });
  });

  group('updateTransaction', () {
    test('update transaction using TransactionService', () async {
      arrangeTransactionServiceReturnTransactions();
      arrangeTransactionServiceUpdateTransaction();
      await sut.updateTransaction(
          id: '1',
          amount: 1000.0,
          notes: 'updated',
          categoryId: 14,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: false);
      verify(
        () => mockTransactionService.updateTransaction(
            id: '1',
            amount: 1000.0,
            notes: 'updated',
            categoryId: 14,
            timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
            isExpense: false),
      ).called(1);
    });

    test('isUpToDate changes when updateTransaction is called', () async {
      arrangeTransactionServiceReturnTransactions();
      arrangeTransactionServiceUpdateTransaction();
      Future future = sut.updateTransaction(
          id: '1',
          amount: 1000.0,
          notes: 'updated',
          categoryId: 14,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: false);
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct transaction list is returned', () async {
      arrangeTransactionServiceReturnTransactions();
      arrangeTransactionServiceUpdateTransaction();
      await sut.updateTransaction(
          id: '1',
          amount: 1000.0,
          notes: 'updated',
          categoryId: 14,
          timeTransaction: DateTime.parse('2022-07-19 19:43:40.40'),
          isExpense: false);
      expect(sut.allTransactionList, transactionsFromService);
    });
  });

  group('deleteTransaction', () {
    test('delete transaction using TransactionService', () async {
      arrangeTransactionServiceReturnTransactions();
      arrangeTransactionServiceDeleteTransaction();
      await sut.deleteTransaction('1');
      verify(
        () => mockTransactionService.deleteTransaction('1'),
      ).called(1);
    });

    test('isUpToDate changes when deleteTransaction is called', () async {
      arrangeTransactionServiceReturnTransactions();
      arrangeTransactionServiceDeleteTransaction();
      Future future = sut.deleteTransaction('1');
      expect(sut.isUpToDate, false);
      await future;
      expect(sut.isUpToDate, true);
    });

    test('correct transaction list is returned', () async {
      arrangeTransactionServiceReturnTransactions();
      arrangeTransactionServiceDeleteTransaction();
      await sut.deleteTransaction('1');
      expect(sut.allTransactionList, transactionsFromService);
    });
  });
}
