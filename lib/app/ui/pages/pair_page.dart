import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/state/favorites/favorite_store.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PairPage extends StatelessWidget {
  const PairPage({Key? key}) : super(key: key);
      
  @override
  Widget build(BuildContext context) {
    final favourite = Provider.of<FavoritesStoreBase>(context);
    return Container(
      child: Column(
        children: <Widget>[
          StatusWidget(),
          Container(
            color: CustomColors.black,
            //padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Center(child: TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),),
          ),
          Container(
            color: CustomColors.black,
            margin: EdgeInsets.all(10),
            //padding: EdgeInsets.all(10),
            child: Center(child: Text('Second Widget',style: Theme.of(context).textTheme.bodyText1,)),
          ),
          //_buildWidget(),
        ],
      ),
    );
  }

}

class StatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final webChannel = Provider.of<WebChannelAPI>(context);
    return StreamBuilder(
      stream: webChannel.getDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Возникла проблема:\n' + snapshot.error.toString(), style: Theme.of(context).textTheme.bodyText1,),
          );
        }
        if (snapshot.hasData) {
          return Center(
            child: Text('Данные:\n' + snapshot.data.toString(), style: Theme.of(context).textTheme.bodyText1,),
          );
        }
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
            Text(
              'Connect...',
              style: TextStyle(color: Colors.white),
            ),
          ]),
        );
      },
    );
  }

}