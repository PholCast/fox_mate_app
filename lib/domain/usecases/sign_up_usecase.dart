import 'package:fox_mate_app/constants/validators.dart';
import 'package:fox_mate_app/domain/entities/auth_result.dart';
import 'package:fox_mate_app/domain/repositories/auth_repository.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';

class SignUpUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpUsecase(this._authRepository, this._userRepository);

  Future<AuthResult> execute({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return AuthResult.failure('Todos los campos son obligatorios');
    }

    if (!isValidEmail(email)) {
      return AuthResult.failure('Por favor ingresa tu correo institucional válido');
    }

    if (password.length < 6) {
      return AuthResult.failure('La contraseña debe tener al menos 6 caracteres');
    }

    if (password != confirmPassword) {
      return AuthResult.failure('Las contraseñas no coinciden');
    }

    final authResult = await _authRepository.signUp(name, email, password);

    if (authResult.isSuccess && authResult.user != null) {
      try {
        await _userRepository.saveUserProfile(authResult.user!);
      } catch (e) {
        return AuthResult.failure('Something went wrong: ${e.toString()}');
      }
    }

    return authResult;
  }
}