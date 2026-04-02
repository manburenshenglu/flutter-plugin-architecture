import '../remote/apis/auth_api.dart';
import '../remote/dtos/login_response_dto.dart';
import '../remote/dtos/login_request_dto.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  认证远程数据源，封装 Retrofit API 调用细节。
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);

  final AuthApi _api;

  Future<LoginResponseDto> login({
    required String account,
    required String password,
  }) {
    return _api.login(LoginRequestDto(account: account, password: password));
  }
}
