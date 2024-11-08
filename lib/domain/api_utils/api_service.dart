import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/core/utils/env.dart';
import 'package:link/data/share_preference.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/api_utils/logging_inteceptor.dart';
import 'package:link/domain/api_utils/retry_intercepton.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;
  final String _refreshTokenUrl = '/auth/refresh_token';

  // static const String _baseUrl = 'http://192.7:3000/api/v1';
  // static const String _baseUrl = 'http://192.168.100.7:3000/api';
  // static const String _baseUrl = 'http://192.168.1.11:3000/api/v1';
  // static const String _baseUrl = 'http://192.168.99.217:3000/api/v1';
  static const String _baseUrl = 'http://localhost:3000/api/v1';

  /// Render URL
  // static const String _baseUrl =
  //     "https://link-myanmar-mongodb.onrender.com/api/v1";

  ApiService([baseUrl = _baseUrl])
      : _dio = Dio(
          BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 120),
              receiveTimeout: const Duration(seconds: 120),
              sendTimeout: const Duration(minutes: 2),
              receiveDataWhenStatusError: true,
              responseType: ResponseType.json,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Credentials": true,
                "Access-Control-Allow-Headers":
                    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                "Access-Control-Allow-Methods":
                    'POST, GET, OPTIONS, PUT, DELETE',
              }),
        ) {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    _dio.interceptors.add(LoggingInterceptor(dio: _dio));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add common headers or tokens here
        String? accessToken =
            await SharePreference.instance.getString(Env.accessToken);
        // if (accessToken == null) {}
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle common response behavior
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // Handle common error behavior
        if (e.response?.statusCode == 401 && _shouldRetry(e)) {
          // Attempt to refresh the token
          RequestOptions requestOptions = e.requestOptions;
          try {
            await _refreshToken();
            String? newAccessToken =
                await SharePreference.instance.getString(Env.accessToken);
            requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            final cloneReq = await _dio.request(
              requestOptions.path,
              options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
              ),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );
            return handler.resolve(cloneReq);
          } on DioException catch (e) {
            return handler.next(e);
          }
        } else {
          // I think Inprovement here
          // ApiErrorHandler.handle(e);
          return handler.next(e);
        }

        /// <------ Error Here
        // return handler.next(
        //     ApiErrorHandler.handle(e)); // Handle error using ApiErrorHandler
      },
    ));
  }

  Future<void> _refreshToken() async {
    debugPrint('called refreshToken');
    // Implement your token refresh logic here.
    // This typically involves making a POST request to the refresh token endpoint
    // and updating the stored tokens.
    try {
      String? refreshToken =
          await SharePreference.instance.getString(Env.refreshToken);
      final response = await _dio.post(_refreshTokenUrl, data: {
        'refreshToken': refreshToken,
      });

      // Extract the new token from the response and store it
      String newRefreshToken = response.data['refreshToken']; // token
      // Update the authorization header for subsequent requests
      _dio.options.headers['Authorization'] = 'Bearer $newRefreshToken';

      // You might also want to update the refresh token
      // String newRefreshToken = response.data['refresh_token'];
      // Store the new refresh token securely
      await SharePreference.instance
          .setString(Env.accessToken, newRefreshToken);
    } on DioException catch (e) {
      // Handle error during token refresh
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<Response> getRequest(String path,
      {Map<String, dynamic>? queryParameters, Object? body}) async {
    return await _dio.get(path, queryParameters: queryParameters, data: body);
  }

  Future<Response> postRequest(String path, Object? data,
      {Map<String, dynamic>? queryParameters}) async {
    // return await _dio.post(path, data: data);
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      // options: Options(
      //   contentType: Headers.multipartFormDataContentType,
      // ),
    );
  }

  Future<Response> putRequest(String path, Map<String, dynamic> data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> deleteRequest(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }

  Future<Response> patchRequest(String path, Map<String, dynamic> data) async {
    return await _dio.patch(path, data: data);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown;
  }
}
