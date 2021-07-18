import 'dart:async';
import 'dart:convert' as convert;

import 'package:web_socket_channel/web_socket_channel.dart';

enum SubscriptionType { NONE, LITETICKER, TICKER }

class WebChannelAPI {
  SubscriptionType _subscriptionType = SubscriptionType.NONE;
  bool _isInitialize = false;
  late WebSocketChannel _channel;
  List<double> _streamList = <double>[];

  final String _uriConnect = 'wss://demo-futures.kraken.com/ws/v1';
  StreamController<List<double>> _streamController =
      StreamController.broadcast();

  Stream<List<double>> get getDataStream => _streamController.stream;

  WebChannelAPI._privateConstructor() {}

  static final WebChannelAPI _instance = WebChannelAPI._privateConstructor();

  factory WebChannelAPI() {
    return _instance;
  }

  Future<WebSocketChannel> get webChannel async {
    if (_isInitialize) return _channel;
    return reconnect();
  }

  Future<WebSocketChannel> reconnect() async {
    print("reconnect");
    _channel = await WebSocketChannel.connect(Uri.parse(_uriConnect));
    _channel.stream.listen((streamData) {
      print('STREAM LISTEN ${streamData.toString()}');
      final request = convert.jsonDecode(streamData.toString());
      if (request.containsKey('event') && request['event'].contains('alert')) {
        _streamController.addError('Unable to subscribe to currency');
      } else {
        Map<String, dynamic> json = convert.jsonDecode(streamData.toString());
        if (json.containsKey('ask')) _streamList.add(json['ask']);

        _streamController.add(_streamList);
      }
      _isInitialize = true;
    }, onDone: () {
      print("Connecting aborted");
    }, onError: (e) {
      print('Server error: $e');
      if(e.toString().contains('was not upgrade'))
      return Future.error("Not websocket");
    }, cancelOnError: true);
    return _channel;
  }

  void subscribeTicker(String assetPairs) async {
    print("subscribeTicker...${assetPairs}");
    if (_subscriptionType != SubscriptionType.TICKER) {
      //_clearSubscribes();
      final channel = await webChannel;;

     String tmp = convert.jsonEncode({
        "event": "subscribe",
        "feed": "ticker",
        "product_ids": [assetPairs]
      });
      print('tmp = $tmp');

      channel.sink.add(convert.jsonEncode({
        "event": "subscribe",
        "feed": "ticker",
        "product_ids": [assetPairs]
      }));
      print("subscribeTicker...1111");
    }
  }

  void clearSubscribe(String assetPairs) {
    print("unsubscribeWebChannel");
    _channel.sink.add(convert.jsonEncode({
      "event": "unsubscribe",
      "feed": "ticker",
      "product_ids": [assetPairs]
    }));
  }

  void disposeSocket() {
    print("disposeSocket");
    _channel.sink.close();
    _streamController.close();
    print('disposeSocket');
  }
}
