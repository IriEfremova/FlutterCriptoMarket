import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:cripto_market/app/state/page/page_store.dart';
import 'package:cripto_market/app/ui/pages/favourite_page.dart';
import 'package:cripto_market/app/ui/pages/home_page.dart';
import 'package:cripto_market/app/ui/pages/market_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final WebServiceAPI _webService;

  const MainPage(this._webService, {Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _tabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Market'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
  ];

  @override
  Widget build(BuildContext context) {
    final pageStore = Provider.of<PageStore>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Image.asset('assets/images/bitkoin.png'),
          title: Text('Cripto Market'),
        ),
        body: Observer(builder: (context) {
          switch (pageStore.currentPage) {
            case 0:
              return HomePage(widget._webService);
            case 1:
              return MarketPage();
            case 2:
              return FavouritePage();
            default: return HomePage(widget._webService);
          }
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
