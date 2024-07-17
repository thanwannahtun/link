import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/app.dart';
import 'package:link/models/user.dart';

class AuthenticationRepo {
  static final AuthenticationRepo _instance = AuthenticationRepo._();

  AuthenticationRepo._();

  factory AuthenticationRepo() => _instance;

  FutureOr<User> signUpUser({required User user}) async {
    try {
      Response response =
          await ApiService().postRequest('/auth/sign_up', user.toJson());
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data['data']);
        _checkToken(user);
        App.user = user;
        return App.user;
      } else {
        throw Exception(response.data['message'] ?? "Error Signing Up user!");
      }
    } catch (e) {
      debugPrint("Error Signing Up $e");

      throw Exception(e);
    }
  }

  void _checkToken(User user) {
    if (user.accessToken == null && user.refreshToken == null) {
      throw Exception("Authentication Failed ( Invalid Token )");
    }
  }

  FutureOr<User> signInUser({required User user}) async {
    try {
      Response response =
          await ApiService().postRequest('/auth/sign_in', user.toJson());
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data['data']);
        _checkToken(user);
        App.user = user;
        return App.user;
      }
      throw Exception(response.data['message'] ?? "Error Signing In user!");
    } catch (e) {
      debugPrint("Error Signing In $e");
      throw Exception(e);
    }
  }
}
