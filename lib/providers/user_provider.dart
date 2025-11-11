// lib/providers/user_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/domain/entities/user_entity.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';
import 'package:fox_mate_app/domain/usecases/update_profile_usecase.dart';

enum UserState { initial, loading, success, error }

class UserProvider extends ChangeNotifier {
  final UpdateProfileUseCase _updateProfileUseCase;
  final UserRepository _userRepository;

  UserState _userState = UserState.initial;
  UserEntity? _user;
  String? _errorMessage;
  
  List<UserEntity> _allUsers = [];
  UserState _allUsersState = UserState.initial;
  String? _allUsersErrorMessage;

  UserState get userState => _userState;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  
  List<UserEntity> get allUsers => _allUsers;
  UserState get allUsersState => _allUsersState;
  String? get allUsersErrorMessage => _allUsersErrorMessage;

  // Individual getters for all user properties
  String get userId => _user?.id ?? '';
  String get userName => _user?.name ?? '';
  String get userEmail => _user?.email ?? '';
  int get userAge => _user?.age ?? 0;
  String get userCareer => _user?.career ?? '';
  int get userSemester => _user?.semester ?? 0;
  String? get userImageUrl => _user?.imageUrl;
  String get userBio => _user?.bio ?? 'No hay descripción disponible';
  List<String> get userInterests => _user?.interests ?? [];

  UserProvider(this._updateProfileUseCase, this._userRepository);

  /// Load user profile from Firestore by userId
  Future<void> loadUserProfile(String userId) async {
    _setState(UserState.loading);

    try {
      _user = await _userRepository.getUserProfile(userId);
      if (_user != null) {
        _setState(UserState.success);
        _errorMessage = null;
      } else {
        _errorMessage = 'Usuario no encontrado';
        _setState(UserState.error);
      }
    } catch (e) {
      _errorMessage = 'Error al cargar el perfil: ${e.toString()}';
      _setState(UserState.error);
    }
  }

  /// Load user data directly from UserEntity (from AuthProvider)
  void loadUserData(UserEntity user) {
    _user = user;
    _setState(UserState.success);
  }

  /// Update user profile with new information (including optional image)
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? email,
    int? age,
    String? career,
    int? semester,
    String? imageUrl,
    String? bio,
    List<String>? interests,
    File? profileImage,
  }) async {
    if (_user == null) return;

    _setState(UserState.loading);
    
    try {
      String? newImageUrl = imageUrl;

      // Upload profile image if provided
      if (profileImage != null) {
        newImageUrl = await _userRepository.uploadProfileImage(
          profileImage,
          userId,
        );
      }

      // Create updated user entity
      final updatedUser = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        age: age ?? _user!.age,
        career: career ?? _user!.career,
        semester: semester ?? _user!.semester,
        imageUrl: newImageUrl ?? _user!.imageUrl,
        bio: bio ?? _user!.bio,
        interests: interests ?? _user!.interests,
      );

      // Update in repository
      await _userRepository.updateUserProfile(updatedUser);

      // Update local state
      _user = updatedUser;
      _errorMessage = null;
      _setState(UserState.success);
    } catch (e) {
      _errorMessage = 'Error al actualizar el perfil: ${e.toString()}';
      _setState(UserState.error);
      rethrow;
    }
  }

  /// Update only basic profile info (name and email)
  Future<void> updateBasicProfile({
    required UserEntity user,
    required String newName,
    required String newEmail,
  }) async {
    _setState(UserState.loading);
    try {
      final error = await _updateProfileUseCase.execute(
        user: user,
        name: newName,
        email: newEmail,
      );

      if (error == null) {
        _user = user.copyWith(name: newName, email: newEmail);
        _errorMessage = null;
        _setState(UserState.success);
      } else {
        _errorMessage = error;
        _setState(UserState.error);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserState.error);
    }
  }

  /// Refresh user profile from Firestore
  Future<void> refreshUserProfile() async {
    if (_user != null) {
      await loadUserProfile(_user!.id);
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    if (_userState == UserState.error) {
      _userState = _user != null ? UserState.success : UserState.initial;
    }
    notifyListeners();
  }

  /// Load all users from Firestore (excluding current user)
  Future<void> loadAllUsers(String currentUserId) async {
    _allUsersState = UserState.loading;
    _allUsersErrorMessage = null;
    notifyListeners();

    try {
      final users = await _userRepository.getAllUsers();
      // Filter out the current user
      _allUsers = users.where((user) => user.id != currentUserId).toList();
      _allUsersState = UserState.success;
      _allUsersErrorMessage = null;
      notifyListeners();
    } catch (e) {
      _allUsersErrorMessage = 'Error al cargar usuarios: ${e.toString()}';
      _allUsersState = UserState.error;
      notifyListeners();
    }
  }

  /// Clear all user data (for logout)
  void clearUserData() {
    _user = null;
    _errorMessage = null;
    _allUsers = [];
    _allUsersState = UserState.initial;
    _allUsersErrorMessage = null;
    _setState(UserState.initial);
  }

  void _setState(UserState status) {
    _userState = status;
    notifyListeners();
  }
}