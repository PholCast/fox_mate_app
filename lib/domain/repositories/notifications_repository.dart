import 'package:fox_mate_app/domain/entities/match_notification.dart';

abstract class NotificationsRepository {
  Stream<List<MatchNotification>> getNotificationStream(String userId);

  Future<List<MatchNotification>> getNotification(
    String userId, {
    int limit = 20,
    DateTime? startAfter,
  });

  Future<void> markNotificationAsRead(String notificationId);

  Future<void> createNotification(MatchNotification notification);

  Future<int> getUnreadNotificationCount(String userId);

  Stream<int> getUnreadNotificationCountStream(String userId);
}
