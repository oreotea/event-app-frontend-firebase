// lib/screens/event_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventFormScreen extends StatefulWidget {
  final Event? initialEvent;

  const EventFormScreen({Key? key, this.initialEvent}) : super(key: key);

  @override
  _EventFormScreenState createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _date;
  late String _location;
  late String _organizer;
  late String _eventType;

  @override
  void initState() {
    super.initState();

    _title = widget.initialEvent?.title ?? '';
    _description = widget.initialEvent?.description ?? '';
    _date = widget.initialEvent?.date ?? DateTime.now();
    _location = widget.initialEvent?.location ?? '';
    _organizer = widget.initialEvent?.organizer ?? '';
    _eventType = widget.initialEvent?.eventType ?? 'Conference';
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialEvent == null ? 'Create Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (value) => _location = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _organizer,
                decoration: const InputDecoration(labelText: 'Organizer'),
                onSaved: (value) => _organizer = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _eventType,
                items: <String>['Conference', 'Workshop', 'Webinar']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Event Type'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Event Date'),
                subtitle: Text(
                  '${_date.toLocal()}'.split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _date) {
                      setState(() {
                        _date = pickedDate;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    final newEvent = Event(
                      id: widget.initialEvent?.id ?? '',
                      title: _title,
                      description: _description,
                      date: _date,
                      location: _location,
                      organizer: _organizer,
                      eventType: _eventType,
                    );

                    if (widget.initialEvent == null) {
                      // Create a new event
                      await eventProvider.createEvent(newEvent);
                    } else {
                      // Update the existing event
                      await eventProvider.updateEvent(newEvent);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.initialEvent == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
