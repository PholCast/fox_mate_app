import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';

class GetUnreadNotificationsCountStreamUseCase {
  final NotificationsRepository _notificationsRepository;

  GetUnreadNotificationsCountStreamUseCase(this._notificationsRepository);

  Stream<int> execute(String userId) {
    if(userId.isEmpty){
      throw ArgumentError('User ID is empty');
    }
    return _notificationsRepository.getUnreadNotificationCountStream(userId);
  }
} 