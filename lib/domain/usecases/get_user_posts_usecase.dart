import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class GetUserPostsUsecase {
  final PostRepository _postRepository;

  GetUserPostsUsecase(this._postRepository);

  Stream<List<PostEntity>> execute(String userId) {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    
    return _postRepository.getUserPosts(userId);
  }
}