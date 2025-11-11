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
  List<Chat> chats = getDummyChats();
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

  List<Chat> getFilteredChats() {
    if (searchQuery.isEmpty) {
      return chats;
    }
    return chats.where((chat) {
      final nameLower = chat.userName.toLowerCase();
      final messageLower = chat.lastMessage.toLowerCase();
      final queryLower = searchQuery.toLowerCase();
      return nameLower.contains(queryLower) || messageLower.contains(queryLower);
    }).toList();
  }

  String _getTimeString(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Hoy - mostrar hora
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
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
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
    final filteredChats = getFilteredChats();

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
              'Chats',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.padding, vertical: 12),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar chats',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),

              // Divisor
              Divider(height: 1, color: Colors.grey[200]),

              // Lista de chats y notificaciones
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    // Chats section
                    if (filteredChats.isNotEmpty) ...[
                      ...filteredChats.map((chat) => _buildChatItem(chat)),
                    ] else if (notifications.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No hay chats',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),

                    // Notifications section
                    if (notifications.isNotEmpty) ...[
                      if (filteredChats.isNotEmpty)
                        Divider(height: 1, color: Colors.grey[200]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Spacing.padding,
                          vertical: 12,
                        ),
                        child: Text(
                          'Notificaciones',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
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

  Widget _buildChatItem(Chat chat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagesScreen(chat: chat),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.padding,
          vertical: 12,
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(chat.userImage),
            ),
            SizedBox(width: 12),

            // Nombre y mensaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getTimeString(chat.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: chat.unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          child: Center(
                            child: Text(
                              '${chat.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        // TODO: Navigate to match or chat screen
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