import 'package:cloud_firestore/cloud_firestore.dart';

class MatchNotification {
  final String id;
  final String title;
  final String matchId;
  final String senderId;
  final String receiverId;
  final bool isRead;
  final DateTime createdAt;

  MatchNotification({
    required this.id,
    required this.title,
    required this.matchId,
    required this.senderId,
    required this.receiverId,
    required this.isRead,
    required this.createdAt,
  });

  MatchNotification copyWith({
    String? id,
    String? title,
    String? matchId,
    String? senderId,
    String? receiverId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MatchNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      matchId: matchId ?? this.matchId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MatchNotification.fromJson(Map<String, dynamic> json) {
    return MatchNotification(
      id: json['id'],
      title: json['title'],
      matchId: json['matchId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      isRead: json['isRead'] ?? false,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'matchId': matchId,
      'senderId': senderId,
      'receiverId': receiverId,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is DateTime) {
      return value;
    }
    throw ArgumentError('Invalid value for createdAt');
  }

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, matchId: $matchId, senderId: $senderId, receiverId: $receiverId, isRead: $isRead, createdAt: $createdAt)';
  }
}
