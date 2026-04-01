abstract class AuthRepository {
  Future<bool> login({required String account, required String password});
}
