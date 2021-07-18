class UserEvent {
  //Наименование валюты
  String _nameAssets;
  int _dateTime;
  String _event;

  String get nameAssets => _nameAssets;
  int get dateTime => _dateTime;
  String get event => _event;

  UserEvent(this._nameAssets, this._dateTime, this._event);

  factory UserEvent.fromMap(Map<String, dynamic> map) => new UserEvent(
    map["nameassets"],
    map["datetime"],
    map["event"],
  );
}
