// lib/domain/usecases/update_post_usecase.dart
import 'dart:io';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class UpdatePostUsecase {
  final PostRepository _postRepository;

  UpdatePostUsecase(this._postRepository);

  Future<void> execute({
    required String postId,
    required String content,
    required List<String> tags,
    File? image,
    bool removeImage = false,
  }) async {
    if (postId.isEmpty) {
      throw ArgumentError('ID del post no puede estar vacío');
    }

    if (content.trim().isEmpty) {
      throw Exception('El contenido no puede estar vacío');
    }

    if (tags.isEmpty) {
      throw Exception('Es necesario incluir una etiqueta');
    }

    return await _postRepository.updatePost(
      postId: postId,
      content: content,
      tags: tags,
      image: image,
      removeImage: removeImage,
    );
  }
}

