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
    webChannel.subscribeTicker(favouriteStore.assetsPair.piName);
    return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: Image.asset('assets/images/bitkoin.png'),
              title: Text('Cripto Market'),
            ),
            body: LayoutBuilder(builder: (contextL, constraints) {
              return StreamBuilder<List<double>>(
                stream: webChannel.getDataStream,
                builder: (context, AsyncSnapshot<List<double>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          BaseWidget(snapshot.data!.isEmpty ? 0 : snapshot.data!.last),
                          AnimationWidget(
                              dataList: snapshot.data!, color: Colors.blue, widthWidget: constraints.maxWidth),
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
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Unable to subscribe to currency ' +
                            favouriteStore.assetsPair.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

            }));
  }
}

