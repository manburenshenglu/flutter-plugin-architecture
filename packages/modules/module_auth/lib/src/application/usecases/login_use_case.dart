import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> execute({required String account, required String password}) {
    return _repository.login(account: account, password: password);
  }
}
