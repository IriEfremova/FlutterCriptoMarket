import 'package:flutter/cupertino.dart';

@immutable
class UserEvent {
  //Наименование валюты
  final String nameAssets;
  final int dateTime;
  final String event;

  UserEvent(this.nameAssets, this.dateTime, this.event);

  factory UserEvent.fromMap(Map<String, dynamic> map) => UserEvent(
    map['nameassets'],
    map['datetime'],
    map['event'],
  );
}
