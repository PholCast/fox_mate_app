import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/domain/repositories/match_repository.dart';
import 'package:fox_mate_app/domain/repositories/notifications_repository.dart';
import 'package:fox_mate_app/domain/repositories/user_repository.dart';

class LikeUserUseCase {
  final MatchRepository _matchRepository;
  final NotificationsRepository _notificationsRepository;
  final UserRepository _userRepository;

  LikeUserUseCase(
    this._matchRepository,
    this._notificationsRepository,
    this._userRepository,
  );

  Future<bool> execute({
    required String currentUserId,
    required String likedUserId,
  }) async {
    if (currentUserId.isEmpty) {
      throw ArgumentError('Current user ID cannot be empty');
    }
    if (likedUserId.isEmpty) {
      throw ArgumentError('Liked user ID cannot be empty');
    }
    if (currentUserId == likedUserId) {
      throw ArgumentError('Cannot like yourself');
    }

    final alreadyLiked = await _matchRepository.hasUserLiked(currentUserId, likedUserId);
    if (alreadyLiked) {
      return false;
    }

    await _matchRepository.likeUser(currentUserId, likedUserId);

    final isMutual = await _matchRepository.checkMutualLike(currentUserId, likedUserId);

    if (isMutual) {
      final matchId = await _matchRepository.createMatch(currentUserId, likedUserId);

      final sender = await _userRepository.getUserProfile(currentUserId);
      final senderName = sender?.name ?? 'Alguien';

      final notification = MatchNotification(
        id: '',
        title: '¡Tú y $senderName hicieron match!',
        matchId: matchId,
        senderId: currentUserId,
        receiverId: likedUserId,
        isRead: false,
        createdAt: DateTime.now(),
      );
      await _notificationsRepository.createNotification(notification);

      final likedUser = await _userRepository.getUserProfile(likedUserId);
      final likedUserName = likedUser?.name ?? 'Alguien';

      final notificationForCurrentUser = MatchNotification(
        id: '',
        title: '¡Tú y $likedUserName hicieron match!',
        matchId: matchId,
        senderId: likedUserId,
        receiverId: currentUserId,
        isRead: false,
        createdAt: DateTime.now(),
      );
      await _notificationsRepository.createNotification(notificationForCurrentUser);

      return true;
    }

    return false;
  }
}

