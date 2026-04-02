import 'unauthorized_handler.dart';

/// @author xiejl
/// @date 2026/4/2 14:30
/// @description  默认未授权处理器，占位实现，不做任何副作用。
class NoopUnauthorizedHandler implements UnauthorizedHandler {
  @override
  Future<void> onUnauthorized() async {}
}
