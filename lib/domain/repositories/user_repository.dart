// lib/domain/repositories/user_repository.dart
import 'dart:io';
import 'package:fox_mate_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(UserEntity user);
  Future<UserEntity?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserEntity user);
  Future<void> deleteUserProfile(String userId);
  Future<List<UserEntity>> getAllUsers();
  Future<String> uploadProfileImage(File image, String userId);
}