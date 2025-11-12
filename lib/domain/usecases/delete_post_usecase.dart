import 'package:fox_mate_app/domain/repositories/post_repository.dart';

class DeletePostUsecase {
  final PostRepository _postRepository;

  DeletePostUsecase(this._postRepository);

  Future<void> execute(String postId) async {
    if (postId.isEmpty) {
      throw ArgumentError('Post ID cannot be empty');
    }

    return await _postRepository.deletePost(postId);
  }
}

