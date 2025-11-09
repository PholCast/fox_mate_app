import 'package:firebase_auth/firebase_auth.dart';
import 'package:fox_mate_app/data/models/user_model.dart';
import 'package:fox_mate_app/domain/entities/auth_result.dart';
import 'package:fox_mate_app/domain/entities/user_entity.dart';
import 'package:fox_mate_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<AuthResult> signUp(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);

        final user = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
        );

        return AuthResult.success(user);
      } else {
        return AuthResult.failure('User is null');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Something went wrong: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
        );

        return AuthResult.success(user);
      } else {
        return AuthResult.failure('Sign in failed');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Something went wrong: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email!,
      );
    }
    return null;
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email!,
        );
      }
      return null;
    });
  }

   @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } catch (e) {
      throw 'Error al enviar el correo de recuperación: ${e.toString()}';
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials and try again.';
      case 'user-disabled':
        return 'User is disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      default:
        return 'Something went wrong: ${e.message}';
    }
  }
}