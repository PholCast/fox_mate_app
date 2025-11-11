import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';

class GetNotificationsStreamUseCase {
  final NotificationsRepository _notificationsRepository;

  GetNotificationsStreamUseCase(this._notificationsRepository);

  Stream<List<MatchNotification>> execute(String userId) {
    if(userId.isEmpty){
      throw ArgumentError('User ID is empty');
    }
    return _notificationsRepository.getNotificationStream(userId);
  }
}