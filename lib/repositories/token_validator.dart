import 'dart:async';

import 'package:link/models/user.dart';
import 'package:link/repositories/user.dart';

class TokenValidatorRepo {
  static final TokenValidatorRepo _instance = TokenValidatorRepo._();

  TokenValidatorRepo._();

  factory TokenValidatorRepo() => _instance;

  FutureOr<bool> tokenExpired() async {
    User user = await UserRepo().getCurrentUser();
    return user.accessToken != null && user.refreshToken != null;
  }
}
