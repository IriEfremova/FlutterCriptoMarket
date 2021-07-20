import 'package:cripto_market/app/core/model/assets_ticker.dart';

class WebSocketResponse {
  String getServerStatus(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    if (result.containsKey('status')) {
      return 'Status: ${result['status'].toString()}';
    } else {
      return 'n/a';
    }
  }

  Map<String, String> getAssetsPairsPrice(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    var newMap = <String, String>{};
    for (var i = 0; i < result.length; i++) {
      var ticker = AssetsTicker.fromJson(result.values.elementAt(i));
      newMap[result.keys.elementAt(i)] = ticker.ask.first;
    }
    return newMap;
  }

  Iterable<dynamic> getAssets(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    var newList = <String>[];
    newList = List.from(result.keys.map((e) => e));
    return newList;
  }

  Map<String, String> getAssetsInfo(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    var newMap = <String, String>{};

    result.forEach((key, value) {
      newMap[key] = 'PI_${value['altname'].toString()}';
    });
    return newMap;
  }
}
