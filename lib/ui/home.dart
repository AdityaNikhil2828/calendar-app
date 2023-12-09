import 'package:calendar_app/services/notification.dart';
import 'package:calendar_app/services/themeservice.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyManager;

  @override
  void initState() {
    super.initState();
    notifyManager = NotificationManager();
    notifyManager.initializeNotification();
    notifyManager.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.blue // Light mode background color
                    : Colors.red, // Dark mode background color
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
        },
        child: Icon(Icons.nightlight_round, size: 20,),
      ),
      actions: [
        CircleAvatar(),
        SizedBox(width: 20,),
      ],
    );
  }
}
