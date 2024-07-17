import 'package:sqflite/sqflite.dart';
import 'package:link/data/database/utils.dart';

class TableCreator {
  static final List<String> _tables = [];

  static Future<void> createTables(Database db) async {
    for (var table in _tables) {
      await db.execute(table);
    }
  }

  static Future<void> updateTables(Database db) async {
    for (var table in _tables) {
      await db.execute(table);
      // UPDATE QUERY
    }
  }
}
