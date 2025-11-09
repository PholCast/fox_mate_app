// lib/domain/usecases/toggle_attendance_usecase.dart
import 'package:fox_mate_app/domain/repositories/event_repository.dart';

class ToggleAttendanceUsecase {
  final EventRepository _eventRepository;

  ToggleAttendanceUsecase(this._eventRepository);

  Future<void> execute(String eventId, String userId) async {
    return await _eventRepository.toggleAttendance(eventId, userId);
  }
}