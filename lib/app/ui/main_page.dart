import 'package:cripto_market/app/core/database/database.dart';
import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/state/page/page_store.dart';
import 'package:cripto_market/app/state/rssnews/rss_store.dart';
import 'package:cripto_market/app/ui/pages/favourite_page.dart';
import 'package:cripto_market/app/ui/pages/home_page.dart';
import 'package:cripto_market/app/ui/pages/market_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pages = [HomePage(), MarketPage(), FavouritePage()];

  final _tabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Market'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
  ];

  @override
  void dispose() {
    print('dispose widget');
    super.dispose();

    Provider.of<WebChannelAPI>(context).disposeSocket();
    Provider.of<DatabaseInstance>(context).closeDatabase();
    Provider.of<RssStore>(context).disposeRssNews();
  }

  @override
  Widget build(BuildContext context) {
    print("build main page");
    final pageStore = Provider.of<PageStore>(context);
   // final webChannel = Provider.of<WebChannelAPI>(context);
    //final favouriteStore = Provider.of<FavoritesStore>(context);
    return Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          leading: Image.asset('assets/images/bitkoin.png'),
          title: Text('Cripto Market'),
        ),
        body: Observer(builder: (context) {
          return _pages[pageStore.currentPage];
        }),
        bottomNavigationBar: Observer(builder: (context) {
          return BottomNavigationBar(
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,
            items: _tabs,
            currentIndex: pageStore.currentPage,
            onTap: (index) {
              pageStore.setCurrentPage(index);
            },
          );
        }));
  }
}
