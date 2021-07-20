import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/repository/websocket_response.dart';
import 'package:http/http.dart' as http;

class WebServiceAPI {
  http.Client client;
  WebServiceAPI(this.client);

  Future<String> fetchStatusServer() async {
    late String result;
    final response = await client
        .get(Uri.parse('https://api.kraken.com/0/public/SystemStatus'));
    if (response.statusCode == 200) {
      result = WebSocketResponse()
          .getServerStatus(convert.jsonDecode(response.body));
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
    return result;
  }

  Future<List<AssetsPair>> fetchTradePairsPrice() async {
    var result = <AssetsPair>[];
    var pairs = <String, String>{};
    var response =
        await client.get(Uri.parse('https://api.kraken.com/0/public/AssetPairs'));

    if (response.statusCode == 200) {
      pairs =
          WebSocketResponse().getAssetsInfo(convert.jsonDecode(response.body));
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }

    pairs.forEach((key, value) {
      result.add(AssetsPair.fromServer(key, value));
    });
    final strPairs = pairs.keys.join(',');

    response = await client.get(
        Uri.parse('https://api.kraken.com/0/public/Ticker?pair=$strPairs'));

    if (response.statusCode == 200) {
      final newMap = WebSocketResponse()
          .getAssetsPairsPrice(convert.jsonDecode(response.body));

      for (var element in result) {
        if (newMap.containsKey(element.name)) {
          element.realPrice = double.tryParse(newMap[element.name]!)!;
        }
      }
    } else {
      throw HttpException('Request failed with status: ${response.statusCode}');
    }
    return result;
  }
}
