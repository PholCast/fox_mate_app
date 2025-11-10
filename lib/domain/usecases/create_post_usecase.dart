// lib/domain/usecases/create_post_usecase.dart
import 'dart:io';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class CreatePostUsecase {
  final PostRepository _postRepository;

  CreatePostUsecase(this._postRepository);

  Future<void> execute({
    required String authorId,
    required String authorName,
    required String authorInitials,
    String? authorProfileImage,
    required String content,
    required List<String> tags,
    File? image,
  }) async {
    if (content.trim().isEmpty) {
      throw Exception('Content cannot be empty');
    }

    if (tags.isEmpty) {
      throw Exception('At least one tag is required');
    }

    return await _postRepository.createPost(
      authorId: authorId,
      authorName: authorName,
      authorInitials: authorInitials,
      authorProfileImage: authorProfileImage,
      content: content,
      tags: tags,
      image: image,
    );
  }
}