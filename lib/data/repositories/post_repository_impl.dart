// lib/data/repositories/post_repository_impl.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fox_mate_app/data/models/post_model.dart';
import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PostRepositoryImpl(this._firestore, this._storage);

  @override
  Stream<List<PostEntity>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Stream<List<PostEntity>> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('authorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Ordenar en memoria después de obtener los datos
      final posts = snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data(), doc.id);
      }).toList();
      
      // Ordenar por timestamp descendente
      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return posts;
    });
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String authorInitials,
    String? authorProfileImage,
    required String content,
    required List<String> tags,
    File? image,
  }) async {
    try {
      String? imageUrl;

      // Si hay imagen, subirla a Firebase Storage
      if (image != null) {
        imageUrl = await _uploadImage(image, authorId);
      }

      // Crear el post en Firestore
      final postData = PostModel(
        id: '', // Firestore generará el ID
        authorId: authorId,
        authorName: authorName,
        authorInitials: authorInitials,
        authorProfileImage: authorProfileImage,
        content: content,
        imageUrl: imageUrl,
        tags: tags,
        timestamp: DateTime.now(),
      ).toJson();

      await _firestore.collection('posts').add(postData);
    } catch (e) {
      throw Exception('Error creating post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      // Obtener el post para eliminar la imagen si existe
      final doc = await _firestore.collection('posts').doc(postId).get();
      
      if (doc.exists) {
        final data = doc.data();
        final imageUrl = data?['imageUrl'] as String?;
        
        // Eliminar imagen de Storage si existe
        if (imageUrl != null) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(imageUrl);
            await ref.delete();
          } catch (e) {
            print('Error deleting image: $e');
          }
        }
        
        // Eliminar el documento
        await _firestore.collection('posts').doc(postId).delete();
      }
    } catch (e) {
      throw Exception('Error deleting post: ${e.toString()}');
    }
  }

  Future<String> _uploadImage(File image, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${userId}.jpg';
      final ref = _storage.ref().child('posts').child(fileName);
      
      final uploadTask = await ref.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }
}