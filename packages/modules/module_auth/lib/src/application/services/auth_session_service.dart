import 'package:shared/shared.dart';

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
