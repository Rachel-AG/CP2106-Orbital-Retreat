import 'package:flutter/cupertino.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';

class CategoryListChangeNotifier extends ChangeNotifier {
  final CategoryService _categoryService;
  CategoryListChangeNotifier(this._categoryService);

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
    _expenseCatList = await _categoryService.getExpenseCategories();
    _incomeCatList = await _categoryService.getIncomeCategories();
    isUpToDate = true;
    notifyListeners();
  }

  String getCategoryNameFromId(int id) {
    final list = expenseCatList + incomeCatList;
    if (list.isEmpty) {
      return "Loading...";
    }
    return list.firstWhere((element) => element.id == id, orElse: () {
      return Category(-1, 'id: $id not found', true);
    }).name;
  }

  void reset() {
    _expenseCatList = List.empty();
    _incomeCatList = List.empty();
    isUpToDate = false;
  }
}
