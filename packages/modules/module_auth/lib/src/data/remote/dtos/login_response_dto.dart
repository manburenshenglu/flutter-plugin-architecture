import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

/// @author xiejl
/// @date 2026/4/2 11:55
/// @description  登录响应 DTO，承载登录结果及可选用户信息。
@JsonSerializable()
class LoginResponseDto {
  const LoginResponseDto({required this.success, this.userId, this.message});

  final bool success;
  final String? userId;
  final String? message;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return _$LoginResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}
