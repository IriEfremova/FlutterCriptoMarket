import 'dart:async';
import 'dart:convert' as convert;

import 'package:web_socket_channel/web_socket_channel.dart';

enum SubscriptionType { NONE, TIME, ASSETPAIRS, ASSET }

class WebChannelAPI {
  SubscriptionType _subscriptionType = SubscriptionType.NONE;
  late final WebSocketChannel _channel;

  final String _uriConnect = 'wss://demo-futures.kraken.com/ws/v1';
  late String assetPair = '';
  StreamController<String> _streamController = StreamController.broadcast();

  //Stream get getDataStream => _channel.stream.asBroadcastStream();
  Stream get getDataStream => _streamController.stream;

  WebChannelAPI() {
    print('constructor WebChannelAPI');
/*    try {
      _channel = WebSocketChannel.connect(Uri.parse(_uriConnect));
      _channel.stream.listen((serverData) {
        print('listen data ${serverData.toString()}');
        _streamController.add(serverData);
      });
    } catch  (e) {
      print("Can't connect with WebSocketChannel" + e.toString());
    }*/
  }

  _internal() {
    initWebSocket();
  }

  initWebSocket() async {
    print("conecting...");
    if(_channel == null) {
      _channel = await WebSocketChannel.connect(Uri.parse(_uriConnect));
      print("socket connection initializied ${_channel.toString()}");

      _channel.stream.listen((streamData) {
        _streamController.add(streamData);
      }, onDone: () {
        print("connecting aborted");
        initWebSocket();
      }, onError: (e) {
        print('Server error: $e');
        initWebSocket();
      });
    }
    else
    print('channel is not null');
  }

  connectionWebSocket() async {
    //await WebSocketChannel.connect(Uri.parse(_uriConnect));

    /*try {
      return await WebSocketChannel.connect(Uri.parse(_uriConnect));
    } catch (e) {
      print("Can't connect to WebSocket" + e.toString());
      await Future.delayed(Duration(milliseconds: 10000));
      return await connectionWebSocket();
    }*/
  }

  broadcastNotifications() {
    print("broadcastNotifications");
    _channel.stream.listen((streamData) {
      _streamController.add(streamData);
    }, onDone: () {
      print("connecting aborted");
      initWebSocket();
    }, onError: (e) {
      print('Server error: $e');
      initWebSocket();
    });
  }



  //WebChannelAPI() {
    /*
    print("constructor WebChannelAPI");
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_uriConnect));
      _channel.stream.listen((serverData) {
        print('listen data ${serverData.toString()}');
        _streamController.add(serverData);
      });
    } catch  (e) {
      print("Can't connect with WebSocketChannel" + e.toString());
    }

     */
  //}


   subscribeWebTimer() {
    if (_subscriptionType != SubscriptionType.TIME) {
      print("subscribeWebTimer");
      clearSubscribes();
      _subscriptionType = SubscriptionType.TIME;

      _channel.sink
          .add(convert.jsonEncode({"event": "subscribe", "feed": "heartbeat"}));

/*      _channel.stream.listen((serverData) {
        print('put data to broadcast timer');
        _streamController.add(serverData);
      });*/
    }
  }

  void subscribeLiteTicker(List<String> assetPairsList) {
    for (String element in assetPairsList)
      element = 'PI_${element}';
    if (_subscriptionType != SubscriptionType.ASSETPAIRS) {
      clearSubscribes();
      _subscriptionType = SubscriptionType.ASSETPAIRS;
      print('subscribeLiteTicker ${assetPairsList.toString()}');
      _channel.sink.add(convert.jsonEncode({
        "event": "subscribe",
        "feed": "ticker_lite",
        "product_ids": [assetPairsList.toString()]
      }));

    }
  }

  void unsubscribeWebChannel() {
    print("unsubscribeWebChannel");
    _channel.sink.add(convert.jsonEncode({
      "event": "unsubscribe",
      "feed": "ticker",
      "product_ids": ["PI_${assetPair}"]
    }));
  }

  void subscribeWebChannel(String newAssetPair) {
    print("subscribeWebChannel");
    print('selectAssetPair PI_${newAssetPair}');
    if (newAssetPair.isNotEmpty) {
      assetPair = newAssetPair;
      unsubscribeWebChannel();
      _channel.sink.add(convert.jsonEncode({
        "event": "subscribe",
        "feed": "ticker",
        "product_ids": ["PI_${newAssetPair}"]
      }));
    }
  }

  void unsubscribeTimeWebChannel() {
    print("unsubscribeTimeWebChannel");
    _channel.sink
        .add(convert.jsonEncode({"event": "unsubscribe", "feed": "heartbeat"}));
  }

  void clearSubscribes() {
    print("clearSubscribes");
    if (_subscriptionType == SubscriptionType.TIME) {
      unsubscribeTimeWebChannel();
    }
    if (_subscriptionType == SubscriptionType.ASSET) {
      unsubscribeWebChannel();
    }
  }

  void disposeSocket() {
    print("disposeSocket");
    //unsubscribeWebChannel();
    clearSubscribes();
    _channel.sink.close();
    print('disposeSocket');
  }
}
