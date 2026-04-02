/// @author xiejl
/// @date 2026/4/2 14:30
/// @description  未授权处理抽象，刷新失败后执行清会话/跳登录等动作。
abstract class UnauthorizedHandler {
  Future<void> onUnauthorized();
}
