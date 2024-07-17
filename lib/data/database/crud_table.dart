import 'package:sqflite/sqflite.dart';
import 'package:link/data/database/base_db_helper.dart';

/// for [CRUD] operations
class CRUDTable {
  final BaseDBHelper _helper = BaseDBHelper.instance;
  late Database _db;

  CRUDTable._();
  static final CRUDTable instance = CRUDTable._();
  Future<void> _getDatabase() async {
    _db = await _helper.database;
  }

  Future<Map<String, dynamic>> getDataById(String table, int id,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    await _getDatabase();
    List<Map<String, dynamic>> dataLists = await _db.query(table);
    return dataLists.elementAt(id);
  }

  /// for usual [CRUD] operations
  Future<List<Map<String, dynamic>>> readData(String table,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    await _getDatabase();
    return _db.query(table,
        columns: columns,
        distinct: distinct,
        where: where,
        whereArgs: whereArgs,
        offset: offset,
        orderBy: orderBy,
        groupBy: groupBy,
        limit: limit,
        having: having);
  }

  // Future<int> getDataById ()

  Future<int> updateData(
      {required String table,
      required Map<String, Object?> values,
      String? where,
      List<Object?>? whereArgs}) async {
    await _getDatabase();
    return _db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteData(String table,
      {String? where, List<Object?>? whereArgs}) async {
    await _getDatabase();
    return _db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> insertData(String table, Map<String, Object?> values,
      {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async {
    await _getDatabase();
    return _db.insert(table, values);
  }

  /// for specific raw [CRUD] operations
  Future<List<Map<String, Object?>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    await _getDatabase();
    return _db.rawQuery(sql, arguments);
  }

  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    await _getDatabase();
    return await _db.rawDelete(sql, arguments);
  }

  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    await _getDatabase();
    return _db.rawUpdate(sql, arguments);
  }

  Future<int> rawInsert(String sql, [List<Object?>? arguments]) async {
    await _getDatabase();
    return _db.rawInsert(sql, arguments);
  }

  Future<T> insertByTransition<T>(Future<T> Function(Transaction) action,
      {bool? exclusive}) async {
    await _getDatabase();
    return _db.transaction<T>(action, exclusive: exclusive);
  }

  insertByBatch<T>(Future<T> Function(Batch) action) async {
    await _getDatabase();
    Batch batch = _db.batch();
    await action(batch);
  }
}
