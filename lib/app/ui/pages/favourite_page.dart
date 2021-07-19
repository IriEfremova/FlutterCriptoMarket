import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/ui/pages/pair_page.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'events_widget.dart';

class FavouritePage extends StatelessWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("build home page");
    return LayoutBuilder(builder: (contextL, constraints) {
      return Container(
        child: Column(
          children: <Widget>[
            UserEventWidget(),
            FavouriteWidget(constraints.maxHeight - 150 - 18),
          ],
        ),
      );
    });
  }
}

class FavouriteWidget extends StatelessWidget {
  final height;

  FavouriteWidget(this.height);

  @override
  Widget build(BuildContext context) {
    final favouriteStore = Provider.of<FavoritesStore>(context);
    return Observer(builder: (context) {
      return Container(
          margin: EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 6),
          padding: EdgeInsets.all(6),
          color: CustomColors.black,
          height: height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Favourite Assets Pairs:',
                      style: TextStyle(fontSize: 14, color: Colors.amber),
                    )),
                Expanded(
                  flex: 5,
                  child: favouriteStore.favoritesList.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.waves,
                            color: Colors.grey,
                            size: 24.0,
                          ),
                        )
                      : ListView.builder(
                          itemCount: favouriteStore.favoritesList.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return ListTile(
                                contentPadding: EdgeInsets.all(6),
                                leading: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                ),
                                tileColor: index % 2 == 0
                                    ? Colors.black54
                                    : Colors.black38,
                                title: Text(favouriteStore.favoritesList
                                    .elementAt(index)
                                    .name),
                                onTap: () {
                                  favouriteStore.choseAssetsPair(favouriteStore
                                      .favoritesList
                                      .elementAt(index));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PairPage()),
                                  );
                                });
                          }),
                ),
              ]));
    });
  }
}
