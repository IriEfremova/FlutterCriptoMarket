class WebSocketResponse {
  String getServerStatus(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    if (result.containsKey('status')) {
      return 'Status: ${result['status'].toString()}';
    } else
      return 'n/a';
  }

  String getServerTime(Map<String, dynamic> json) {
    if (json.containsKey('time')) {
      return DateTime.fromMicrosecondsSinceEpoch(json['time'] * 1000)
          .toString();
    } else
      return 'n/a';
  }

  Iterable<dynamic> getAssetsPairs(Map<String, dynamic> json) {
    Map<String, dynamic> result = json['result'];
    print('getAssetsPairs = ${result}');
    Map<String, dynamic> data = result as Map<String, dynamic>;
    print('getAssetsPairs = ${data.keys.toString()}');
    return data.keys.toList();
  }

  Map<String, String> getLiteTickerInfo(Map<String, dynamic> json) {
    print('getLiteTickerInfo = ${json}');
    var newMap = Map<String, String>();
    newMap = Map.fromIterable(
        json.keys.where((k) => k == 'product_id' || k == 'ask'),
        key: (k) => k,
        value: (v) => json[v].toString());
    print('getLiteTickerInfo = ${newMap}');
    return newMap;
  }
}
