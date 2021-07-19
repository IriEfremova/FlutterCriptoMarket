import 'dart:convert' as convert;
import 'package:cripto_market/app/core/model/assets_ticker.dart';

class WebSocketResponse {
  String getServerStatus(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    if (result.containsKey('status')) {
      return 'Status: ${result['status'].toString()}';
    } else
      return 'n/a';
  }

  Map<String, String> getAssetsPairsPrice(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    print('getAssetsPairsPrice = $result');
    var newMap = Map<String, String>();
    for (int i = 0; i < result.length; i++) {
      AssetsTicker ticker = AssetsTicker.fromJson(result.values.elementAt(i));
      newMap['${result.keys.elementAt(i)}'] = ticker.a.first;
    }
    newMap.forEach((key, value) {
      if (key.contains('XBTUSD')) print('key $key');
    });

    print('getAssetsPairsPrice = $newMap');
    return newMap;
  }

  Iterable<dynamic> getAssets(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    var newList = <String>[];

    result.keys.forEach((element) {
      if (element.contains('XBTUSD')) print('element00 $element');
    });

    newList = List.from(result.keys.map((e) => e));
    newList.forEach((element) {
      if (element.contains('XBTUSD')) print('element11 $element');
    });
    print('getAssetsPairs = ${newList.toString()}');
    return newList;
  }

  Map<String, String> getAssetsInfo(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    var newMap = Map<String, String>();
    print('getAssetsInfo00 ${result.toString()}');

    result.forEach((key, value) {
      newMap[key] = 'PI_${value['altname'].toString()}';
    });
    print('getAssetsInfo11 ${newMap.toString()}');
    return newMap;
  }

  double getLastPrice(String data) {
    Map<String, dynamic> json = convert.jsonDecode(data);
    if (json.containsKey('ask'))
      return json['ask'];
    else
      return -1;
  }

  double getAssetsPairInfo(String data) {
    Map<String, dynamic> json = convert.jsonDecode(data);
    if (json.containsKey('ask'))
      return json['ask'];
    else
      return -1;
  }
}
