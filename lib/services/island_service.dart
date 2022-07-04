import 'package:retreat/models/island.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IslandService {
  // TODO: connect to Database
  static final client = Supabase.instance.client;

  static Future<Island> getIsland() async {
    await Future.delayed(const Duration(seconds: 1));
    return Island(
        5, 10, 1, 'seed', [0, 0.2, 0.4, 0.6, 0.8], 5, [], [], true, true);
  }
}
