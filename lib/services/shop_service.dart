import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/item.dart';

/// this class represents Shop Service which interacts with the shop database
class ShopService {
  static final client = Supabase.instance.client;

  static Future<List<Item>> getItems() async {
    final result = await client
        .from('shop')
        .select()
        .execute();

    final dataList = result.data as List;
    return dataList.map((e) => Item.fromJson(e)).toList();
  }
}