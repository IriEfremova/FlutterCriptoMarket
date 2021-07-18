import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RssMessage{
  String _title;
  String _description;

  String get title => _title;
  String get description => _description;

  RssMessage(this._title, this._description);
}

class RssService {
  Future<Iterable<RssMessage>> fetchRssNews() async {
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
    return result;
  }
}