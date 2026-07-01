import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_test/core/config/app_config.dart';
import 'package:movie_test/core/utils/app_logger.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.tmdbBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Authorization': 'Bearer ${AppConfig.tmdbAccessToken}',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          appLogger.d('→ ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          appLogger.i('← ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          appLogger.e(
            '✗ ${error.response?.statusCode} ${error.requestOptions.path}',
            error: error,
          );
          handler.next(error);
        },
      ),
    );
  }

  return dio;
}
