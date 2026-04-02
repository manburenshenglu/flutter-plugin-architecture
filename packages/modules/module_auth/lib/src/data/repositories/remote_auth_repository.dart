import 'package:foundation/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  认证仓储远程实现，优先走网络请求并支持可选降级策略。
class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    this.fallbackRepository,
  }) : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthRepository? fallbackRepository;

  @override
  Future<bool> login({
    required String account,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        account: account,
        password: password,
      );
      return response.success;
    } on DioException {
      if (fallbackRepository != null) {
        return fallbackRepository!.login(account: account, password: password);
      }
      return false;
    }
  }
}
