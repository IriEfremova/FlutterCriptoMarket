import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInstance {
  late Database _database;

  DatabaseInstance._privateConstructor() ;

  static final DatabaseInstance _instance =
      DatabaseInstance._privateConstructor();

  factory DatabaseInstance() {
    return _instance;
  }

  Future<void> initDB() async {
    print('initDB');
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'CriptoDB.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Assetpairs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, piname TEXT, min_price REAL, max_price REAL);'
          'CREATE TABLE Userevents (id INTEGER PRIMARY KEY AUTOINCREMENT, nameassets TEXT, datetime INTEGER, event TEXT)');
    });
  }

  Future<List<UserEvent>> getAllUserEvents() async {
    var res = await _database.query('Userevents');
    var list = <UserEvent>[];
    list = res.isNotEmpty ? res.map((c) => UserEvent.fromMap(c)).toList() : [];
    return list;
  }

  //Записываем данные по событиям
  void insertUserEvent(UserEvent userEvent) async {
    await _database.transaction((txn) async {
      var id2 = await txn.rawInsert(
          'INSERT INTO Userevents(nameassets, datetime, event) VALUES(?, ?, ?)',
          [userEvent.nameAssets, userEvent.dateTime, userEvent.event]);
      print('inserted: $id2');
    });
  }

  //Удаляем данные по событиям
  void clearUserEvents() async {
    final count = await _database.rawDelete('DELETE FROM Userevents');
    print('deleted: $count');
  }

  Future<List<AssetsPair>> getAllAssetsPairs() async {
    var res = await _database.query('Assetpairs');
    var list = <AssetsPair>[];
    list = res.isNotEmpty ? res.map((c) => AssetsPair.fromMap(c)).toList() : [];
    return list;
  }

  //Записываем данные по валюте в БД
  void insertAssetsPairInfo(AssetsPair assetsPair) async {
    await _database.transaction((txn) async {
      var id2 = await txn.rawInsert(
          'INSERT INTO Assetpairs(name, piname, min_price, max_price) VALUES(?, ?, ?, ?)',
          [
            assetsPair.name,
            assetsPair.piName,
            assetsPair.minPrice,
            assetsPair.maxPrice
          ]);
      print('inserted: $id2');
    });
  }

  //Удаляем данные по валюте из БД
  void deleteAssetsPair(AssetsPair assetsPair) async {
    final count = await _database
        .rawDelete('DELETE FROM Assetpairs WHERE name = ?', [assetsPair.name]);
    assert(count == 1);
  }

  //Обновляем данные по валюте в БД
  void updateAssetsPairMinPrice(AssetsPair assetsPair) async {
    final count = await _database.rawUpdate(
        'UPDATE Assetpairs SET min_price = ? WHERE name = ?',
        [assetsPair.minPrice, assetsPair.name]);
    print('updated: $count');
  }

  //Обновляем данные по валюте в БД
  void updateAssetsPairMaxPrice(AssetsPair assetsPair) async {
    final count = await _database.rawUpdate(
        'UPDATE Assetpairs SET max_price = ? WHERE name = ?',
        [assetsPair.maxPrice, assetsPair.name]);
    print('updated: $count');
  }

  void closeDatabase() async {
    await _database.close();
  }
}
