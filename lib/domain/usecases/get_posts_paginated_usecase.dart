// lib/domain/usecases/get_posts_paginated_usecase.dart
import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class GetPostsPaginatedUsecase {
  final PostRepository _postRepository;

  GetPostsPaginatedUsecase(this._postRepository);

  Future<List<PostEntity>> execute({
    required int limit,
    PostEntity? lastPost,
  }) {
    return _postRepository.getPostsPaginated(
      limit: limit,
      lastPost: lastPost,
    );
  }
}