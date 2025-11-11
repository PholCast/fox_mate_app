import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/constants/spacing.dart';
import 'package:fox_mate_app/data/models/chat_model.dart';
import 'package:fox_mate_app/domain/entities/match_notification.dart';
import 'package:fox_mate_app/presentation/screens/chat/messages_screen.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';
import 'package:fox_mate_app/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';


  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final notificationsProvider = context.read<NotificationsProvider>();

      if (authProvider.currentUser != null) {
        notificationsProvider.initializeNotifications(
          authProvider.currentUser!.id,
        );
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

    _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final authProvider = context.read<AuthProvider>();
      final notificationsProvider = context.read<NotificationsProvider>();
      if (authProvider.currentUser != null && notificationsProvider.hasMore) {
        notificationsProvider.loadMoreNotifications(
          authProvider.currentUser!.id,
        );
      }
    }
  }

  String _getNotificationTimeString(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays == 0) {
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        final notifications = notificationsProvider.filteredNotifications;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: Spacing.padding,
            centerTitle: false,
            title: Text(
              'Notificaciones',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Column(
            children: [
              // Divisor
              Divider(height: 1, color: Colors.grey[200]),

              // Lista de chats y notificaciones
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    // Chats section
                    if (notifications.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No hay Notificaciones',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),

                    // Notifications section
                    if (notifications.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.padding,
                          vertical: 12,
                        ),
                      ),
                      ...notifications.map((notification) => _buildNotificationItem(
                            notification,
                            notificationsProvider,
                          )),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(
    MatchNotification notification,
    NotificationsProvider notificationsProvider,
  ) {
    return InkWell(
      onTap: () {
        // Mark as read when tapped
        if (!notification.isRead) {
          notificationsProvider.markNotificationsAsRead(notification.id);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.padding,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.grey[50],
        ),
        child: Row(
          children: [
            // Notification icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: CustomColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                color: CustomColors.primaryColor,
                size: 28,
              ),
            ),
            SizedBox(width: 12),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: notification.isRead
                                ? Colors.grey[700]
                                : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _getNotificationTimeString(notification.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (!notification.isRead) ...[
                    SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}