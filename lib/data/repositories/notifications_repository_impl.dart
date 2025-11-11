import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final FirebaseFirestore _firestore;

  NotificationsRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  static const String collectionName = 'notifications';

  @override
  Stream<List<MatchNotification>> getNotificationStream(String userId) {
    return _firestore
        .collection(collectionName)
        .where('receiverId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return MatchNotification.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<List<MatchNotification>> getNotification(
    String userId, {
    int limit = 20,
    DateTime? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection(collectionName)
          .where('receiverId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      query = query.limit(limit);

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return MatchNotification.fromJson(data);
      }).toList();
    } catch (e) {
      print('Failed to get notifications: $e');
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection(collectionName).doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Failed to mark notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> createNotification(MatchNotification notification) async {
    try {
      final docRef = _firestore.collection(collectionName).doc();
      final notificationData = notification.copyWith(id: docRef.id);
      await docRef.set(notificationData.toJson());
    } catch (e) {
      print('Failed to create notification: $e');
      throw Exception('Failed to create notification: $e');
    }
  }



  @override
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final snapshots =
          await _firestore
              .collection(collectionName)
              .where('receiverId', isEqualTo: userId)
              .where('isRead', isEqualTo: false)
              .get();

      return snapshots.docs.length;
    } catch (e) {
      print('Failed to get unread notification count: $e');
      throw Exception('Failed to get unread notification count: $e');
    }
  }

  @override
  Stream<int> getUnreadNotificationCountStream(String userId) {
    return _firestore
        .collection(collectionName)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
