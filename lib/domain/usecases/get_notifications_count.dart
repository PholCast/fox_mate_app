import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';

class GetNotificationsCountUseCase {
  final NotificationsRepository _notificationsRepository;

  GetNotificationsCountUseCase(this._notificationsRepository);

  Future<int> execute(String userId) async {
    if(userId.isEmpty){
      throw ArgumentError('User ID is empty');
    }
    return await _notificationsRepository.getUnreadNotificationCount(userId);
  }
}