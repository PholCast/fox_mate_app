import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';

class SendMatchNotificationUseCase {
  final NotificationsRepository _notificationsRepository;
  final UserRepository _userRepository;

  SendMatchNotificationUseCase(
    this._notificationsRepository,
    this._userRepository,
  );

  Future<void> execute({
    required String senderId,   
    required String receiverId,
    required String matchId,
  }) async {
    if (senderId.isEmpty) throw ArgumentError('Sender ID is empty');
    if (receiverId.isEmpty) throw ArgumentError('Receiver ID is empty');

    final title = '¡Tú y sender.name hicieron match! ';

    final notification = MatchNotification(
      id: '',
      title: title,
      matchId: matchId,
      senderId: senderId,
      receiverId: receiverId,
      isRead: false,
      createdAt: DateTime.now(),
    );

    await _notificationsRepository.createNotification(notification);
  }
}
