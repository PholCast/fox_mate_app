// lib/data/repositories/event_repository_impl.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fox_mate_app/data/models/event_model.dart';
import 'package:fox_mate_app/domain/entities/event_entity.dart';
import 'package:fox_mate_app/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  EventRepositoryImpl(this._firestore, this._storage);

  @override
  Stream<List<EventEntity>> getEvents() {
    return _firestore
        .collection('events')
        .orderBy('eventDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
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
      String? imageUrl;

      // Si hay imagen, subirla a Firebase Storage
      if (image != null) {
        imageUrl = await _uploadImage(image, creatorId);
      }

      // Crear el evento en Firestore
      final eventData = EventModel(
        id: '',
        creatorId: creatorId,
        creatorName: creatorName,
        title: title,
        description: description,
        eventDate: eventDate,
        createdAt: DateTime.now(),
        imageUrl: imageUrl,
        location: location,
        category: category,
        attendees: [],
        attendeesCount: 0,
      ).toJson();

      await _firestore.collection('events').add(eventData);
    } catch (e) {
      throw Exception('Error creating event: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleAttendance(String eventId, String userId) async {
    try {
      final eventRef = _firestore.collection('events').doc(eventId);
      
      await _firestore.runTransaction((transaction) async {
        final eventDoc = await transaction.get(eventRef);
        
        if (!eventDoc.exists) {
          throw Exception('Event not found');
        }

        final data = eventDoc.data()!;
        final attendees = List<String>.from(data['attendees'] ?? []);
        
        if (attendees.contains(userId)) {
          // Remover asistencia
          attendees.remove(userId);
        } else {
          // Agregar asistencia
          attendees.add(userId);
        }

        transaction.update(eventRef, {
          'attendees': attendees,
          'attendeesCount': attendees.length,
        });
      });
    } catch (e) {
      throw Exception('Error toggling attendance: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      
      if (doc.exists) {
        final data = doc.data();
        final imageUrl = data?['imageUrl'] as String?;
        
        // Eliminar imagen de Storage si existe
        if (imageUrl != null) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(imageUrl);
            await ref.delete();
          } catch (e) {
            print('Error deleting image: $e');
          }
        }
        
        // Eliminar el documento
        await _firestore.collection('events').doc(eventId).delete();
      }
    } catch (e) {
      throw Exception('Error deleting event: ${e.toString()}');
    }
  }

  Future<String> _uploadImage(File image, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${userId}.jpg';
      final ref = _storage.ref().child('events').child(fileName);
      
      final uploadTask = await ref.putFile(image);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: ${e.toString()}');
    }
  }
}