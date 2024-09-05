import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required this.dio});

  final Dio dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the error
    debugPrint('[Request Error]: |> ${err.requestOptions.uri}');
    debugPrint(
        '[Error Message]: |> ${err.response?.statusCode} ${err.message}');
    handler.next(err);
  }
}
