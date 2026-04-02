import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  登录请求 DTO，用于序列化账号密码参数。
@JsonSerializable()
class LoginRequestDto {
  const LoginRequestDto({required this.account, required this.password});

  final String account;
  final String password;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) {
    return _$LoginRequestDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
