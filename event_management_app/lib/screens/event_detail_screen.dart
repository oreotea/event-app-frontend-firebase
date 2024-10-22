// lib/screens/event_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final EventProvider eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/eventForm',
                arguments: event,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await _showDeleteConfirmationDialog(context);
              if (shouldDelete) {
                await eventProvider.deleteEvent(event.id);
                Navigator.pop(context); // Go back to the previous screen after deletion
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Description: ${event.description}'),
                const SizedBox(height: 8),
                Text('Date: ${event.date.toLocal()}'),
                const SizedBox(height: 8),
                Text('Location: ${event.location}'),
                const SizedBox(height: 8),
                Text('Organizer: ${event.organizer}'),
                const SizedBox(height: 8),
                Text('Event Type: ${event.eventType}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false; 
  }
}
