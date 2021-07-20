import 'package:cripto_market/app/core/database/database.dart';
import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:mobx/mobx.dart';

part 'userevents_store.g.dart';

class UserEventsStore = _UserEventsStoreBase with _$UserEventsStore;

abstract class _UserEventsStoreBase with Store {
  final DatabaseInstance _databaseInstance;
  final _eventsList = ObservableList<UserEvent>();

  List<String> get userEventsList {
    var list = <String>[];

    for (var element in _eventsList) {
      list.add(
          '${DateTime.fromMillisecondsSinceEpoch(element.dateTime)}: ${element.event}. ${element.nameAssets}');
    }
    return list;
  }

  int currentTimeInSeconds() {
    var ms = (DateTime.now()).millisecondsSinceEpoch;
    return ms;
  }

  _UserEventsStoreBase(this._databaseInstance) {
    _loadEventsList();
  }

  void _loadEventsList() async {
    final listFromDB = await _databaseInstance.getAllUserEvents();
    _eventsList.addAll(listFromDB);
  }

  @action
  void addToUserEvents(UserEvent userEvent) {
    _eventsList.add(userEvent);
    _databaseInstance.insertUserEvent(userEvent);
  }

  @action
  void removeFromUserEvents() {
    _eventsList.clear();
    _databaseInstance.clearUserEvents();
  }
}
