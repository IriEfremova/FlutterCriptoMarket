import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/state/marketlist/marketlist_store.dart';
import 'package:cripto_market/app/state/userevents/userevents_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MarketPage extends StatelessWidget {
  MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(6),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: SearchWidget(),
              ),
              Expanded(
                flex: 10,
                child: ListWidget(),
              ),
            ]));
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final marketStore = Provider.of<MarketListStore>(context);
    return Container(
      padding: EdgeInsets.only(left: 5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 26, 25, 39),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (String value) {
                marketStore.setSearchText(value);
              },
            ),
          ),
          IconButton(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {marketStore.setSearchText('');
            _controller.clear();},
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class ListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<UserEventsStore>(context);
    final marketStore = Provider.of<MarketListStore>(context);
    final favoritesStore = Provider.of<FavoritesStore>(context);
    return Observer(builder: (context) {
      return FutureBuilder<List<AssetsPair>>(
        future: marketStore.filteredList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('future ${snapshot.data.toString()}');
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
                        snapshot.data!.elementAt(index).realPrice,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Observer(builder: (context) {
                        return IconButton(
                            icon: favoritesStore.isFavorite(AssetsPair(
                                    snapshot.data!.elementAt(index).name))
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                            color: Colors.purple,
                            onPressed: () {
                              if (favoritesStore.isFavorite(AssetsPair(
                                  snapshot.data!.elementAt(index).name))) {
                                favoritesStore.removeFromFavorites(AssetsPair(
                                    snapshot.data!.elementAt(index).name));
                                userStore.addToUserEvents(UserEvent(snapshot.data!.elementAt(index).name, userStore.currentTimeInSeconds(), 'Remove From Favourite'));
                              } else {
                                favoritesStore.addToFavorites(snapshot.data!.elementAt(index));
                                userStore.addToUserEvents(UserEvent(snapshot.data!.elementAt(index).name, userStore.currentTimeInSeconds(), 'Add To Favourite'));
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
    });
  }
}
