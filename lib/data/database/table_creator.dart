import 'package:sqflite/sqflite.dart';
import 'package:link/data/database/utils.dart';

class TableCreator {
  static final List<String> _tables = [
    """
    CREATE TABLE IF NOT EXISTS ${Table.user} (
      ${Column.id} INTEGER PRIMARY KEY,
      ${Column.firstName} TEXT NOT NULL,
      ${Column.lastName} TEXT,
      ${Column.email} TEXT NOT NULL UNIQUE,
      ${Column.role} TEXT NOT NULL,
      ${Column.accessToken} TEXT,
      ${Column.refreshToken} TEXT
    )
    """
  ];

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
