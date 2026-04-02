import 'package:dio/dio.dart';

import '../app_config/app_config.dart';
import '../app_config/app_env.dart';
import 'auth/auth_refresher.dart';
import 'auth/token_store.dart';
import 'auth/unauthorized_handler.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  Dio 构建工厂，统一基础配置和全局拦截器装配。
class DioClientFactory {
  DioClientFactory._();

  static Dio create(
    AppConfig config, {
    required TokenStore tokenStore,
    required AuthRefresher authRefresher,
    required UnauthorizedHandler unauthorizedHandler,
    bool enableAutoRefresh = true,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    List<Interceptor> extraInterceptors = const <Interceptor>[],
  }) {
    final connectTimeout = Duration(
      milliseconds: config.apiConfig.connectTimeoutMs,
    );
    final resolvedSendTimeout =
        sendTimeout ?? Duration(milliseconds: config.apiConfig.sendTimeoutMs);
    final resolvedReceiveTimeout =
        receiveTimeout ??
        Duration(milliseconds: config.apiConfig.receiveTimeoutMs);
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiConfig.baseUrl,
        connectTimeout: connectTimeout,
        sendTimeout: resolvedSendTimeout,
        receiveTimeout: resolvedReceiveTimeout,
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStore: tokenStore,
        authRefresher: authRefresher,
        unauthorizedHandler: unauthorizedHandler,
        enableAutoRefresh: enableAutoRefresh,
      ),
    );
    if (config.env != AppEnv.prod) {
      dio.interceptors.add(LoggingInterceptor());
    }
    dio.interceptors.addAll(extraInterceptors);

    return dio;
  }
}
