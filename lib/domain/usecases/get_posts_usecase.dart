// lib/domain/usecases/get_posts_usecase.dart
import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class GetPostsUsecase {
  final PostRepository _postRepository;

  GetPostsUsecase(this._postRepository);

  Stream<List<PostEntity>> execute() {
    return _postRepository.getPosts();
  }
}