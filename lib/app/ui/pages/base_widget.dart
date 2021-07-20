import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/state/userevents/userevents_store.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget extends StatelessWidget {
  final double price;

  const BaseWidget(this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favouriteStore = Provider.of<FavoritesStore>(context);
    final userStore = Provider.of<UserEventsStore>(context);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(6),
      color: CustomColors.black,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    'Currency: ${favouriteStore.assetsPair.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    'Current price: $price',
                    style: Theme.of(context).textTheme.bodyText1,
                  ))),
          Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Minimum price: ',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                          ),
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Maximum price: ',
                                    style:
                                    Theme.of(context).textTheme.bodyText1,
                                  ))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Flexible(
                            child: TextFormField(
                              initialValue:
                              favouriteStore.assetsPair.minPrice == -1
                                  ? ''
                                  : favouriteStore.assetsPair.minPrice
                                  .toString(),
                              keyboardType: TextInputType.number,
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor: CustomColors.background,
                                filled: true,
                                border: const OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              onFieldSubmitted: (String value) {
                                if (value.isNotEmpty) {
                                  userStore.addToUserEvents(UserEvent(
                                      favouriteStore.assetsPair.name,
                                      userStore.currentTimeInSeconds(),
                                      'Update Minimum Price'));
                                  favouriteStore.assetsPair.minPrice = double.tryParse(value)!;
                                  favouriteStore.updateFavoritesMinPrice(
                                      favouriteStore.assetsPair);
                                }
                              },
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                              favouriteStore.assetsPair.maxPrice == -1
                                  ? ''
                                  : favouriteStore.assetsPair.maxPrice
                                  .toString(),
                              keyboardType: TextInputType.number,
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor: CustomColors.background,
                                filled: true,
                                border: const OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              onFieldSubmitted: (String value) {
                                if (value.isNotEmpty) {
                                  userStore.addToUserEvents(UserEvent(
                                      favouriteStore.assetsPair.name,
                                      userStore.currentTimeInSeconds(),
                                      'Update Maximum Price'));
                                  favouriteStore.assetsPair.maxPrice = double.tryParse(value)!;
                                  favouriteStore.updateFavoritesMaxPrice(
                                      favouriteStore.assetsPair);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}