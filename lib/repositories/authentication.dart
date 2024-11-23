import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/app.dart';
import 'package:link/models/user.dart';

class AuthenticationRepo extends ApiService {
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

  Future<Response> sendCode(
      {required String email, bool resend = false}) async {
    try {
      final body = {"email": email};
      final path =
          resend ? "/auth/sign_up/resend_code" : "/auth/sign_up/send_code";
      return await postRequest(path, body);
    } catch (e) {
      debugPrint("Error Getting Email Code : $e");
      throw Exception(e);
    }
  }

  Future<Response> verifyCode(
      {required String email, required String code}) async {
    try {
      final body = {"email": email, "code": code};
      return await postRequest("/auth/sign_up/verify_code", body);
    } catch (e) {
      debugPrint("Error Verifing Email Code : $e");
      throw Exception(e);
    }
  }
}
