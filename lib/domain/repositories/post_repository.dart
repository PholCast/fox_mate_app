// lib/domain/repositories/post_repository.dart
import 'dart:io';
import 'package:fox_mate_app/domain/entities/post_entity.dart';

abstract class PostRepository {
  Stream<List<PostEntity>> getPosts();
  
  /// Get posts from a specific user
  Stream<List<PostEntity>> getUserPosts(String userId);
  
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String authorInitials,
    String? authorProfileImage,
    required String content,
    required List<String> tags,
    File? image,
  });
  
  Future<void> deletePost(String postId);
  
  Future<void> updatePost({
    required String postId,
    required String content,
    required List<String> tags,
    File? image,
    bool removeImage = false,
  });
}