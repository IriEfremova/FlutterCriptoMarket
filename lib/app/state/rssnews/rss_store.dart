import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:cripto_market/app/core/repository/rss_servise.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RssStore {
  late Isolate _rssIsolate;
  late ReceivePort _isolateReceivePort;

  final _rssNewsList = ObservableList<RssMessage>();
  late Timer _timer;

  get rssNewsList => _rssNewsList;

  RssStore() {
    spawnRssIsolate();
    _timer = Timer.periodic(Duration(minutes: 1), (t) async {
      spawnRssIsolate();
    });
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

  disposeRssNews() {
    _timer.cancel();
  }
}
