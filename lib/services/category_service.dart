import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/category.dart';

class CategoryService {
  static final client = Supabase.instance.client;

  static Future<List<Category>> getExpenseCategories(context) async {
    final result = await client
        .from('categories')
        .select()
        .eq('is_expense', true)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    return dataList.map((e) => Category.fromJson(e)).toList();
  }

  static Future<List<Category>> getIncomeCategories(context) async {
    final result = await client
        .from('categories')
        .select()
        .eq('is_expense', false)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    return dataList.map((e) => Category.fromJson(e)).toList();
  }
}
