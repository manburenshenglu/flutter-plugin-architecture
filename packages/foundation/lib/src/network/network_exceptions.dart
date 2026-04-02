import 'package:dio/dio.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  统一网络异常模型，保留 dio 原始异常细节用于排查。
class NetworkException implements Exception {
  const NetworkException({
    required this.message,
    required this.type,
    required this.method,
    required this.path,
    this.statusCode,
    this.responseBody,
    this.rawMessage,
  });

  factory NetworkException.fromDioException(DioException exception) {
    final request = exception.requestOptions;
    final statusCode = exception.response?.statusCode;
    final rawMessage = exception.message;
    final responseBody = exception.response?.data?.toString();
    final path = request.uri.toString();
    final method = request.method;
    final type = exception.type;

    return NetworkException(
      message:
          'DioException(type: $type, method: $method, path: $path, statusCode: '
          '${statusCode ?? 'null'}, message: ${rawMessage ?? 'null'}, '
          'response: ${responseBody ?? 'null'})',
      type: type,
      method: method,
      path: path,
      statusCode: statusCode,
      responseBody: responseBody,
      rawMessage: rawMessage,
    );
  }

  final String message;
  final DioExceptionType type;
  final String method;
  final String path;
  final int? statusCode;
  final String? responseBody;
  final String? rawMessage;

  @override
  String toString() =>
      'NetworkException(message: $message, statusCode: $statusCode)';
}
