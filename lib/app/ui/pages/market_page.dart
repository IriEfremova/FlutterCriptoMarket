import 'dart:convert' as convert;
import 'package:cripto_market/app/core/model/websocket_response.dart';
import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/ui/pages/pair_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketPage extends StatelessWidget {
  MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final assetPairStore = Provider.of<AssetPairsStore>(context);
    //Provider.of<WebChannelAPI>(context)
    //   .subscribeLiteTicker(assetPairStore.assetPairList);
    return Scaffold(
      body: _buildBody(context),
    );
  }

  @override
  Widget _buildBody(BuildContext context) {
    final webChannel = Provider.of<WebChannelAPI>(context);
    return FutureBuilder(
      future: webChannel.initWebSocket(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Невозможно соединение с вебсервером Kraken.com'));
        }
        if (snapshot.hasData) {
          return StreamBuilder(
            stream: webChannel.getDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      'Ошибка передачи данных:\n' + snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                final Map<String, dynamic> data =
                    convert.jsonDecode(snapshot.data.toString());
                final Map<String, String> tickerInfo =
                    WebSocketResponse().getLiteTickerInfo(data);
                return ListView.builder(
                  itemCount: tickerInfo.length,
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
                              tickerInfo.keys.elementAt(index),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              tickerInfo.values.elementAt(index),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            IconButton(
                                icon: const Icon(Icons.favorite_border),
                                color: Colors.purple,
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return  Center(
          child: CircularProgressIndicator(),
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
