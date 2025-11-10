// lib/providers/event_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fox_mate_app/domain/entities/event_entity.dart';
import 'package:fox_mate_app/domain/usecases/create_event_usecase.dart';
import 'package:fox_mate_app/domain/usecases/get_events_usecase.dart';
import 'package:fox_mate_app/domain/usecases/toggle_attendance_usecase.dart';

enum EventStatus { initial, loading, success, error }

class EventProvider extends ChangeNotifier {
  final GetEventsUsecase _getEventsUsecase;
  final CreateEventUsecase _createEventUsecase;
  final ToggleAttendanceUsecase _toggleAttendanceUsecase;

  EventProvider(
    this._getEventsUsecase,
    this._createEventUsecase,
    this._toggleAttendanceUsecase,
  ) {
    _initializeEvents();
  }

  EventStatus _status = EventStatus.initial;
  List<EventEntity> _events = [];
  String? _errorMessage;
  StreamSubscription<List<EventEntity>>? _eventsSubscription;

  EventStatus get status => _status;
  List<EventEntity> get events => _events;
  String? get errorMessage => _errorMessage;

  void _initializeEvents() {
    _status = EventStatus.loading;
    notifyListeners();

    _eventsSubscription = _getEventsUsecase.execute().listen(
      (events) {
        _events = events;
        _status = EventStatus.success;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _status = EventStatus.error;
        notifyListeners();
      },
    );
  }

  Future<void> createEvent({
    required String creatorId,
    required String creatorName,
    required String title,
    required String description,
    required DateTime eventDate,
    required String category,
    String? location,
    File? image,
  }) async {
    try {
      _status = EventStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _createEventUsecase.execute(
        creatorId: creatorId,
        creatorName: creatorName,
        title: title,
        description: description,
        eventDate: eventDate,
        category: category,
        location: location,
        image: image,
      );

      _status = EventStatus.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = EventStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleAttendance(String eventId, String userId) async {
    try {
      await _toggleAttendanceUsecase.execute(eventId, userId);
      // El stream actualizará automáticamente la UI
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_status == EventStatus.error) {
      _status = _events.isNotEmpty ? EventStatus.success : EventStatus.initial;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }
}