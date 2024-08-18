import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:link/data/database/table_creator.dart';

class BaseDBHelper {
  final String _dbName = 'link_myanmar.db';
  final int _dbVersion = 1;

  Database? _database;
  BaseDBHelper._(); //  private constructor
  static final BaseDBHelper instance = BaseDBHelper._();
  factory BaseDBHelper() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      // debugPrint('----------> database already exists!');
      return _database!;
    }
    // debugPrint('-------------> database initialized !');
    _database = await _createDatabase();
    return _database!;
  }

  Future<Database> _createDatabase() async {
    final String location = await getDatabasesPath();
    final String path = join(location, _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await TableCreator.createTables(db);
  }

  /// [Upgrade]
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await TableCreator.updateTables(db);
  }
}
