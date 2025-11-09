import 'package:fox_mate_app/constants/validators.dart';
import 'package:fox_mate_app/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _authRepository;

  ForgotPasswordUseCase(this._authRepository);

  Future<ForgotPasswordResult> execute({
    required String email,
  }) async {
    // Validate email is not empty
    if (email.isEmpty) {
      return ForgotPasswordResult.failure('El correo electrónico es requerido');
    }

    // Validate email format
    if (!isValidEmail(email)) {
      return ForgotPasswordResult.failure(
          'Por favor ingresa un correo electrónico válido');
    }

    // Call repository to send password reset email
    try {
      await _authRepository.sendPasswordResetEmail(email);
      return ForgotPasswordResult.success();
    } catch (e) {
      return ForgotPasswordResult.failure(e.toString());
    }
  }
}

/// Result class for forgot password operation
class ForgotPasswordResult {
  final bool isSuccess;
  final String? errorMessage;

  ForgotPasswordResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory ForgotPasswordResult.success() {
    return ForgotPasswordResult._(isSuccess: true);
  }

  factory ForgotPasswordResult.failure(String message) {
    return ForgotPasswordResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}