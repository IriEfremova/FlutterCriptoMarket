import 'package:cripto_market/app/core/database/database.dart';
import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:mobx/mobx.dart';

class FavoritesStoreBase {
  late final DatabaseInstance _databaseInstance;
  final _favoritesList = ObservableList<AssetsPair>();
  late AssetsPair _currentAssetsPair;

  FavoritesStoreBase(this._databaseInstance) {
    _loadFavoritesList();
  }

  get currentAssetsPair => _currentAssetsPair;
  get favoritesList => _favoritesList;

  void setCurrentAssetsPair(AssetsPair value) {
    _currentAssetsPair = value;
  }

  void _loadFavoritesList() async {
    await _databaseInstance.initDB();
    print('_loadFavoritesList');
    final listFromDB = await _databaseInstance.getAllAssetsPairs();
    print('_loadFavoritesList ${listFromDB.toString()}');
    _favoritesList.addAll(listFromDB);
  }

  @action
  void addToFavorites(AssetsPair assetsPair) {
    _favoritesList.add(assetsPair);
    _databaseInstance.insertAssetsPairInfo(assetsPair);
  }

  @action
  void removeFromFavorites(AssetsPair assetsPair) {
    _favoritesList.remove(assetsPair);
    _databaseInstance.deleteAssetsPair(assetsPair);
  }

  bool isFavorite(AssetsPair assetsPair) => _favoritesList.contains(assetsPair);
}
