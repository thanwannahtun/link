import 'package:dio/dio.dart';

class ApiErrorHandler {
  static ApiException handle(Exception error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          return ApiException(message: "Request to API was cancelled");
        case DioExceptionType.connectionTimeout:
          return _TimeoutException("Connection timeout with API server");
        case DioExceptionType.sendTimeout:
          return _TimeoutException(
              "Send timeout in connection with API server");
        case DioExceptionType.receiveTimeout:
          return _TimeoutException(
              "Receive timeout in connection with API server");
        case DioExceptionType.badResponse:
          return _handleHttpResponse(error);
        case DioExceptionType.unknown:
          if (error.message?.contains("SocketException") ?? false) {
            return _NetworkException("No Internet connection");
          }
          return ApiException(message: "Unexpected error occurred");
        default:
          return ApiException(message: "Unexpected error occurred");
      }
    } else {
      return ApiException(message: "[Unknown error] :: ${error.toString()}");
    }
  }

  static ApiException _handleHttpResponse(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return _BadRequestException(
            "Bad request: ${error.response?.data['message'] ?? 'Invalid request'}");
      case 401:
      case 403:
        return _AuthenticationException(
            "Unauthorized: ${error.response?.data['message'] ?? 'Access denied'}");
      case 404:
        return _NotFoundException(
            "Not found: ${error.response?.data['message'] ?? 'Resource not found'}");
      case 500:
      default:
        return _ServerException(
            "Server error: ${error.response?.data['message'] ?? 'Internal server error'}",
            error.response?.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class _NetworkException extends ApiException {
  _NetworkException(String message) : super(message: message);
}

class _TimeoutException extends ApiException {
  _TimeoutException(String message) : super(message: message);
}

class _ServerException extends ApiException {
  _ServerException(String message, int? statusCode)
      : super(message: message, statusCode: statusCode);
}

class _AuthenticationException extends ApiException {
  _AuthenticationException(String message) : super(message: message);
}

class _BadRequestException extends ApiException {
  _BadRequestException(String message) : super(message: message);
}

class _NotFoundException extends ApiException {
  _NotFoundException(String message) : super(message: message);
}
