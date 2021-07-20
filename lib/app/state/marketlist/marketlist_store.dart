import 'dart:async';
import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:mobx/mobx.dart';

part 'marketlist_store.g.dart';

class MarketListStore = _MarketListStoreBase with _$MarketListStore;

abstract class _MarketListStoreBase with Store {
  late StreamController<List<AssetsPair>> _controller;
  Timer? _timer;

  final WebServiceAPI _webService;
  final _searchText = Observable('');

  _MarketListStoreBase(this._webService) {
    _controller = StreamController<List<AssetsPair>>.broadcast(
        onListen: startTimer, onCancel: stopTimer);
  }

  Future<void> tick(_) async {
    final map = await _webService.fetchTradePairsPrice();
    if (_searchText.value.isEmpty) {
      _controller.add(map);
    } else {
      var newList = <AssetsPair>[];
      newList = List.from(map.where((element) =>
          element.name.contains(_searchText.value.toUpperCase())));
      _controller.add(newList);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), tick);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @action
  void setSearchText(String value) {
    _searchText.value = value;
  }

  Stream<List<AssetsPair>> get filteredList => _controller.stream;

  void disposeMarketStore() {
    _timer?.cancel();
    _controller.close();
  }
}
