import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:cripto_market/app/core/model/user_event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseInstance {
  bool _isInitialize = false;
  late Database _database;

  DatabaseInstance._privateConstructor() ;

  static final DatabaseInstance _instance =
      DatabaseInstance._privateConstructor();

  factory DatabaseInstance() {
    return _instance;
  }

  Future<Database> get database async {
    if (_isInitialize) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'CriptoDB.db');
    _isInitialize = true;
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Assetpairs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, piname TEXT, min_price REAL, max_price REAL)');
      await db.execute(
          'CREATE TABLE Userevents (id INTEGER PRIMARY KEY AUTOINCREMENT, nameassets TEXT, datetime INTEGER, event TEXT)');
    });
  }

  Future<List<UserEvent>> getAllUserEvents() async {
    final db = await database;
    var res = await db.query("Userevents");
    List<UserEvent> list =
        res.isNotEmpty ? res.map((c) => UserEvent.fromMap(c)).toList() : [];
    return list;
  }

  //Записываем данные по событиям
  insertUserEvent(UserEvent userEvent) async {
    final db = await database;
    await db.transaction((txn) async {
      int id2 = await txn.rawInsert(
          'INSERT INTO Userevents(nameassets, datetime, event) VALUES(?, ?, ?)',
          [userEvent.nameAssets, userEvent.dateTime, userEvent.event]);
      print('inserted: $id2');
    });
  }

  //Удаляем данные по событиям
  clearUserEvents() async {
    final db = await database;
    final count = await db.rawDelete('DELETE FROM Userevents');
    print('deleted: $count');
  }

  Future<List<AssetsPair>> getAllAssetsPairs() async {
    final db = await database;

    var res = await db.query("Assetpairs");
    List<AssetsPair> list =
        res.isNotEmpty ? res.map((c) => AssetsPair.fromMap(c)).toList() : [];
    return list;
  }

  //Записываем данные по валюте в БД
  insertAssetsPairInfo(AssetsPair assetsPair) async {
    final db = await database;
    await db.transaction((txn) async {
      int id2 = await txn.rawInsert(
          'INSERT INTO Assetpairs(name, piname, min_price, max_price) VALUES(?, ?, ?, ?)',
          [assetsPair.name, assetsPair.piName, assetsPair.minPrice, assetsPair.maxPrice]);
      print('inserted: $id2');
    });
  }

  //Удаляем данные по валюте из БД
  deleteAssetsPair(AssetsPair assetsPair) async {
    final db = await database;
    final count = await db
        .rawDelete('DELETE FROM Assetpairs WHERE name = ?', [assetsPair.name]);
    assert(count == 1);
  }

  //Обновляем данные по валюте в БД
  updateAssetsPairMinPrice(AssetsPair assetsPair) async {
    final db = await database;
    final count = await db.rawUpdate(
        'UPDATE Assetpairs SET min_price = ? WHERE name = ?',
        [assetsPair.minPrice, assetsPair.name]);
    print('updated: $count');
  }

  //Обновляем данные по валюте в БД
  updateAssetsPairMaxPrice(AssetsPair assetsPair) async {
    final db = await database;
    final count = await db.rawUpdate(
        'UPDATE Assetpairs SET max_price = ? WHERE name = ?',
        [assetsPair.maxPrice, assetsPair.name]);
    print('updated: $count');
  }

  closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
