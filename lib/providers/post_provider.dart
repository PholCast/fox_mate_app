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
import 'package:fox_mate_app/domain/usecases/get_posts_paginated_usecase.dart';

enum PostStatus { initial, loading, success, error, loadingMore }

class PostProvider extends ChangeNotifier {
  final GetPostsUsecase _getPostsUsecase;
  final GetUserPostsUsecase _getUserPostsUsecase;
  final CreatePostUsecase _createPostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final UpdatePostUsecase _updatePostUsecase;
  final GetPostsPaginatedUsecase _getPostsPaginatedUsecase;

  PostProvider(
    this._getPostsUsecase,
    this._getUserPostsUsecase,
    this._createPostUsecase,
    this._deletePostUsecase,
    this._updatePostUsecase,
    this._getPostsPaginatedUsecase,
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

  bool _hasMore = true;
  bool _isLoadingMore = false;

  // New variables for user posts pagination
  bool _hasMoreUserPosts = true;
  bool _isLoadingMoreUserPosts = false;
  String? _currentUserId;

  PostStatus get status => _status;
  PostStatus get userPostsStatus => _userPostsStatus;

  List<PostEntity> get posts => _posts;
  List<PostEntity> get userPosts => _userPosts;

  String? get errorMessage => _errorMessage;
  String? get userPostsErrorMessage => _userPostsErrorMessage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  // New getters for user posts pagination
  bool get hasMoreUserPosts => _hasMoreUserPosts;
  bool get isLoadingMoreUserPosts => _isLoadingMoreUserPosts;

  void _initializePosts() {
    _status = PostStatus.loading;
    notifyListeners();

    _postsSubscription = _getPostsUsecase.execute().listen(
      (posts) {
        _posts = posts;
        _status = PostStatus.success;
        _errorMessage = null;
        _hasMore = posts.length >= 10;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _status = PostStatus.error;
        notifyListeners();
      },
    );
  }

  /// Load posts from a specific user (stream-based, not paginated)
  void loadUserPosts(String userId) {
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

  /// Load user posts with pagination (initial load)
  Future<void> loadUserPostsPaginated(String userId) async {
    try {
      _currentUserId = userId;
      _userPosts = [];
      _hasMoreUserPosts = true;
      _userPostsStatus = PostStatus.loading;
      _userPostsErrorMessage = null;
      notifyListeners();

      // Create a filter function to get only user posts
      final allPosts = await _getPostsPaginatedUsecase.execute(
        limit: 10,
        lastPost: null,
      );

      // Filter posts by userId
      _userPosts = allPosts.where((post) => post.authorId == userId).toList();
      _hasMoreUserPosts = _userPosts.length >= 10;
      _userPostsStatus = PostStatus.success;
      _userPostsErrorMessage = null;
      notifyListeners();
    } catch (e) {
      _userPostsErrorMessage = e.toString();
      _userPostsStatus = PostStatus.error;
      notifyListeners();
    }
  }

  /// Load more user posts (pagination)
  Future<void> loadMoreUserPosts() async {
    if (_isLoadingMoreUserPosts || !_hasMoreUserPosts || _userPosts.isEmpty || _currentUserId == null) {
      return;
    }

    try {
      _isLoadingMoreUserPosts = true;
      notifyListeners();

      final lastPost = _userPosts.last;
      
      // Get more posts
      final newPosts = await _getPostsPaginatedUsecase.execute(
        limit: 30, // Get more to filter
        lastPost: lastPost,
      );

      // Filter by current user
      final userNewPosts = newPosts.where((post) => post.authorId == _currentUserId).toList();

      if (userNewPosts.isEmpty) {
        _hasMoreUserPosts = false;
      } else {
        // Avoid duplicates
        final existingIds = _userPosts.map((p) => p.id).toSet();
        final uniqueNewPosts = userNewPosts.where((p) => !existingIds.contains(p.id)).toList();

        _userPosts.addAll(uniqueNewPosts);
        _hasMoreUserPosts = uniqueNewPosts.length >= 10;
      }
    } catch (e) {
      _userPostsErrorMessage = e.toString();
    } finally {
      _isLoadingMoreUserPosts = false;
      notifyListeners();
    }
  }

  /// Clear user posts (useful for logout or changing users)
  void clearUserPosts() {
    _userPostsSubscription?.cancel();
    _userPosts = [];
    _userPostsStatus = PostStatus.initial;
    _userPostsErrorMessage = null;
    _hasMoreUserPosts = true;
    _isLoadingMoreUserPosts = false;
    _currentUserId = null;
    notifyListeners();
  }

  /// 🔄 Load more posts (pagination for main feed)
  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _posts.isEmpty) return;

    try {
      _isLoadingMore = true;
      _status = PostStatus.loadingMore;
      notifyListeners();

      final lastPost = _posts.last;
      final newPosts = await _getPostsPaginatedUsecase.execute(
        limit: 10,
        lastPost: lastPost,
      );

      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        // Avoid duplicates
        final existingIds = _posts.map((p) => p.id).toSet();
        final uniqueNewPosts =
            newPosts.where((p) => !existingIds.contains(p.id)).toList();

        _posts.addAll(uniqueNewPosts);
        _hasMore = uniqueNewPosts.length >= 10;
      }

      _status = PostStatus.success;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _status = PostStatus.error;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
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
      // Remove from user posts list if it exists
      _userPosts.removeWhere((post) => post.id == postId);
      notifyListeners();
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
      _userPostsStatus =
          _userPosts.isNotEmpty ? PostStatus.success : PostStatus.initial;
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