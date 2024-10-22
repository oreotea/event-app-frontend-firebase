// lib/services/event_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  // Fetch all events as a stream
  Stream<List<Event>> getAllEvents() {
    try {
      return eventCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) {
            return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList());
    } catch (e) {
      print('Error fetching events: $e');
      // Return an empty stream if there is an error
      return Stream.value([]);
    }
  }

  // Get a single event by ID
  Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await eventCollection.doc(eventId).get();
      if (doc.exists) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching event by ID: $e');
      return null;
    }
  }

  // Create a new event
  Future<void> createEvent(Event event) async {
    try {
      await eventCollection.add(event.toMap());
    } catch (e) {
      print('Error creating event: $e');
      throw Exception('Failed to create event');
    }
  }

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    if (event.id.isEmpty) {
      throw Exception('Event ID is required for updating');
    }
    try {
      await eventCollection.doc(event.id).update(event.toMap());
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Failed to update event');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await eventCollection.doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
      throw Exception('Failed to delete event');
    }
  }
}
