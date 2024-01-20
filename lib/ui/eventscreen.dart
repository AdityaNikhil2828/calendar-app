import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calendar_app/services/events.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ))!;
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = (await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ))!;
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${_selectedDate.toLocal()}".split(' ')[0],
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Time',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${_selectedTime.format(context)}",
                    ),
                    Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveEvent();
                Navigator.pop(context);
              },
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent() async {
    final event = Event(
      title: _titleController.text,
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      description: _descriptionController.text,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> eventMap = event.toFirestore();
      await firestore.collection('events').add(eventMap);
      print('Event saved successfully!');
    } catch (error) {
      print('Error saving event: $error');
    }
  }
}
