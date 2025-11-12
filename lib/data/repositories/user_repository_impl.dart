// lib/data/repositories/user_repository_impl.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fox_mate_app/data/models/user_model.dart';
import 'package:fox_mate_app/domain/entities/user_entity.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _firebaseAuth;
  static const String _collectionName = 'users';

  UserRepositoryImpl(this._firestore, this._storage, this._firebaseAuth);

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
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Use document ID as user ID
            return UserModel.fromJson(data);
          })
          .toList();
    } catch (e) {
      print('Failed to get all users: ${e.toString()}');
      throw Exception('Failed to get all users: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage(File image, String userId) async {
    try {
      // Eliminar imagen anterior si existe
      try {
        final oldImageRef = _storage.ref().child('profiles').child('$userId.jpg');
        await oldImageRef.delete();
      } catch (e) {
        // Si no existe imagen anterior, continuar
        print('No previous image to delete or error: $e');
      }

      // Subir nueva imagen
      final fileName = '$userId.jpg';
      final ref = _storage.ref().child('profiles').child(userId).child(fileName);

      
      final uploadTask = await ref.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      // Actualizar photoUrl en Firebase Auth
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.updatePhotoURL(downloadUrl);
        // Recargar el usuario para obtener el photoURL actualizado
        await currentUser.reload();
        final reloadedUser = _firebaseAuth.currentUser;
        print('PhotoURL updated successfully');
        print("photourl es:${reloadedUser?.photoURL}");
      }
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading profile image: ${e.toString()}');
    }
  }

  // Agregar este método a UserRepositoryImpl

@override
Future<List<UserEntity>> getUsersNotLikedBy(String userId) async {
  try {
    // 1. Obtener todos los usuarios
    final allUsersSnapshot = await _firestore.collection(_collectionName).get();
    
    // 2. Obtener todos los likes del usuario actual
    final likesSnapshot = await _firestore
        .collection('likes')
        .where('userId', isEqualTo: userId)
        .get();
    
    // 3. Crear un Set con los IDs de usuarios que ya han recibido like
    final likedUserIds = likesSnapshot.docs
        .map((doc) => doc.data()['likedUserId'] as String)
        .toSet();
    
    // 4. Filtrar usuarios: excluir al usuario actual y a los que ya tienen like
    final filteredUsers = allUsersSnapshot.docs
        .where((doc) {
          final docId = doc.id;
          return docId != userId && !likedUserIds.contains(docId);
        })
        .map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return UserModel.fromJson(data);
        })
        .toList();
    
    return filteredUsers;
  } catch (e) {
    print('Failed to get users not liked: ${e.toString()}');
    throw Exception('Failed to get users not liked: ${e.toString()}');
  }
}
}