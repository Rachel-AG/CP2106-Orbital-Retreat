import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/models/item.dart';
import 'package:retreat/models/gamestat.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
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
      body: Consumer3<GamestatChangeNotifier, ShopItemsChangeNotifier,
              IslandChangeNotifier>(
          builder: (context, value, value2, value3, child) {
        if (!value.isUpToDate) {
          value.gamestat;
          // return const CircularProgressIndicator();
        }
        if (!value2.isUpToDate) {
          value2.shopItemsList;
          // return const CircularProgressIndicator();
        }

        if (!value3.isUpToDate) {
          value3.island;
          // return const CircularProgressIndicator();
        }

        return shopGridView(value, value2, value3);
      }),
    );
  }

  Widget shopGridView(
      GamestatChangeNotifier gamestatChangeNotifier,
      ShopItemsChangeNotifier shopItemsChangeNotifier,
      IslandChangeNotifier islandChangeNotifier) {
    Gamestat gamestat = gamestatChangeNotifier.gamestat;
    List<Item> allItems = shopItemsChangeNotifier.shopItemsList;
    Island island = islandChangeNotifier.island;

    // if (!gamestatChangeNotifier.isUpToDate) {
    //   return const CircularProgressIndicator();
    // }

    // if (!shopItemsChangeNotifier.isUpToDate) {
    //   return const CircularProgressIndicator();
    // }

    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: allItems
            .map((e) => ItemTile(
                imageUrl: e.imageUrl,
                title: e.name,
                price: e.price,
                onPressed: () async {
                  if (!canBuy(gamestat.gold, e.price)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Not enough gold to buy this item'),
                      duration: Duration(seconds: 2),
                    ));
                  } else if (haveBoughtItem(island, e)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('You have already bought this item'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    Provider.of<GamestatChangeNotifier>(context, listen: false)
                        .updateGamestat(
                            whichStat: "gold",
                            updatedValue: (gamestat.gold - e.price));
                    // Provider.of<GamestatChangeNotifier>;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Item bought successfully!'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                }))
            .toList());
    // [
    //   for (int i = 0; i < allItems.length; i++) {
    //     ItemTile(imageUrl: allItems[i].imageUrl,
    //     title: allItems[i].name,
    //     price: allItems[i].price)
    //   }
    // ]);
  }

  bool canBuy(int currentGold, int price) {
    return (price - currentGold) >= 0;
  }

  bool haveBoughtAnimal(List animalList, String animalName) {
    String lowerCaseName = animalName.toLowerCase();

    for (var i in animalList) {
      if (animalList[i] == lowerCaseName) {
        return true;
      }
    }
    return false;
  }

  bool haveBoughtEnvironment(List envList, String envName) {
    String lowerCaseName = envName.toLowerCase();

    for (var i in envList) {
      if (envList[i] == lowerCaseName) {
        return true;
      }
    }
    return false;
  }

  bool haveBoughtItem(Island island, Item item) {
    if (item.type == 'animal') {
      return haveBoughtAnimal(island.animalList, item.name);
    } else {
      return haveBoughtEnvironment(island.envList, item.name);
    }
  }
}
