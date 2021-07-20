import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/state/marketlist/marketlist_store.dart';
import 'package:cripto_market/app/state/userevents/userevents_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<UserEventsStore>(context);
    final marketStore = Provider.of<MarketListStore>(context);
    final favoritesStore = Provider.of<FavoritesStore>(context);
    return StreamBuilder<List<AssetsPair>>(
      stream: marketStore.filteredList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data!.elementAt(index).name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      snapshot.data!.elementAt(index).realPrice.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Observer(builder: (context) {
                      if (favoritesStore
                          .isFavorite(snapshot.data!.elementAt(index))) {
                        if (favoritesStore.checkMinBorderPrice(
                            snapshot.data!.elementAt(index))) {
                          userStore.addToUserEvents(UserEvent(
                              snapshot.data!.elementAt(index).name,
                              userStore.currentTimeInSeconds(),
                              'Reaching the minimum limit'));
                        }
                        if (favoritesStore.checkMaxBorderPrice(
                            snapshot.data!.elementAt(index))) {
                          userStore.addToUserEvents(UserEvent(
                              snapshot.data!.elementAt(index).name,
                              userStore.currentTimeInSeconds(),
                              'Reaching the maximum limit'));
                        }
                      }

                      return IconButton(
                          icon: favoritesStore
                                  .isFavorite(snapshot.data!.elementAt(index))
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          color: Colors.purple,
                          onPressed: () {
                            if (favoritesStore
                                .isFavorite(snapshot.data!.elementAt(index))) {
                              favoritesStore.removeFromFavorites(
                                  snapshot.data!.elementAt(index));
                              userStore.addToUserEvents(UserEvent(
                                  snapshot.data!.elementAt(index).name,
                                  userStore.currentTimeInSeconds(),
                                  'Remove From Favourite'));
                            } else {
                              favoritesStore.addToFavorites(
                                  snapshot.data!.elementAt(index));
                              userStore.addToUserEvents(UserEvent(
                                  snapshot.data!.elementAt(index).name,
                                  userStore.currentTimeInSeconds(),
                                  'Add To Favourite'));
                            }
                          });
                    }),
                  ],
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Возникла проблема:\n' + snapshot.error.toString()),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
