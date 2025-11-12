import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_mate_app/domain/entities/match_entity.dart';
import 'package:fox_mate_app/domain/repositories/match_repository.dart';

class MatchRepositoryImpl implements MatchRepository {
  final FirebaseFirestore _firestore;
  static const String _likesCollection = 'likes';
  static const String _matchesCollection = 'matches';

  MatchRepositoryImpl(this._firestore);

  @override
  Future<void> likeUser(String userId, String likedUserId) async {
    try {

      final likeId = '${userId}_$likedUserId';
      await _firestore.collection(_likesCollection).doc(likeId).set({
        'userId': userId,
        'likedUserId': likedUserId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to like user: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasUserLiked(String userId, String likedUserId) async {
    try {
      final likeId = '${userId}_$likedUserId';
      final doc = await _firestore.collection(_likesCollection).doc(likeId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check if user liked: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkMutualLike(String userId1, String userId2) async {
    try {
      final like1 = await hasUserLiked(userId1, userId2);
      final like2 = await hasUserLiked(userId2, userId1);
      return like1 && like2;
    } catch (e) {
      throw Exception('Failed to check mutual like: ${e.toString()}');
    }
  }

  @override
  Future<String> createMatch(String user1Id, String user2Id) async {
    try {
      final exists = await matchExists(user1Id, user2Id);
      if (exists) {
        final matches = await _getMatchesBetweenUsers(user1Id, user2Id);
        if (matches.isNotEmpty) {
          return matches.first.id;
        }
      }

      final sortedIds = [user1Id, user2Id]..sort();
      final matchData = {
        'user1Id': sortedIds[0],
        'user2Id': sortedIds[1],
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_matchesCollection).add(matchData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create match: ${e.toString()}');
    }
  }

  @override
  Future<bool> matchExists(String user1Id, String user2Id) async {
    try {
      final matches = await _getMatchesBetweenUsers(user1Id, user2Id);
      return matches.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if match exists: ${e.toString()}');
    }
  }

  Future<List<MatchEntity>> _getMatchesBetweenUsers(String user1Id, String user2Id) async {
    final sortedIds = [user1Id, user2Id]..sort();
    
    final query1 = await _firestore
        .collection(_matchesCollection)
        .where('user1Id', isEqualTo: sortedIds[0])
        .where('user2Id', isEqualTo: sortedIds[1])
        .get();

    if (query1.docs.isNotEmpty) {
      return query1.docs.map((doc) => MatchEntity.fromJson(doc.data(), doc.id)).toList();
    }

    return [];
  }

  @override
  Future<List<MatchEntity>> getUserMatches(String userId) async {
    try {
      final query1 = await _firestore
          .collection(_matchesCollection)
          .where('user1Id', isEqualTo: userId)
          .get();

      final query2 = await _firestore
          .collection(_matchesCollection)
          .where('user2Id', isEqualTo: userId)
          .get();

      final matches = <MatchEntity>[];
      
      matches.addAll(query1.docs.map((doc) => MatchEntity.fromJson(doc.data(), doc.id)));
      matches.addAll(query2.docs.map((doc) => MatchEntity.fromJson(doc.data(), doc.id)));

      return matches;
    } catch (e) {
      throw Exception('Failed to get user matches: ${e.toString()}');
    }
  }
}

