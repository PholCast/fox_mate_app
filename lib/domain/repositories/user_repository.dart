import 'package:fox_mate_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(UserEntity user);
  Future<UserEntity?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserEntity user);
  Future<void> deleteUserProfile(String userId);
  Future<List<UserEntity>> getAllUsers();
}
