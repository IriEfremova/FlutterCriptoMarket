import 'dart:async';
import 'dart:isolate';
import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:cripto_market/app/state/assetspair/assetspair_store.dart';
import 'package:cripto_market/app/state/marketlist/marketlist_store.dart';
import 'package:cripto_market/app/state/userevents/userevents_store.dart';
import 'package:cripto_market/app/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'app/core/database/database.dart';

import 'app/core/repository/web_channel_api.dart';
import 'app/state/favorites/favorite_store.dart';
import 'app/state/page/page_store.dart';

import 'app/state/rssnews/rss_store.dart';
import 'app/ui/style/theme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Меняем writePolicy, чтобы Observable могли быть изменены только внутри экшенов
  mainContext.config = ReactiveConfig.main.clone(
    writePolicy: ReactiveWritePolicy.always,
  );
  print("runApp");
  runApp(App());


}


  class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("build app page");
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => WebServiceAPI(),
        ),
        Provider(
          create: (context) => WebChannelAPI(),
          dispose: (BuildContext context, WebChannelAPI value) =>
              value.disposeSocket(),
        ),
        Provider(
          create: (context) => DatabaseInstance(),
        ),
        Provider(
          create: (context) => FavoritesStore(context.read<DatabaseInstance>()),
        ),
        Provider(
          create: (context) => UserEventsStore(context.read<DatabaseInstance>()),
        ),
        Provider(
          create: (context) => PageStore(),
        ),
        Provider(
          create: (context) => RssStore(),
        ),
        Provider(
          create: (context) => MarketListStore(context.read<WebServiceAPI>()),
        ),
      ],
      child: MaterialApp(
        theme: mainThemeData,
        home: MainPage(),
      ),
    );
  }
}
