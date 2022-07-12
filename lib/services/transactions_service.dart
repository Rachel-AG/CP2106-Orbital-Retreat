import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transaction.dart';

class TransactionService {
  static final client = Supabase.instance.client;

  static Future<List<Transaction>> getAllTransactions() async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    final dataList = result.data as List;
    return List.from(dataList.map((e) => Transaction.fromJson(e)).toList());
  }

  static Future<bool> insertTransaction(
      {required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    final result = await client.from('transactions').insert([
      {
        'amount': amount,
        'notes': notes,
        'category_id': categoryId,
        'time_transaction': timeTransaction.toIso8601String(),
        'is_expense': isExpense,
      }
    ]).execute();

    if (result.error != null) return false;
    return true;
  }

  static Future<bool> deleteTransaction(String id) async {
    final result =
        await client.from('transactions').delete().eq('id', id).execute();

    if (result.error != null) return false;
    return true;
  }

  static Future<bool> updateTransaction(
      {required String id,
      required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    final result = await client
        .from('transactions')
        .update({
          'amount': amount,
          'notes': notes,
          'category_id': categoryId,
          'time_transaction': timeTransaction.toIso8601String(),
          'is_expense': isExpense,
        })
        .eq('id', id)
        .execute();

    if (result.error != null) {
      print(result.error?.message);
      return false;
    }
    return true;
  }
}
