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
    required String senderId,   // User who triggered the match (current user)
    required String receiverId, // User who should receive the notification
    required String matchId,    // The match document ID (optional but useful)
  }) async {
    if (senderId.isEmpty) throw ArgumentError('Sender ID is empty');
    if (receiverId.isEmpty) throw ArgumentError('Receiver ID is empty');

    // Get sender data (for name)
    // final sender = await _userRepository.getUserById(senderId);

    // Build the notification title
    final title = '¡Tú y sender.name hicieron match! '; //we use sender name here

    // Create a new MatchNotification object
    final notification = MatchNotification(
      id: '',
      title: title,
      matchId: matchId,
      senderId: senderId,
      receiverId: receiverId,
      isRead: false,
      createdAt: DateTime.now(),
    );

    // Send (save) the notification
    await _notificationsRepository.createNotification(notification);
  }
}
