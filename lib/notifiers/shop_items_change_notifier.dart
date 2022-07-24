import 'package:flutter/cupertino.dart';
import 'package:retreat/models/item.dart';
import 'package:retreat/services/shop_service.dart';

class ShopItemsChangeNotifier extends ChangeNotifier {
  List<Item> _shopItemsList = List.empty();
  List<Item> get shopItemsList {
    isUpToDate ? true : getShopItems();
    return _shopItemsList;
  }

  bool isUpToDate = false;

  void getShopItems() async {
    _shopItemsList = await ShopService.getItems();
    isUpToDate = true;
    notifyListeners();
  }

  void reset() {
    _shopItemsList = List.empty();
    isUpToDate = false;
  }
}
