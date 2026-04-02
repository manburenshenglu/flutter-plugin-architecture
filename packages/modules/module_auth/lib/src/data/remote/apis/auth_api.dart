import 'package:foundation/foundation.dart';
import 'package:retrofit/retrofit.dart';

import '../dtos/login_request_dto.dart';
import '../dtos/login_response_dto.dart';

part 'auth_api.g.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  认证模块远程接口定义，负责声明登录请求协议。
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);
}
