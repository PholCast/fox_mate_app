import 'package:cloud_firestore/cloud_firestore.dart';

class MatchEntity {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;

  MatchEntity({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
  });

  factory MatchEntity.fromJson(Map<String, dynamic> json, String id) {
    return MatchEntity(
      id: id,
      user1Id: json['user1Id'] ?? '',
      user2Id: json['user2Id'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is DateTime) {
      return value;
    }
    throw ArgumentError('Invalid value for createdAt');
  }

  String getOtherUserId(String currentUserId) {
    if (user1Id == currentUserId) {
      return user2Id;
    } else if (user2Id == currentUserId) {
      return user1Id;
    }
    throw ArgumentError('Current user ID not found in match');
  }
}

