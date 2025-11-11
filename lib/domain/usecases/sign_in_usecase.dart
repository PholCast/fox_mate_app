import 'package:fox_mate_app/constants/validators.dart';
import 'package:fox_mate_app/domain/entities/auth_result.dart';
import 'package:fox_mate_app/domain/repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository _authRepository;

  SignInUsecase(this._authRepository);

  Future<AuthResult> execute({
    required String email,
    required String password,
  }) async {
    if(email.isEmpty || password.isEmpty){
      return AuthResult.failure('Todos los campos son obligatorios');
    }

    if(!isValidEmail(email)){
      return AuthResult.failure('Por favor ingresa tu correo institucional válido');
    }

    return _authRepository.signIn(email, password);
  }
}