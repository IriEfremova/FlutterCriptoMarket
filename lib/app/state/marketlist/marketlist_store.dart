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
 // final _marketList = ObservableList<AssetsPair>();
 // final _marketList = <AssetsPair>[];
  final _searchText = Observable('');

  _MarketListStoreBase(this._webService) {
    print('_MarketListStoreBase');
    StreamController.broadcast();
    _controller = StreamController<List<AssetsPair>>.broadcast(
        onListen: startTimer,
        //onPause: stopTimer,
        //onResume: startTimer,
        onCancel: stopTimer);
  }

  Future<void> tick(_) async {
    final map = await _webService.fetchTradePairsPrice();
    print('_loadMap00 ${map.length}');
    //_marketList.clear();
  //  _marketList.addAll(map);
    _controller.add(map);
  }

  void startTimer() {
    print('stratTimer');
    _timer = Timer.periodic(Duration(seconds: 3), tick);
  }

  void stopTimer() {
    print('stopTimer');
    _timer?.cancel();
    _timer = null;
    //_controller.close();
  }


  @action
  void setSearchText(String value) {
    _searchText.value = value;
  }

/*  Future<List<AssetsPair>> _loadMap() async {
    if (_marketList.isEmpty) {
      final map = await _webService.fetchTradePairsPrice();
      print('_loadMap00 ${map.length}');
      _marketList.clear();
      _marketList.addAll(map);
      print('_loadMap11 ${_marketList.length}');
    }
    return _marketList;
  }*/

 // get marketList => _marketList;
  Stream<List<AssetsPair>> get filteredList => _controller.stream;

/*  Future<List<AssetsPair>> getFilteredList() async {
    print('getFilteredList ${_marketList.length}');
    var newList = <AssetsPair>[];
    newList = List.from(_marketList.where((element) =>
        element.name.contains(_searchText.value.toUpperCase())));

    print('getFilteredList ${newList.toString()}');
    return Future.value(newList);
  }*/

/*  Stream<List<AssetsPair>> get filteredList {
    //if (_searchText.value.isEmpty) return _loadMap();
    //return getFilteredList();
  }*/

  disposeMarketStore(){
    _timer?.cancel();
    _controller.close();
  }
}
