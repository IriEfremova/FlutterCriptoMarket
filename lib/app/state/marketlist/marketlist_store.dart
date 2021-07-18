import 'package:cripto_market/app/core/database/database.dart';
import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/repository/web_channel_api.dart';
import 'package:cripto_market/app/core/repository/web_service_api.dart';
import 'package:mobx/mobx.dart';

part 'marketlist_store.g.dart';

class MarketListStore = _MarketListStoreBase with _$MarketListStore;

abstract class _MarketListStoreBase with Store {
  final WebServiceAPI _webService;
  final _marketList = ObservableList<AssetsPair>();
  final _searchText = Observable('');

  _MarketListStoreBase(this._webService);

  @action
  void setSearchText(String value) {
    _searchText.value = value;
  }

  Future<List<AssetsPair>> _loadMap() async {
    if (_marketList.isEmpty) {
      final map = await _webService.fetchTradePairsPrice();
      print('_loadMap00 ${map.length}');
      _marketList.clear();
      _marketList.addAll(map);
      print('_loadMap11 ${_marketList.length}');
    }
    return _marketList;
  }

  get marketList => _marketList;

  Future<List<AssetsPair>> getFilteredList() async {
    print('getFilteredList ${_marketList.length}');
    var newList = <AssetsPair>[];
    newList = List.from(_marketList.where((element) =>
        element.name.contains(_searchText.value.toUpperCase())));

    print('getFilteredList ${newList.toString()}');
    return Future.value(newList);
  }

  Future<List<AssetsPair>> get filteredList {
    if (_searchText.value.isEmpty) return _loadMap();
    return getFilteredList();
  }
}
