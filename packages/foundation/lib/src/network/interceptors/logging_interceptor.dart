import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  网络日志拦截器，统一封装 pretty_dio_logger 以便集中管理。
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor()
    : _delegate = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      );

  final PrettyDioLogger _delegate;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _delegate.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _delegate.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _delegate.onError(err, handler);
  }
}
