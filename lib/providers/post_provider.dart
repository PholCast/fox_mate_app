// lib/providers/post_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/domain/entities/post_entity.dart';
import 'package:fox_mate_app/domain/usecases/create_post_usecase.dart';
import 'package:fox_mate_app/domain/usecases/delete_post_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_posts_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_user_posts_usecase.dart';
import 'package:fox_mate_app/domain/usecases/update_post_usecase.dart';

enum PostStatus { initial, loading, success, error }

class PostProvider extends ChangeNotifier {
  final GetPostsUsecase _getPostsUsecase;
  final GetUserPostsUsecase _getUserPostsUsecase;
  final CreatePostUsecase _createPostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final UpdatePostUsecase _updatePostUsecase;

  PostProvider(
    this._getPostsUsecase,
    this._getUserPostsUsecase,
    this._createPostUsecase,
    this._deletePostUsecase,
    this._updatePostUsecase,
  ) {
    _initializePosts();
  }

  PostStatus _status = PostStatus.initial;
  PostStatus _userPostsStatus = PostStatus.initial;
  
  List<PostEntity> _posts = [];
  List<PostEntity> _userPosts = [];
  
  String? _errorMessage;
  String? _userPostsErrorMessage;
  
  StreamSubscription<List<PostEntity>>? _postsSubscription;
  StreamSubscription<List<PostEntity>>? _userPostsSubscription;

  PostStatus get status => _status;
  PostStatus get userPostsStatus => _userPostsStatus;
  
  List<PostEntity> get posts => _posts;
  List<PostEntity> get userPosts => _userPosts;
  
  String? get errorMessage => _errorMessage;
  String? get userPostsErrorMessage => _userPostsErrorMessage;

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

  /// Load posts from a specific user
  void loadUserPosts(String userId) {
    // Cancel previous subscription if exists
    _userPostsSubscription?.cancel();
    
    _userPostsStatus = PostStatus.loading;
    _userPostsErrorMessage = null;
    notifyListeners();

    _userPostsSubscription = _getUserPostsUsecase.execute(userId).listen(
      (posts) {
        _userPosts = posts;
        _userPostsStatus = PostStatus.success;
        _userPostsErrorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _userPostsErrorMessage = error.toString();
        _userPostsStatus = PostStatus.error;
        notifyListeners();
      },
    );
  }

  /// Clear user posts (useful for logout or changing users)
  void clearUserPosts() {
    _userPostsSubscription?.cancel();
    _userPosts = [];
    _userPostsStatus = PostStatus.initial;
    _userPostsErrorMessage = null;
    notifyListeners();
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

  Future<void> deletePost(String postId) async {
    try {
      await _deletePostUsecase.execute(postId);
      // The stream will automatically update the list
    } catch (e) {
      _errorMessage = e.toString();
      _status = PostStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePost({
    required String postId,
    required String content,
    required List<String> tags,
    File? image,
    bool removeImage = false,
  }) async {
    try {
      _status = PostStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _updatePostUsecase.execute(
        postId: postId,
        content: content,
        tags: tags,
        image: image,
        removeImage: removeImage,
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

  void clearUserPostsError() {
    _userPostsErrorMessage = null;
    if (_userPostsStatus == PostStatus.error) {
      _userPostsStatus = _userPosts.isNotEmpty ? PostStatus.success : PostStatus.initial;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _postsSubscription?.cancel();
    _userPostsSubscription?.cancel();
    super.dispose();
  }
}