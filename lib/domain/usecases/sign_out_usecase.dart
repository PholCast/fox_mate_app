import 'package:fox_mate_app/domain/repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _authRepository;

  SignOutUsecase(this._authRepository);

  Future<void> execute() async {
    return _authRepository.signOut();
  }
}