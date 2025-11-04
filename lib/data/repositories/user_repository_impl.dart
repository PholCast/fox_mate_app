import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_mate_app/data/models/user_model.dart';
import 'package:fox_mate_app/domain/entities/user_entity.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'users';

  UserRepositoryImpl(this._firestore);

  @override
  Future<void> saveUserProfile(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _firestore
          .collection(_collectionName)
          .doc(userModel.id)
          .set(userModel.toJson());
    } catch (e) {
      throw Exception('Failed to save user profile: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _firestore
          .collection(_collectionName)
          .doc(userModel.id)
          .update(userModel.toJson());
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: ${e.toString()}');
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Failed to get all users: ${e.toString()}');
      throw Exception('Failed to get all users: ${e.toString()}');
    }
  }
}