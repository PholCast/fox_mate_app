import 'dart:io';
import 'package:fox_mate_app/domain/repositories/event_repository.dart';

class CreateEventUsecase {
  final EventRepository _eventRepository;

  CreateEventUsecase(this._eventRepository);

  Future<void> execute({
    required String creatorId,
    required String creatorName,
    required String title,
    required String description,
    required DateTime eventDate,
    required String category,
    String? location,
    File? image,
  }) async {
    if (title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    if (description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }

    if (eventDate.isBefore(DateTime.now())) {
      throw Exception('Event date must be in the future');
    }

    return await _eventRepository.createEvent(
      creatorId: creatorId,
      creatorName: creatorName,
      title: title,
      description: description,
      eventDate: eventDate,
      category: category,
      location: location,
      image: image,
    );
  }
}