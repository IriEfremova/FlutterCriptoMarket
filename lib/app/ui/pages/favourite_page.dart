import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/ui/pages/pair_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatelessWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('List of favourites'),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget _buildBody(BuildContext context) {
    final favouriteStore = Provider.of<FavoritesStoreBase>(context);
    return ListView.builder(
      itemCount: favouriteStore.favoritesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PairPage()),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  favouriteStore.favoritesList.elementAt(index).name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  favouriteStore.favoritesList.elementAt(index).minPrice.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  favouriteStore.favoritesList.elementAt(index).maxPrice.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: Colors.purple,
                    onPressed: () {favouriteStore.addToFavorites(favouriteStore.favoritesList.elementAt(index));}),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
  Widget _buildBody1(BuildContext context) {
    return FutureBuilder<Iterable<String>>(
        future: AsyncWebService().fetchTradePairs(),
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
                        snapshot.data!.elementAt(index),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '...',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      IconButton(
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.purple,
                          onPressed: () {}),
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
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
              Text(
                'Search...',
                style: TextStyle(color: Colors.white),
              ),
            ]),
          );
        });
  }

   */
}
