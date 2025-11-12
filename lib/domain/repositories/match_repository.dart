import 'package:fox_mate_app/domain/entities/match_entity.dart';

abstract class MatchRepository {
  Future<void> likeUser(String userId, String likedUserId);

  Future<bool> hasUserLiked(String userId, String likedUserId);

  Future<bool> checkMutualLike(String userId1, String userId2);

  Future<String> createMatch(String user1Id, String user2Id);

  Future<bool> matchExists(String user1Id, String user2Id);

  Future<List<MatchEntity>> getUserMatches(String userId);
}

