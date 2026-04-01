import 'package:shared/shared.dart';

/// @author xiejl
/// @date 2026/4/1 15:09
/// @description  资料读取服务，向跨模块能力提供用户展示名称。

class ProfileReadService implements ProfileReadable {
  ProfileReadService({required this.name});

  final String name;

  @override
  Future<String> displayName() async {
    return name;
  }
}
