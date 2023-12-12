import 'package:calendar_app/services/auth.dart';
import 'package:calendar_app/services/events.dart';
// import 'package:calendar_app/ui/authui.dart';
import 'package:calendar_app/ui/eventlist.dart';
import 'package:calendar_app/ui/eventscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_app/services/notification.dart';
import 'package:calendar_app/services/themeservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyManager;
  DateTime _selectedDay = DateTime.now(); 
  List<Event> _events = []; 
  User? _user;

  @override
  void initState() {
    super.initState();
    notifyManager = NotificationManager();
    notifyManager.initializeNotification();
    notifyManager.requestIOSPermissions();
    _loadFirestoreEvents();
    _getCurrentUser();
  }

  _loadFirestoreEvents() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('events').get();
      _events = snapshot.docs
          .map((doc) => Event.fromFirestore(doc))
          .toList(growable: false);
      setState(() {});
    } catch (error) {
      print('Error loading events: $error');
    }
  }

  _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      // , ${_user?.displayName ?? 'Guest'}!
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Welcome back!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  backgroundImage: _user?.photoURL != null
                      ? NetworkImage(_user!.photoURL!)
                      : null, 
                  child: _user?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                        ) 
                      : null,
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTableCalendar(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 4),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEventScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(
                    Icons.event,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      focusedDay: _selectedDay,
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        headerMargin: EdgeInsets.only(bottom: 8),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.blue
              : Colors.red,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(color: Colors.white),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventListScreen(
              selectedDay: selectedDay,
              events: _events
                  .where((event) =>
                      isSameDay(event.date, selectedDay.toUtc()))
                  .toList(),
            ),
          ),
        );
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _selectedDay = focusedDay;
        });
        _loadFirestoreEvents();
      },
    );
  }

_appBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        ThemeServices().switchTheme();
      },
      child: Icon(
        Icons.nightlight_round,
        size: 20,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () async {
          await AuthService().signOut();
          Navigator.pushReplacementNamed(context, '/sign_in');
        },
      ),
    ],
  );
 }
}