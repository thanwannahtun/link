import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/repositories/token_validator.dart';

class TokenValidatorCubit extends Cubit<bool> {
  TokenValidatorCubit() : super(true);

  checkTokenExpiration() async {
    try {
      bool notExpired = await TokenValidatorRepo().tokenExpired();
      emit(!notExpired);
    } on DioException catch (e) {
      debugPrint(ApiErrorHandler.handle(e).message);
      emit(true);
    } catch (e) {
      emit(true);
    }
  }
}
