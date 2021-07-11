import 'package:cripto_market/app/core/model/assets_pair.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInstance {
  //DBProvider._();

 /// static final DBProvider db = DBProvider._();

  late Database _database;

/*
  Future<Database> get databaseInstance async {
    print('databaseInstance0');
    if (_database != null) {
      print('databaseInstance1');
      return _database;
    }
    print('databaseInstance2');
    _database = await initDB();
    return _database;
  }
*/

  DatabaseInstance(){
    print('constructor Database');
      //initDB();
  }

  initDB() async {
    print('initDb0');
    var databasesPath = await getDatabasesPath();
    print('initDb1 ${databasesPath}');
    String path = join(databasesPath, 'CriptoDB.db');
    print('initDb2 ${path}');
    // open the database
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Assetpairs (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, min_price REAL, max_price REAL)');
        });
    print('InitDb3 ${_database.isOpen.toString()}');

  }

  Future<List<AssetsPair>> getAllAssetsPairs() async {
    //final db = await databaseInstance;
    var res = await _database.query("Assetpairs");
    List<AssetsPair> list =
    res.isNotEmpty ? res.map((c) => AssetsPair.fromMap(c)).toList() : [];
    return list;
  }

  //Записываем данные по валюте в БД
  insertAssetsPairInfo(AssetsPair assetsPair) async {
    await _database.transaction((txn) async {
      int id2 = await txn.rawInsert(
          'INSERT INTO Assetpairs(name, min_price, max_price) VALUES(?, ?, ?)',
          [assetsPair.name, assetsPair.minPrice, assetsPair.maxPrice]);
      print('inserted2: $id2');
    });
  }

  //Удаляем данные по валюте из БД
  deleteAssetsPair(AssetsPair assetsPair) async {
    final count = await _database
        .rawDelete('DELETE FROM Assetpairs WHERE name = ?', [assetsPair.name]);
    assert(count == 1);
  }

  //Обновляем данные по валюте в БД
  updateAssetsPair(AssetsPair assetsPair) async {
    final count = await _database.rawUpdate(
        'UPDATE Assetpairs SET name = ?, min_price = ?, max_price = ? WHERE name = ?',
        [assetsPair.name, assetsPair.minPrice, assetsPair.maxPrice]);
    print('updated: $count');
  }

  closeDatabase() async {
    await _database.close();
  }
}
