import 'package:cripto_market/app/core/database/database.dart';
import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:mobx/mobx.dart';

class FavoritesStore {
  final DatabaseInstance _databaseInstance;
  final _favoritesList = ObservableList<AssetsPair>();
  late AssetsPair _currentAssetsPair;

  get favoritesList => _favoritesList;
  get assetsPair => _currentAssetsPair;

  void choseAssetsPair(AssetsPair value) {
    _currentAssetsPair = value;
  }

  FavoritesStore(this._databaseInstance) {
    _loadFavoritesList();

  }

  void _loadFavoritesList() async {
    final listFromDB = await _databaseInstance.getAllAssetsPairs();
    _favoritesList.addAll(listFromDB);
    _favoritesList.sort();
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

  @action
  void updateFavoritesMinPrice(AssetsPair assetsPair) {
    _databaseInstance.updateAssetsPairMinPrice(assetsPair);
    _favoritesList.remove(assetsPair);
    _favoritesList.add(assetsPair);
    _favoritesList.sort();
  }

  @action
  void updateFavoritesMaxPrice(AssetsPair assetsPair) {
    _databaseInstance.updateAssetsPairMaxPrice(assetsPair);
    _favoritesList.remove(assetsPair);
    _favoritesList.add(assetsPair);
    _favoritesList.sort();
  }

  bool isFavorite(AssetsPair assetsPair) => _favoritesList.contains(assetsPair);

}
