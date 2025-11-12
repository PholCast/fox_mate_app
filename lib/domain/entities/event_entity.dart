import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String creatorId;
  final String creatorName;
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime createdAt;
  final String? imageUrl;
  final String? location;
  final String category;
  final List<String> attendees;
  final int attendeesCount;

  const EventEntity({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.createdAt,
    this.imageUrl,
    this.location,
    required this.category,
    required this.attendees,
    required this.attendeesCount,
  });

  bool isUserAttending(String userId) {
    return attendees.contains(userId);
  }

  @override
  List<Object?> get props => [
        id,
        creatorId,
        creatorName,
        title,
        description,
        eventDate,
        createdAt,
        imageUrl,
        location,
        category,
        attendees,
        attendeesCount,
      ];
}