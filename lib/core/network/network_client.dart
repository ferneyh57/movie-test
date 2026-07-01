import 'package:dio/dio.dart';
import 'package:movie_test/core/config/app_config.dart';

Dio createDioClient() => Dio(
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
