// lib/providers/event_provider.dart
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  List<Event> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Load events from Firestore
  void loadEvents() {
    _isLoading = true;
    notifyListeners();

    _eventService.getAllEvents().listen((eventList) {
      _events = eventList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
      // Handle error if needed
    });
  }

  // Create a new event
  Future<void> createEvent(Event event) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Create a new event using the EventService
      await _eventService.createEvent(event);
      loadEvents(); // Refresh the list of events after creating a new one
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _eventService.updateEvent(event);
      loadEvents(); // Refresh the list of events after updating
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete an event
  Future<void> deleteEvent(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _eventService.deleteEvent(id);
      _events.removeWhere((event) => event.id == id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
