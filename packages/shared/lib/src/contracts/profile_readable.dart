/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  资料读取能力契约，供其他模块获取用户展示名称，如提供userInfo。

abstract class ProfileReadable {
  Future<String> displayName();
}
