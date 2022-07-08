import 'package:flutter/cupertino.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';

class CategoryListChangeNotifier extends ChangeNotifier {
  List<Category> _expenseCatList = List.empty();
  List<Category> get expenseCatList {
    isUpToDate ? true : getCatList();
    return _expenseCatList;
  }

  List<Category> _incomeCatList = List.empty();
  List<Category> get incomeCatList {
    isUpToDate ? true : getCatList();
    return _incomeCatList;
  }

  bool isUpToDate = false;

  void getCatList() async {
    _expenseCatList = await CategoryService.getExpenseCategories();
    _incomeCatList = await CategoryService.getIncomeCategories();
    isUpToDate = true;
    notifyListeners();
  }

  void reset() {
    _expenseCatList = List.empty();
    _incomeCatList = List.empty();
    isUpToDate = false;
  }
}
