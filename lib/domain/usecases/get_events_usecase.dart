// lib/domain/usecases/get_events_usecase.dart
import 'package:fox_mate_app/domain/entities/event_entity.dart';
import 'package:fox_mate_app/domain/repositories/event_repository.dart';

class GetEventsUsecase {
  final EventRepository _eventRepository;

  GetEventsUsecase(this._eventRepository);

  Stream<List<EventEntity>> execute() {
    return _eventRepository.getEvents();
  }
}