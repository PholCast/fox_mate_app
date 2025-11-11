class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class Chat {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;
  final List<ChatMessage> messages;

  Chat({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.messages,
  });
}