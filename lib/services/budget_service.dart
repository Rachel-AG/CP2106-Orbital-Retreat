import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/budget.dart';

class BudgetService {
  static final client = Supabase.instance.client;

  Future<List<Budget>> getAllBudget() async {
    final result = await client
        .from('budgets')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    final dataList = result.data as List;

    return List.from(dataList.map((e) => Budget.fromJson(e)).toList());
  }

  Future<bool> insertBudget(
      {required double amount, required int month, required int year}) async {
    final result = await client.from('budgets').insert([
      {'amount': amount, 'month': month, 'year': year}
    ]).execute();

    if (result.error != null) return false;
    return true;
  }

  Future<bool> updateBudget(
      {required String id,
      required double amount,
      required int month,
      required int year}) async {
    final result = await client
        .from('budgets')
        .update({
          'amount': amount,
        })
        .eq('month', month)
        .eq('year', year)
        .eq('id', id)
        .execute();

    if (result.error != null) return false;

    return true;
  }

  /// Deletes Budget
  Future<bool> deleteBudget({required String id}) async {
    final result = await client.from('budgets').delete().eq('id', id).execute();
    if (result.error?.message != null) return false;
    return true;
  }
}
