import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/models/auth_required_state.dart';
import 'package:retreat/models/island.dart';
import 'package:retreat/models/item.dart';
import 'package:retreat/models/gamestat.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
import 'package:retreat/widgets/itemtile.dart';
import 'package:retreat/notifiers/shop_items_change_notifier.dart';
import 'package:retreat/notifiers/gamestat_change_notifier.dart';

/// this class represents the Builder Shop page
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

  /// this method returns grid view of all the item tiles on the Builder Shop
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
                    // deduct user's gold based on the price of item
                    Provider.of<GamestatChangeNotifier>(context, listen: false)
                        .updateGamestat(gold: gamestat.gold - e.price);

                    // update user's island
                    buyItem(islandChangeNotifier, e);

                    // notify user on successful purchase
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Item bought successfully!'),
                      duration: Duration(seconds: 3),
                    ));
                  }
                }))
            .toList());
  }

  /// this method checks whether the user has enough gold to buy the item
  bool canBuy(int currentGold, int price) {
    return (currentGold - price) >= 0;
  }

  /// this method checks whether the user has already purchased the selected animal
  /// 
  /// this is done by checking whether animalName exists in the user's animalList
  bool haveBoughtAnimal(List animalList, String animalName) {
    String lowerCaseName = animalName.toLowerCase();

    for (int i = 0; i < animalList.length; i++) {
      if (animalList[i] == lowerCaseName) {
        return true;
      }
    }
    return false;
  }

  /// this method checks whether the user has already purchased the selected environment
  /// 
  /// this is done by checking whether envName exists in the user's envList
  bool haveBoughtEnvironment(List envList, String envName) {
    String lowerCaseName = envName.toLowerCase();

    for (int i = 0; i < envList.length; i++) {
      if (envList[i] == lowerCaseName) {
        return true;
      }
    }
    return false;
  }

  /// this method checks whether the user has already purchased the selected block
  /// 
  /// this is done by checking whether the corresponding index in the ratio list
  /// equals to the initial value which we have set, which is 2.0
  bool haveBoughtBlock(List ratio, String blockName) {
    if (blockName == 'grass') {
      if (ratio[2] == 2.0) {
        //based on value on init island
        return false;
      } else {
        return true;
      }
    } else {
      if (ratio[4] == 2.0) {
        return false;
      } else {
        return true;
      }
    }
  }

  /// checks whether the user has already purchased the selected item on the Builder Store
  /// 
  /// if the selected item can only be purchased once and the user has not purchased the item 
  /// before, this method returns false. if the selected item can only be purchased once and 
  /// the user has purchased the item before, this method returns true. else if the selected item 
  /// can be purchased multiple times, this method always returns false.
  bool haveBoughtItem(Island island, Item item) {
    if (item.type == 'animal') {
      return haveBoughtAnimal(island.animalList, item.name);
    } else if (item.type == "environment") {
      return haveBoughtEnvironment(island.envList, item.name);
    } else if (item.type == "cloud") {
      return island.cloudBool;
    } else if (item.type == "block") {
      return haveBoughtBlock(island.ratio, item.name.toLowerCase());
    } else {
      //expand, refresh can be bought multiple times
      return false;
    }
  }

  /// buys the selected item 
  /// 
  /// this method updates the island database of the user when he/she successfully buy an item from
  /// the Builder Shop
  Future<void> buyItem(
      IslandChangeNotifier islandChangeNotifier, Item item) async {
    Island current = islandChangeNotifier.island;
    if (item.type == 'animal') {
      current.animalList.add(item.name.toLowerCase());
      Provider.of<IslandChangeNotifier>(context, listen: false)
          .updateIsland(animalList: current.animalList);
    } else if (item.type == "environment") {
      current.envList.add(item.name.toLowerCase());
      Provider.of<IslandChangeNotifier>(context, listen: false)
          .updateIsland(envList: current.envList);
    } else if (item.type == "cloud") {
      Provider.of<IslandChangeNotifier>(context, listen: false)
          .updateIsland(cloudBool: true);
    } else if (item.type == "block") {
      if (item.name == "Grass") {
        List<double> newRatio = List.from(current.ratio);
        newRatio[2] = 0.4;
        Provider.of<IslandChangeNotifier>(context, listen: false)
            .updateIsland(ratio: newRatio);
      } else {
        List<double> newRatio = List.from(current.ratio);
        newRatio[4] = 0.8;
        Provider.of<IslandChangeNotifier>(context, listen: false)
            .updateIsland(ratio: newRatio);
      }
    } else if (item.type == "expand") {
      int newRadius = current.gridRadius + 3;
      Provider.of<IslandChangeNotifier>(context, listen: false)
          .updateIsland(gridRadius: newRadius);
    } else {
      //refresh
      String newSeed = islandChangeNotifier.generateRandomStr(4);
      Provider.of<IslandChangeNotifier>(context, listen: false)
          .updateIsland(seed: newSeed);
    }
  }
}
