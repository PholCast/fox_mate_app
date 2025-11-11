import 'package:fox_mate_app/domain/entities/match_entity.dart';

abstract class MatchRepository {
  /// Like a user (create a like document)
  Future<void> likeUser(String userId, String likedUserId);

  /// Check if a user has liked another user
  Future<bool> hasUserLiked(String userId, String likedUserId);

  /// Check if there's a mutual like (both users like each other)
  Future<bool> checkMutualLike(String userId1, String userId2);

  /// Create a match when both users like each other
  Future<String> createMatch(String user1Id, String user2Id);

  /// Check if a match already exists between two users
  Future<bool> matchExists(String user1Id, String user2Id);

  /// Get all matches for a user
  Future<List<MatchEntity>> getUserMatches(String userId);
}

