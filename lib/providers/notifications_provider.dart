import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/domain/usecases/get_notifications.dart';
import 'package:fox_mate_app/domain/usecases/get_notifications_stream_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_unread_notifications_count_stream.dart';
import 'package:fox_mate_app/domain/usecases/mark_notifications_as_read_usecase.dart';

enum NotificationStatus { initial, loading, success, error, loadingMore }

enum NotificationFilter { all, unread, read }

class NotificationsProvider extends ChangeNotifier {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetNotificationsStreamUseCase getNotificationsStreamUseCase;
  final MarkNotificationsAsReadUseCase markNotificationsAsReadUseCase;
  final GetUnreadNotificationsCountStreamUseCase
  getUnreadNotificationsCountStreamUseCase;

  NotificationsProvider({
    required this.getNotificationsUseCase,
    required this.getNotificationsStreamUseCase,
    required this.markNotificationsAsReadUseCase,
    required this.getUnreadNotificationsCountStreamUseCase,
  });

  NotificationStatus _state = NotificationStatus.initial;
  NotificationStatus get state => _state;

  List<MatchNotification> _notifications = [];
  List<MatchNotification> get notifications => List.unmodifiable(_notifications);

  int _unreadNotificationsCount = 0;
  int get unreadNotificationsCount => _unreadNotificationsCount;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  StreamSubscription<List<MatchNotification>>? _notificationsStreamSubscription;
  StreamSubscription<int>? _unreadNotificationsCountStreamSubscription;

  NotificationFilter _filter = NotificationFilter.all;
  NotificationFilter get filter => _filter;

  void initializeNotifications(String userId) {
    if (userId.isEmpty) return;

    _state = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    _notificationsStreamSubscription?.cancel();
    _unreadNotificationsCountStreamSubscription?.cancel();

    _notificationsStreamSubscription = getNotificationsStreamUseCase
        .execute(userId)
        .listen(
          (notifications) {
            _notifications = notifications;
            _state = NotificationStatus.success;
            _errorMessage = null;
            notifyListeners();
          },
          onError: (error) {
            _state = NotificationStatus.error;
            _errorMessage = error.toString();
            notifyListeners();
          },
        );

    _unreadNotificationsCountStreamSubscription =
        getUnreadNotificationsCountStreamUseCase
            .execute(userId)
            .listen(
              (unreadCount) {
                _unreadNotificationsCount = unreadCount;
                notifyListeners();
              },
              onError: (error) {
                print(error);
              },
            );
  }

  Future<void> loadMoreNotifications(String userId) async {
    if (!hasMore || state == NotificationStatus.loadingMore) return;

    try {
      _state = NotificationStatus.loadingMore;
      notifyListeners();

      final lastNotification =
          _notifications.isNotEmpty ? _notifications.last : null;
      final result = await getNotificationsUseCase.execute(
        userId: userId,
        limit: 20,
        startAfter: lastNotification?.createdAt,
      );

      if (result.isEmpty) {
        _hasMore = false;
      } else {
        Set existingIds = _notifications.map((n) => n.id).toSet();
        final newNotifications =
            result.where((n) => !existingIds.contains(n.id)).toList();
        _notifications.addAll(newNotifications);
      }
      _state = NotificationStatus.success;
      notifyListeners();
    } catch (e) {
      print('Error loading more notifications: $e');
      _state = NotificationStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> markNotificationsAsRead(String notificationId) async {
    try {
      await markNotificationsAsReadUseCase.execute(notificationId);

      final index = _notifications.indexWhere((n) => n.id == notificationId);

      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _unreadNotificationsCount--;
        notifyListeners();
      }

    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  void setFilter(NotificationFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  List<MatchNotification> get filteredNotifications {
    switch (_filter) {
      case NotificationFilter.all:
        return _notifications;
      case NotificationFilter.unread:
        return _notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.read:
        return _notifications.where((n) => n.isRead).toList();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _state = NotificationStatus.initial;
    _errorMessage = null;
    _notifications = [];
    _unreadNotificationsCount = 0;
    _hasMore = true;
    _filter = NotificationFilter.all;
    _notificationsStreamSubscription?.cancel();
    _unreadNotificationsCountStreamSubscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationsStreamSubscription?.cancel();
    _unreadNotificationsCountStreamSubscription?.cancel();
    super.dispose();
  }
}
