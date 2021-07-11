import 'package:mobx/mobx.dart';

class AssetsPairStore with Store {
  AssetsPairStore();

  final _currentAssetsPair = Observable('');

  get currentAssetsPair => _currentAssetsPair.value;

  @action
  void setCurrentAssetsPair(String value) {
    _currentAssetsPair.value = value;
  }

}