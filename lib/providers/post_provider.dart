// lib/providers/post_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/domain/usecases/create_post_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_posts_usecase.dart';

enum PostStatus { initial, loading, success, error }

class PostProvider extends ChangeNotifier {
  final GetPostsUsecase _getPostsUsecase;
  final CreatePostUsecase _createPostUsecase;

  PostProvider(
    this._getPostsUsecase,
    this._createPostUsecase,
  ) {
    _initializePosts();
  }

  PostStatus _status = PostStatus.initial;
  List<PostEntity> _posts = [];
  String? _errorMessage;
  StreamSubscription<List<PostEntity>>? _postsSubscription;

  PostStatus get status => _status;
  List<PostEntity> get posts => _posts;
  String? get errorMessage => _errorMessage;

  void _initializePosts() {
    _status = PostStatus.loading;
    notifyListeners();

    _postsSubscription = _getPostsUsecase.execute().listen(
      (posts) {
        _posts = posts;
        _status = PostStatus.success;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _status = PostStatus.error;
        notifyListeners();
      },
    );
  }

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
      _status = PostStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _createPostUsecase.execute(
        authorId: authorId,
        authorName: authorName,
        authorInitials: authorInitials,
        authorProfileImage: authorProfileImage,
        content: content,
        tags: tags,
        image: image,
      );

      _status = PostStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = PostStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_status == PostStatus.error) {
      _status = _posts.isNotEmpty ? PostStatus.success : PostStatus.initial;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _postsSubscription?.cancel();
    super.dispose();
  }
}