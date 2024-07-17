import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final int retryInterval;

  RetryInterceptor(
      {required this.dio, this.retries = 3, this.retryInterval = 1000});

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retries'] != retries) {
      err.requestOptions.extra['retries'] =
          (err.requestOptions.extra['retries'] ?? 0) + 1;
      await Future.delayed(Duration(milliseconds: retryInterval));
      dio.fetch(err.requestOptions).then(
            (r) => handler.resolve(r),
            onError: (e) => handler.reject(e),
          );
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown;
  }
}
