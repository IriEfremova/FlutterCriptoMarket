import 'dart:async';
import 'dart:convert' as convert;

import 'package:web_socket_channel/web_socket_channel.dart';

class WebChannelAPI {
  bool _isInitialize = false;
  late WebSocketChannel _channel;
  final List<double> _streamList = <double>[];

  final String _uriConnect = 'wss://demo-futures.kraken.com/ws/v1';
  final StreamController<List<double>> _streamController =
      StreamController.broadcast();

  Stream<List<double>> get getDataStream => _streamController.stream;

  WebChannelAPI._privateConstructor();

  static final WebChannelAPI _instance = WebChannelAPI._privateConstructor();

  factory WebChannelAPI() {
    return _instance;
  }

  Future<WebSocketChannel> get webChannel async {
    if (_isInitialize) return _channel;
    return reconnect();
  }

  Future<WebSocketChannel> reconnect() async {
    _channel = WebSocketChannel.connect(Uri.parse(_uriConnect));
    _channel.stream.listen((streamData) {
      print('STREAm LISTEn: ${streamData.toString()}');
      final request = convert.jsonDecode(streamData.toString());
      if (request.containsKey('event') && request['event'].contains('alert')) {
        _streamController.addError('Unable to subscribe to currency');
      } else {
        Map<String, dynamic> json = convert.jsonDecode(streamData.toString());
        if (json.containsKey('ask')) {
          _streamList.add(json['ask']);
        }
        _streamController.add(_streamList);
      }
      _isInitialize = true;
    }, onDone: () {
      print('Connecting aborted');
    }, onError: (e) {
      print('Server error: $e');
      if (e.toString().contains('was not upgrade')) {
        return Future.error('Not websocket');
      }
    }, cancelOnError: true);
    return _channel;
  }

  void subscribeTicker(String assetPairs) async {
    final channel = await webChannel;
    channel.sink.add(convert.jsonEncode({
      'event': 'subscribe',
      'feed': 'ticker',
      'product_ids': [assetPairs]
    }));
  }

  void clearSubscribe(String assetPairs) {
    print('clearSubscribe');
    _channel.sink.add(convert.jsonEncode({
      'event': 'unsubscribe',
      'feed': 'ticker',
    }));
  }

  void disposeSocket() {
    _channel.sink.close();
    _streamController.close();
  }
}
