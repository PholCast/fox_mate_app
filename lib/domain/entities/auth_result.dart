import 'package:equatable/equatable.dart';
import 'package:fox_mate_app/domain/entities/user_entity.dart';

class AuthResult extends Equatable {
  final UserEntity? user;
  final String? errorMessage;
  final bool isSuccess;

  const AuthResult({required this.isSuccess, this.user, this.errorMessage});

  const AuthResult.success(UserEntity user)
    : this.user = user,
      isSuccess = true,
      errorMessage = null;

  const AuthResult.failure(String error)
    : user = null,
      isSuccess = false,
      errorMessage = error;

  @override
  List<Object?> get props => [user, errorMessage, isSuccess];
}