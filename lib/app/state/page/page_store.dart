import 'package:mobx/mobx.dart';

part 'page_store.g.dart';

class PageStore = _PageStoreBase with _$PageStore;

abstract class _PageStoreBase with Store {
  _PageStoreBase();

  final _currentPage = Observable(0);

  int get currentPage => _currentPage.value;

  @action
  void setCurrentPage(int value) {
    _currentPage.value = value;
  }

}