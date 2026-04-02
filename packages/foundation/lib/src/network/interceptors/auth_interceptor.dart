import 'package:dio/dio.dart';

import '../auth/auth_refresher.dart';
import '../auth/token_store.dart';
import '../auth/unauthorized_handler.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  认证拦截器，统一处理 token 注入与失效刷新重试逻辑。
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStore tokenStore,
    required AuthRefresher authRefresher,
    required UnauthorizedHandler unauthorizedHandler,
    this.enableAutoRefresh = true,
  }) : _dio = dio,
       _tokenStore = tokenStore,
       _authRefresher = authRefresher,
       _unauthorizedHandler = unauthorizedHandler;

  static const String _kRetryAfterRefresh = '__retry_after_refresh__';
  static const String _kSkipRefresh = '__skip_refresh__';

  final Dio _dio;
  final TokenStore _tokenStore;
  final AuthRefresher _authRefresher;
  final UnauthorizedHandler _unauthorizedHandler;
  final bool enableAutoRefresh;
  Future<RefreshedToken?>? _refreshingFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final hasRetried = err.requestOptions.extra[_kRetryAfterRefresh] == true;
    final skipRefresh = err.requestOptions.extra[_kSkipRefresh] == true;

    if (!enableAutoRefresh || !isUnauthorized || hasRetried || skipRefresh) {
      handler.next(err);
      return;
    }

    try {
      final refreshedToken = await _refreshToken();
      if (refreshedToken == null || refreshedToken.accessToken.isEmpty) {
        await _tokenStore.clear();
        await _unauthorizedHandler.onUnauthorized();
        handler.next(err);
        return;
      }

      await _tokenStore.writeAccessToken(refreshedToken.accessToken);
      final newRefreshToken = refreshedToken.refreshToken;
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _tokenStore.writeRefreshToken(newRefreshToken);
      }

      final retriedRequest = _buildRetriedRequest(err.requestOptions);
      retriedRequest.headers['Authorization'] =
          'Bearer ${refreshedToken.accessToken}';

      final response = await _dio.fetch<dynamic>(retriedRequest);
      handler.resolve(response);
    } catch (_) {
      await _tokenStore.clear();
      await _unauthorizedHandler.onUnauthorized();
      handler.next(err);
    }
  }

  Future<RefreshedToken?> _refreshToken() {
    final refreshing = _refreshingFuture;
    if (refreshing != null) {
      return refreshing;
    }

    final future = _refreshWithLatestRefreshToken();
    _refreshingFuture = future;
    future.whenComplete(() {
      if (identical(_refreshingFuture, future)) {
        _refreshingFuture = null;
      }
    });
    return future;
  }

  Future<RefreshedToken?> _refreshWithLatestRefreshToken() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    return _authRefresher.refreshToken(refreshToken: refreshToken);
  }

  RequestOptions _buildRetriedRequest(RequestOptions origin) {
    final headers = Map<String, dynamic>.from(origin.headers);
    final extra = Map<String, dynamic>.from(origin.extra);
    extra[_kRetryAfterRefresh] = true;

    return origin.copyWith(headers: headers, extra: extra);
  }
}
