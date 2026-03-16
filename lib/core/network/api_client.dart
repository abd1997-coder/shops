import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    // Get secret key from .env file or --dart-define
    String secretKey;
    try {
      secretKey = dotenv.env['SECRET_KEY'] ?? '';
    } catch (e) {
      // dotenv not loaded, use empty string
      secretKey = '';
    }

    // Use --dart-define if .env value is empty
    if (secretKey.isEmpty) {
      secretKey = const String.fromEnvironment('SECRET_KEY', defaultValue: '');
    }

    // Ensure secret key is not empty
    if (secretKey.isEmpty) {
      // ❌ SECRET_KEY is missing!
      throw Exception(
        'An error occurred while loading the Data from the API',
      );
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          ApiConstants.secretKeyHeader: secretKey,
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Dio get dio => _dio;
}
