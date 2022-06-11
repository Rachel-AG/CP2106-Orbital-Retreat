import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/category.dart';

class CategoryService {
  final client = Supabase.instance.client;

  Future<List<Category>> getExpenseCategories(context) async {
    final result = await client
        .from('categories')
        .select()
        .eq('isExpense', true)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    return List.from(
        dataList.map((e) => Category.fromJson(e)).toList());
  }

  Future<List<Category>> getIncomeCategories(context) async {
    final result = await client
        .from('categories')
        .select()
        .eq('isExpense', false)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    return List.from(
        dataList.map((e) => Category.fromJson(e)).toList().reversed);
  }
}
