// lib/models/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String description;
  DateTime date;
  String location;
  String organizer;
  String eventType;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.eventType,
  });

  // Factory method to create an Event from Firestore document data
  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      organizer: data['organizer'] ?? '',
      eventType: data['eventType'] ?? '',
    );
  }

  // Method to convert Event to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'organizer': organizer,
      'eventType': eventType,
    };
  }
}
