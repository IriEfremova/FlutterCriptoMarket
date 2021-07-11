import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:cripto_market/app/core/model/websocket_response.dart';
import 'package:http/http.dart' as http;

class WebServiceAPI {
  Future<String> fetchStatusServer() async {
    late String result;
    final response = await http
        .get(Uri.parse('https://api.kraken.com/0/public/SystemStatus'));
    if (response.statusCode == 200) {
      result = WebSocketResponse()
          .getServerStatus(convert.jsonDecode(response.body));
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
    return result;
  }

  Future<Iterable<String>> fetchTradePairs() async {
    var result = <String>[];
    var response =
        await http.get(Uri.parse('https://api.kraken.com/0/public/AssetPairs'));

    if (response.statusCode == 200) {
      result = WebSocketResponse()
          .getAssetsPairs(convert.jsonDecode(response.body)) as List<String>;
      print('222 ${result}');
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
    return result;
  }

  WebServiceAPI() {
    print('constructor WebServiceAPI');
  }
}
