import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository _notificationsRepository;

  GetNotificationsUseCase(this._notificationsRepository);

  Future<List<MatchNotification>> execute({
    required String userId,
    int limit = 20,
    DateTime? startAfter,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID is empty');
    }
    return await _notificationsRepository.getNotification(
      userId,
      limit: limit,
      startAfter: startAfter,
    );
  }
}
