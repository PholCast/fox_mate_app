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

List<Chat> getDummyChats() {
  return [
    Chat(
      id: '1',
      userId: '3',
      userName: 'Laura',
      userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800',
      lastMessage: '¡Hola! ¿Vamos a la biblioteca?',
      timestamp: DateTime.now().subtract(Duration(minutes: 15)),
      unreadCount: 2,
      isOnline: true,
      messages: [
        ChatMessage(
          id: '1',
          senderId: '3',
          text: '¡Hola! ¿Entendiste la última clase de cálculo? Me quedé con algunas dudas sobre las integrales dobles.',
          timestamp: DateTime.now().subtract(Duration(minutes: 32)),
          isMe: false,
        ),
        ChatMessage(
          id: '2',
          senderId: 'me',
          text: '¡Hola! Sí, algo así. La clave está en visualizar la región de integración. ¿Qué parte te complicó?',
          timestamp: DateTime.now().subtract(Duration(minutes: 31)),
          isMe: true,
        ),
        ChatMessage(
          id: '3',
          senderId: '3',
          text: 'El cambio de variables a coordenadas polares. No entiendo bien cuándo aplicarlo.',
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          isMe: false,
        ),
        ChatMessage(
          id: '4',
          senderId: 'me',
          text: 'Ah, es útil cuando la región es circular o un sector de un círculo. Simplifica mucho la integral. ¿Quieres que lo repasemos juntos antes del parcial?',
          timestamp: DateTime.now().subtract(Duration(minutes: 29)),
          isMe: true,
        ),
        ChatMessage(
          id: '5',
          senderId: '3',
          text: '¡Hola! ¿Vamos a la biblioteca?',
          timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          isMe: false,
        ),
      ],
    ),
    Chat(
      id: '2',
      userId: '2',
      userName: 'Carlos',
      userImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      lastMessage: 'Te envío los apuntes ahora',
      timestamp: DateTime.now().subtract(Duration(minutes: 18)),
      unreadCount: 0,
      isOnline: false,
      messages: [
        ChatMessage(
          id: '1',
          senderId: 'me',
          text: 'Hola Carlos, ¿tienes los apuntes de la clase de ayer?',
          timestamp: DateTime.now().subtract(Duration(minutes: 25)),
          isMe: true,
        ),
        ChatMessage(
          id: '2',
          senderId: '2',
          text: 'Te envío los apuntes ahora',
          timestamp: DateTime.now().subtract(Duration(minutes: 18)),
          isMe: false,
        ),
      ],
    ),
    Chat(
      id: '3',
      userId: '5',
      userName: 'Sofía',
      userImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
      lastMessage: 'Jajaja, ¡qué bueno!',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      unreadCount: 0,
      isOnline: false,
      messages: [
        ChatMessage(
          id: '1',
          senderId: 'me',
          text: '¿Cómo te fue en el examen?',
          timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
          isMe: true,
        ),
        ChatMessage(
          id: '2',
          senderId: '5',
          text: 'Jajaja, ¡qué bueno!',
          timestamp: DateTime.now().subtract(Duration(days: 1)),
          isMe: false,
        ),
      ],
    ),
    Chat(
      id: '4',
      userId: '4',
      userName: 'David',
      userImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800',
      lastMessage: '¿Quedamos para el proyecto?',
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      unreadCount: 0,
      isOnline: false,
      messages: [
        ChatMessage(
          id: '1',
          senderId: '4',
          text: '¿Quedamos para el proyecto?',
          timestamp: DateTime.now().subtract(Duration(days: 2)),
          isMe: false,
        ),
      ],
    ),
  ];
}