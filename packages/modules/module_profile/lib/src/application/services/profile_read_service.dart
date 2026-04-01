import 'package:shared/shared.dart';

class ProfileReadService implements ProfileReadable {
  ProfileReadService({required this.name});

  final String name;

  @override
  Future<String> displayName() async {
    return name;
  }
}
