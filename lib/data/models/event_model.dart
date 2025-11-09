// lib/data/models/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fox_mate_app/domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.creatorId,
    required super.creatorName,
    required super.title,
    required super.description,
    required super.eventDate,
    required super.createdAt,
    super.imageUrl,
    super.location,
    required super.category,
    required super.attendees,
    required super.attendeesCount,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String id) {
    return EventModel(
      id: id,
      creatorId: json['creatorId'] ?? '',
      creatorName: json['creatorName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventDate: (json['eventDate'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'],
      location: json['location'],
      category: json['category'] ?? '',
      attendees: List<String>.from(json['attendees'] ?? []),
      attendeesCount: json['attendeesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creatorId': creatorId,
      'creatorName': creatorName,
      'title': title,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
      'location': location,
      'category': category,
      'attendees': attendees,
      'attendeesCount': attendeesCount,
    };
  }

  factory EventModel.fromEntity(EventEntity event) {
    return EventModel(
      id: event.id,
      creatorId: event.creatorId,
      creatorName: event.creatorName,
      title: event.title,
      description: event.description,
      eventDate: event.eventDate,
      createdAt: event.createdAt,
      imageUrl: event.imageUrl,
      location: event.location,
      category: event.category,
      attendees: event.attendees,
      attendeesCount: event.attendeesCount,
    );
  }
}

// Mantén esta función para testing
List<EventModel> getDummyEvents() {
  return [
    EventModel(
      id: '1',
      creatorId: 'dummy1',
      creatorName: 'Juan Pérez',
      title: 'Torneo de FIFA',
      description: '¡Demuestra quién es el mejor en la cancha virtual!',
      eventDate: DateTime.now().add(Duration(days: 2, hours: 18)),
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800',
      category: 'Deportivos',
      attendees: [],
      attendeesCount: 0,
    ),
    EventModel(
      id: '2',
      creatorId: 'dummy2',
      creatorName: 'María González',
      title: 'Grupo de estudio para cálculo',
      description: '¿Luchando con las derivadas? ¡No estás solo!',
      eventDate: DateTime.now().add(Duration(days: 3, hours: 15, minutes: 30)),
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      category: 'Académicos',
      attendees: [],
      attendeesCount: 0,
    ),
  ];
}