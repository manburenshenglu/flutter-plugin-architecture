import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_store.dart';

/// @author xiejl
/// @date 2026/4/2 15:40
/// @description  基于 flutter_secure_storage 的 token 存储实现。
class SecureTokenStore implements TokenStore {
  SecureTokenStore({
    FlutterSecureStorage? storage,
    String keyPrefix = 'foundation',
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _accessTokenKey = '${keyPrefix}_access_token',
       _refreshTokenKey = '${keyPrefix}_refresh_token';

  final FlutterSecureStorage _storage;
  final String _accessTokenKey;
  final String _refreshTokenKey;

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> writeAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> writeRefreshToken(String token) {
    return _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
