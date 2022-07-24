import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/item.dart';
import 'package:retreat/models/gamestat.dart';
import 'package:retreat/widgets/itemtile.dart';
import 'package:retreat/notifiers/shop_items_change_notifier.dart';
import 'package:retreat/notifiers/gamestat_change_notifier.dart';

class BuilderShopPage extends StatefulWidget {
  const BuilderShopPage({Key? key}) : super(key: key); //??

  @override
  State<BuilderShopPage> createState() => _BuilderShopPageState();
}

class _BuilderShopPageState extends AuthRequiredState<BuilderShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Builder Shop'),
        centerTitle: true,
      ),
      body: Consumer2<GamestatChangeNotifier, ShopItemsChangeNotifier>(
          builder: (context, value, value2, child) {
        if (!value.isUpToDate) {
          value.gamestat;
          return const CircularProgressIndicator();
        }
        if (!value2.isUpToDate) {
          value2.shopItemsList;
          return const CircularProgressIndicator();
        }

        return shopGridView(value, value2);
      }),
    );
  }

  Widget shopGridView(GamestatChangeNotifier gamestatChangeNotifier,
      ShopItemsChangeNotifier shopItemsChangeNotifier) {
    Gamestat gamestat = gamestatChangeNotifier.gamestat;
    List<Item> allItems = shopItemsChangeNotifier.shopItemsList;

    if (!gamestatChangeNotifier.isUpToDate) {
      return const CircularProgressIndicator();
    }

    if (!shopItemsChangeNotifier.isUpToDate) {
      return const CircularProgressIndicator();
    }

    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: 
        allItems.map((e) => ItemTile(
          imageUrl: e.imageUrl,
          title: e.name,
          price: e.price
        )).toList()
    );
        // [
        //   for (int i = 0; i < allItems.length; i++) {
        //     ItemTile(imageUrl: allItems[i].imageUrl,
        //     title: allItems[i].name,
        //     price: allItems[i].price)
        //   }
        // ]);
  }
}
