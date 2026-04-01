import 'package:shared/shared.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  认证会话服务，维护并提供当前登录用户 ID。

class AuthSessionService implements SessionReadable {
  String? _userId;

  void updateUserId(String userId) {
    _userId = userId;
  }

  @override
  String? currentUserId() {
    return _userId;
  }
}
