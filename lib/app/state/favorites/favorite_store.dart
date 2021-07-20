import 'package:cripto_market/app/core/database/database.dart';
import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:mobx/mobx.dart';

class FavoritesStore {
  final DatabaseInstance _databaseInstance;
  final _favoritesList = ObservableList<AssetsPair>();
  late AssetsPair _currentAssetsPair;

  ObservableList<AssetsPair> get favoritesList => _favoritesList;

  AssetsPair get assetsPair => _currentAssetsPair;

  void choseAssetsPair(AssetsPair value) {
    _currentAssetsPair = value;
  }

  FavoritesStore(this._databaseInstance) {
    _loadFavoritesList();
  }

  Future<void> _loadFavoritesList() async {
    final listFromDB = await _databaseInstance.getAllAssetsPairs();
    _favoritesList.addAll(listFromDB);
    _favoritesList.sort();
  }

  bool checkMinBorderPrice(AssetsPair assetsPair) {
    if (assetsPair.minPrice == -1) return false;
    if (assetsPair.realPrice <= assetsPair.minPrice) {
      return true;
    }
    else {
      return false;
    }
  }

  bool checkMaxBorderPrice(AssetsPair assetsPair) {
    if (assetsPair.maxPrice == -1) return false;
    if (assetsPair.realPrice >= assetsPair.maxPrice) {
      return true;
    }
    else {
      return false;
    }
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
