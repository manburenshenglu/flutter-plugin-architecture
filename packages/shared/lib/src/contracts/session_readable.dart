/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  会话读取能力契约，供其他模块查询当前登录用户标识。

abstract class SessionReadable {
  String? currentUserId();
}
