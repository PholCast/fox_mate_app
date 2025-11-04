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
      return AuthResult.failure('All fields are required');
    }

    if(!isValidEmail(email)){
      return AuthResult.failure('Please enter a valid email address');
    }

    return _authRepository.signIn(email, password);
  }
}