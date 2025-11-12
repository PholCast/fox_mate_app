import 'package:fox_mate_app/constants/validators.dart';
import 'package:fox_mate_app/domain/entities/user_entity.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository _userRepository;

  UpdateProfileUseCase(this._userRepository);

  Future<String?> execute({
    required UserEntity user,
    required String name,
    required String email,
  }) async {
    try {
      if (name.isEmpty) {
        return 'El nombre es requerido';
      }

      if (email.isEmpty) {
        return 'El correo es requerido';
      }

      if (!isValidEmail(email)) {
        return 'Por favor ingresa tu correo institucional válido';
      }

      final updatedUser = user.copyWith(name: name, email: email);
      await _userRepository.updateUserProfile(updatedUser);
      return null;
    } catch (e) {
      return 'Error al actualizar el perfil: ${e.toString()}';
    }
  }
}