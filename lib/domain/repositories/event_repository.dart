import 'dart:io';
import 'package:fox_mate_app/domain/entities/event_entity.dart';

abstract class EventRepository {
  Stream<List<EventEntity>> getEvents({int limit = 10});
  Future<List<EventEntity>> getEventsPaginated({
    required int limit,
    EventEntity? lastEvent,
  });
  Future<void> createEvent({
    required String creatorId,
    required String creatorName,
    required String title,
    required String description,
    required DateTime eventDate,
    required String category,
    String? location,
    File? image,
  });
  Future<void> toggleAttendance(String eventId, String userId);
  Future<void> deleteEvent(String eventId);
}