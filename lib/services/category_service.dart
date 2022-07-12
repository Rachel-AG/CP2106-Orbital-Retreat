import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/category.dart';

class CategoryService {
  static final client = Supabase.instance.client;

  static Future<List<Category>> getExpenseCategories() async {
    final result = await client
        .from('categories')
        .select()
        .eq('is_expense', true)
        .execute();

    final dataList = result.data as List;
    return dataList.map((e) => Category.fromJson(e)).toList();
  }

  static Future<List<Category>> getIncomeCategories() async {
    final result = await client
        .from('categories')
        .select()
        .eq('is_expense', false)
        .execute();

    final dataList = result.data as List;

    return dataList.map((e) => Category.fromJson(e)).toList();
  }
}
