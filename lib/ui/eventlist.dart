import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_app/services/events.dart';

class EventListScreen extends StatelessWidget {
  final DateTime selectedDay;
  final List<Event> events;

  EventListScreen({required this.selectedDay, required this.events});

  @override
  Widget build(BuildContext context) {
    print("Selected Day: $selectedDay");
    print("Events: $events");

    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${DateFormat('MMMM d, y').format(selectedDay)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events for ${DateFormat('MMMM d, y').format(selectedDay)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (events.isEmpty)
              Text('No events for this day.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    Event event = events[index];
                    print("Event: $event");

                    DateTime localEventTime = event.date.toLocal();

                    DateTime selectedDayUtc = DateTime.utc(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    );

                    bool isSameDay = localEventTime.year == selectedDayUtc.year &&
                        localEventTime.month == selectedDayUtc.month &&
                        localEventTime.day == selectedDayUtc.day;

                    if (isSameDay) {
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.description ?? ''),
                        trailing: Text(
                          DateFormat('HH:mm').format(localEventTime),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
