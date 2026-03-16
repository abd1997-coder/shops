import 'package:dio/dio.dart';

/// Handles [DioException] and throws an [Exception] with a normalized message.
Never handleDioException(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    throw Exception('TIMEOUT');
  }
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown) {
    if (e.error?.toString().contains('SocketException') == true ||
        e.error?.toString().contains('Network is unreachable') == true) {
      throw Exception('NO_INTERNET');
    }
    throw Exception('NETWORK_ERROR: ${e.message}');
  }
  if (e.type == DioExceptionType.badResponse) {
    throw Exception('SERVER_ERROR: ${e.response?.statusCode}');
  }
  throw Exception('NETWORK_ERROR: ${e.message}');
}
