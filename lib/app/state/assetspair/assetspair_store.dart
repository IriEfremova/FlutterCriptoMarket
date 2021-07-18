import 'package:cripto_market/app/core/model/assets_pair.dart';

class AssetsPairStore {
  AssetsPairStore();

  late AssetsPair _assetsPair;

  get assetsPair => _assetsPair;

  void choseAssetsPair(AssetsPair value) {
    print('choseAssetsPair ${value.name}');
    _assetsPair = value;
  }
}