// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class FirestoreService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  // Get all events (real-time updates)
  Stream<List<Event>> getEvents() {
    try {
      return eventCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
    } catch (e) {
      print('Failed to get events: $e');
      rethrow;
    }
  }

  // Get event by ID
  Future<Event?> getEventById(String id) async {
    try {
      DocumentSnapshot doc = await eventCollection.doc(id).get();
      if (doc.exists) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Failed to get event by ID: $e');
      return null;
    }
  }

  // Create a new event
  Future<void> createEvent(Event event) async {
    try {
      await eventCollection.add(event.toMap());
      print('Event created successfully');
    } catch (e) {
      print('Failed to create event: $e');
      throw Exception('Failed to create event');
    }
  }

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    try {
      if (event.id.isNotEmpty) {
        await eventCollection.doc(event.id).update(event.toMap());
        print('Event updated successfully');
      } else {
        print('Event ID is empty, cannot update');
        throw Exception('Invalid event ID');
      }
    } catch (e) {
      print('Failed to update event: $e');
      throw Exception('Failed to update event');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String id) async {
    try {
      await eventCollection.doc(id).delete();
      print('Event deleted successfully');
    } catch (e) {
      print('Failed to delete event: $e');
      throw Exception('Failed to delete event');
    }
  }
}
