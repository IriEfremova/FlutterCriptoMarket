import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

@immutable
class RssMessage{
  final String title;
  final String description;
  RssMessage(this.title, this.description);
}

class RssStore {
  http.Client client;
  late Isolate _rssIsolate;
  late ReceivePort _isolateReceivePort;
  final _rssNewsList = ObservableList<RssMessage>();
  late Timer _timer;

  ObservableList<RssMessage> get rssNewsList => _rssNewsList;
  RssStore(this.client) {
    spawnRssIsolate();
    _timer = Timer.periodic(Duration(minutes: 1), (t) {
      spawnRssIsolate();
    });
  }

  void spawnRssIsolate() async {
    _isolateReceivePort = ReceivePort();
    try {
      _rssIsolate = await Isolate.spawn(fetchRss, _isolateReceivePort.sendPort);

      _isolateReceivePort.listen((dynamic message) {
        _rssNewsList.clear();
        _rssNewsList.addAll(message);

        _isolateReceivePort.close();
        _rssIsolate.kill();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void disposeRssNews() {
    _timer.cancel();
  }

  static void fetchRss(SendPort sendPort) async{
    var result = <RssMessage>[];
    var response =
    await http.get(Uri.parse('https://cryptocurrency.tech/feed/'));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body.toString());
      final titles = document.findAllElements('item');
      titles.map((node) => RssMessage(node.findElements('title').first.text, node.findElements('description').first.text)).forEach(result.add);
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
    sendPort.send(result);
  }
}
