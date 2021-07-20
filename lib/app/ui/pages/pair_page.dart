import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/ui/pages/animation_widget.dart';
import 'package:cripto_market/app/ui/pages/base_widget.dart';
import 'package:cripto_market/app/ui/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PairPage extends StatelessWidget {
  const PairPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final webChannel = Provider.of<WebChannelAPI>(context);
    final favouriteStore = Provider.of<FavoritesStore>(context);
    return MaterialApp(
        theme: mainThemeData,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: Image.asset('assets/images/bitkoin.png'),
              title: Text('Cripto Market'),
            ),
            body: LayoutBuilder(builder: (contextL, constraints) {
              return Container(
                child: Column(
                  children: <Widget>[
                    BaseWidget(),
                    AnimationWidget(
                        color: Colors.blue, widthWidget: constraints.maxWidth),
                    TextButton(
                      onPressed: () {
                        webChannel
                            .clearSubscribe(favouriteStore.assetsPair.name);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            })));
  }
}

