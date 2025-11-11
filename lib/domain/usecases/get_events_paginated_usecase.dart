// lib/domain/usecases/get_events_paginated_usecase.dart
import 'package:fox_mate_app/domain/entities/event_entity.dart';
import 'package:fox_mate_app/domain/repositories/event_repository.dart';

class GetEventsPaginatedUsecase {
  final EventRepository _eventRepository;

  GetEventsPaginatedUsecase(this._eventRepository);

  Future<List<EventEntity>> execute({
    required int limit,
    EventEntity? lastEvent,
  }) {
    return _eventRepository.getEventsPaginated(
      limit: limit,
      lastEvent: lastEvent,
    );
  }
}