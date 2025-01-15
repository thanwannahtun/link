import 'dart:async';
import 'package:link/data/database/crud_table.dart';
import 'package:link/data/database/utils.dart';
import 'package:link/models/user.dart';

class UserRepo {
  static final UserRepo _instance = UserRepo._();
  final CRUDTable _crudTable = CRUDTable.instance;

  UserRepo._();

  factory UserRepo() => _instance;

  FutureOr<User> getCurrentUser() async {
    try {
      List<Map<String, dynamic>> users = await _crudTable.readData(Table.user);
      return User.fromJson(users.first);
    } catch (e) {
      return const User();
    }
  }

  FutureOr<void> insertUser(User user) async {
    await _crudTable.insertData(Table.user, user.toJson());
  }

  FutureOr<void> deleteUser() async {
    /// notice delete all user data
    await _crudTable.deleteData(Table.user);
  }
}
