// lib/screens/event_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String _selectedEventType = 'All'; 

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = _selectedEventType == 'All'
        ? eventProvider.events
        : eventProvider.events
            .where((event) => event.eventType == _selectedEventType)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
        actions: [
          DropdownButton<String>(
            value: _selectedEventType,
            items: <String>['All', 'Conference', 'Workshop', 'Webinar']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedEventType = value!;
              });
            },
          ),
        ],
      ),
      body: eventProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final Event event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      event.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/eventDetail',
                        arguments: event,
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/eventForm');
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Event',
      ),
    );
  }
}
