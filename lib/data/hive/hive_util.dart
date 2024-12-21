import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HiveUtil {
  /// Cache to keep track of already open boxes
  final Map<String, Box> _openBoxes = {};

  Future<Box<T>> _openBox<T>(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      if (kDebugMode) {
        print("$boxName is already opened.");
      }
      // Return the already open box
      return _openBoxes[boxName] as Box<T>;
    }
    if (kDebugMode) {
      print("$boxName is opened.");
    }

    // Open the box and store it in the cache
    final box = await Hive.openBox<T>(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  // openBox<T>({required String boxName}) async {
  //   await _openBox<T>(boxName);
  // }
  //
  // Future<Box<T>> _openBox<T>(String boxName) async {
  //   return await Hive.openBox<T>(
  //     boxName,
  //   );
  // }

  Future<void> addValue<T>(String boxName, T value, dynamic key) async {
    final box = await _openBox<T>(boxName);

    await box.put(key, value);
  }

  Future<void> updateValue<T>(String boxName, T value, dynamic key) async {
    final box = await _openBox<T>(boxName);
    await box.put(key, value);
  }

  /// This method checks if a particular key exists in the box
  Future<bool> containsKey<T>(String boxName, dynamic key) async {
    final box = await _openBox<T>(boxName);
    return box.containsKey(key);
  }

  /// This method retrieves all keys in the box
  Future<List<dynamic>> getAllKeys<T>(String boxName) async {
    final box = await _openBox<T>(boxName);
    return box.keys.toList();
  }

  /// This method allows deleting multiple values by their keys
  Future<void> deleteMultipleValues<T>(
      String boxName, List<dynamic> keys) async {
    final box = await _openBox<T>(boxName);
    await box.deleteAll(keys);
  }

  /// This method returns the total number of values in the box
  Future<int> getCount<T>(String boxName) async {
    final box = await _openBox<T>(boxName);
    return box.length;
  }

  /// This method retrieves a subset of values by a list of keys.
  Future<List<T?>> getValuesByKeys<T>(
      String boxName, List<dynamic> keys) async {
    final box = await _openBox<T>(boxName);
    return keys.map((key) => box.get(key)).toList();
  }

  Future<int> clearAllValues<T>({required String boxName}) async {
    final box = await _openBox<T>(boxName);
    return await box.clear();
  }

  /// return the number of deleted entries
  Future<List<T>> getAllValues<T>(String boxName) async {
    final box = await _openBox<T>(boxName);
    return box.values.toList();
  }

  Future<T?> getValueByKey<T>(String key,
      {required String boxName, T? defaultValue}) async {
    final box = await _openBox<T>(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> deleteValue<T>(String key, {required String boxName}) async {
    final box = await _openBox<T>(boxName);
    await box.delete(key);
  }

/*
In Hive, "closing a box" refers to releasing the resources associated with a specific box. 
When you open a box using Hive.openBox(), Hive keeps it open in memory for fast access. 
Closing a box helps manage memory and resource usage, 
especially if the box is no longer needed or if you're performing cleanup operations.
 */
  void closeBox(String boxName) async {
    await Hive.box(boxName).close();
  }
}
