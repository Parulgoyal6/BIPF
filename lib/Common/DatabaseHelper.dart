import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as dbPath;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/adding_an_activity.dart';
import '../Models/adding_an_event.dart';
import '../Models/adding_beneficiary.dart';
class DatabaseHelper {
  static Database? _database;
  static const String _dbName = "bipf.db";
  static const int _dbVersion = 1;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

   Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = dbPath.join(documentsDirectory.path, _dbName);

    _database = await openDatabase(
     path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Example table creation
    await db.execute(AddingAnEvent.createTable);
    await db.execute(AddingAnActivity.createTable);
    await db.execute(BeneficiaryModel.createTable);


  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Example upgrade logic
      // await db.execute("ALTER TABLE client ADD COLUMN others TEXT DEFAULT '0'");
    }
  }

  Future<int> saveMasterTable(String table, List<Map<String, dynamic>> dataList) async {
    final db = await database;
    int result = 0;

    try {
      await db.transaction((txn) async {
        for (var data in dataList) {
          await txn.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
          result++;
        }
      });
    } catch (e) {
      debugPrint("Error saving data to $table: $e");
    }

    return result;
  }

  Future<int> truncateTable(String tableName) async {
    final db = await database;

    try {
      return await db.delete(tableName);
    } catch (e) {
      debugPrint("Error truncating table $tableName: $e");
      return 0;
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
Future<int>AddingEventData(Map<String, dynamic>mapList, String table)async{

    Database? db =  await database;
    return await db!.insert(table, mapList);
}

  Future<List<AddingAnEvent>> getAddingAnEvent(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => AddingAnEvent.fromMap(f)).toList();
  }
Future<List<AddingAnActivity>> getAddingAnActivity(String query) async {
    final db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery(query);
    return resultMap.map((f) => AddingAnActivity.fromMap(f)).toList();
  }

}
