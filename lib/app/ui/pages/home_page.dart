import 'package:cripto_market/app/core/model/websocket_response.dart';
import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:cripto_market/app/ui/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

/* WORK!!! @override
  Widget build(BuildContext context) {
    final webChannel = Provider.of<WebChannelAPI>(context);
    //Provider.of<WebChannelAPI>(context).subscribeWebTimer();
    print("build home page");
    //return Text('n/a');
    return StreamBuilder(
        stream: webChannel.getDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('stream ${snapshot.data.toString()}');
            final Map<String, dynamic> data = convert.jsonDecode(snapshot.data.toString());
            return Center(child: Text(WebSocketResponse().getServerTime(data)));
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Text('n/a');
        });
  }
}*/

  @override
  Widget build(BuildContext context) {
    //Provider.of<WebChannelAPI>(context).subscribeWebTimer();
    print("build home page");
    return Container(
      child: Column(
        children: <Widget>[
          StatusWidget(),
          Container(
            color: CustomColors.black,
            margin: EdgeInsets.all(10),
            //padding: EdgeInsets.all(10),
            child: Center(child: Text('Second Widget')),
          ),
          //_buildWidget(),
        ],
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    //Provider.of<WebChannelAPI>(context).subscribeWebTimer();
    print("build home page");
    return FutureBuilder(
      future: Provider.of<WebChannelAPI>(context).initWebSocket(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          Container(
            child: Column(
              children: <Widget>[
                StatusWidget(),
                Container(
                  color: CustomColors.black,
                  margin: EdgeInsets.all(10),
                  //padding: EdgeInsets.all(10),
                  child: Center(child: Text('Second Widget')),
                ),
                //_buildWidget(),
              ],
            ),
          );
        }
        return Padding(padding: EdgeInsets.all(20), child: Text('Connect...'));
      },
    );
  }
}


 */
class StatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final webChannel = Provider.of<WebChannelAPI>(context);
    final webService = Provider.of<WebServiceAPI>(context);
    //webChannel.subscribeWebTimer();
    return Container(
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/bit_image.jpg"),
        fit: BoxFit.fill,
      )),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: webChannel.initWebSocket(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Невозможно соединение с вебсервером Kraken.com');
              }
              if (snapshot.hasData) {
                webChannel.subscribeWebTimer();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FutureBuilder(
                        future: webService.fetchStatusServer(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          }
                          return Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Connect...'));
                        },
                      ),
                    ),
                    Flexible(
                        child: StreamBuilder(
                            stream: webChannel.getDataStream,
                            builder: (context, snapshot) {
                              print('stream');
                              if (snapshot.hasData) {
                                final Map<String, dynamic> data = convert
                                    .jsonDecode(snapshot.data.toString());
                                return Text(
                                    'Server time: ${WebSocketResponse().getServerTime(data)}');
                              }
                              return Text('Server time:');
                            })),
                  ],
                );
              }
              return Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Connect...'));
            },
          ),
        ),
      ),
    );
  }
}
