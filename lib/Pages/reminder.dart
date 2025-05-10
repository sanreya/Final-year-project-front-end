import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as _tz;
import 'package:health/Pages/Alarm.dart';


class ReminderPage extends StatefulWidget {
  ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final TextEditingController _tabletNameController = TextEditingController();
  String _frequency = 'Every day';
  String _dosage = 'Once';
  DateTime? _startDate;
  DateTime? _endDate;
  List<TimeOfDay> _reminderTimes = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    // Initialize the FlutterLocalNotificationsPlugin
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Make sure you have an app icon in your project

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

    List<TimeOfDay> _getDefaultTimesForDosage(String dosage) {
    switch (dosage) {
      case 'Once':
        return [TimeOfDay(hour: 9, minute: 0)];
      case 'Twice':
        return [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 17, minute: 0)];
      case 'Three times':
        return [
          TimeOfDay(hour: 9, minute: 0),
          TimeOfDay(hour: 13, minute: 0),
          TimeOfDay(hour: 19, minute: 0)
        ];
      default:
        return [];
    }
  }

  Future<void> _scheduleNotification(DateTime dateTime, String tabletName) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel', 
      'Reminders',
      importance: Importance.max, 
      priority: Priority.high,
      channelShowBadge: true,
      fullScreenIntent: true,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final scheduledDate = _tz.TZDateTime.from(dateTime, _tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      dateTime.millisecondsSinceEpoch ~/ 1000, // ID
      'Medicine Reminder',
      'Time to take your medicine: $tabletName',
      scheduledDate, // Schedule time
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (_tabletNameController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    for (final time in _reminderTimes) {
      final dt = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        time.hour,
        time.minute,
      );

      _scheduleNotification(dt, _tabletNameController.text);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reminder(s) set successfully")),
    );
  }
  Future<void> _onSelectNotification(String? payload) async {
    if (payload != null) {
      // Navigate to AlarmScreen
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AlarmScreen(),
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminder")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _tabletNameController,
              decoration: InputDecoration(labelText: "Tablet Name"),
            ),
            SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: InputDecoration(labelText: "Frequency"),
              items: ['Every day', 'Every X days', 'Every week', 'Every month']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (val) => setState(() => _frequency = val!),
            ),
            SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _dosage,
              decoration: InputDecoration(labelText: "Dosage"),
              items: ['Once', 'Twice', 'Three times', 'Custom']
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _dosage = val!;
                  _reminderTimes = _getDefaultTimesForDosage(_dosage);
                });
              },
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_reminderTimes.length, (index) {
                final time = _reminderTimes[index];
                return ListTile(
                  title: Text("Reminder ${index + 1}: ${time.format(context)}"),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: time,
                    );
                    if (picked != null) {
                      setState(() {
                        _reminderTimes[index] = picked;
                      });
                    }
                  },
                );
              }),
            ),

            SizedBox(height: 20),

            ListTile(
              title: Text("Start Date: ${_startDate != null ? DateFormat('yMMMd').format(_startDate!) : 'Not selected'}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDate(isStart: true),
            ),


            ListTile(
              title: Text("End Date: ${_endDate != null ? DateFormat('yMMMd').format(_endDate!) : 'Not selected'}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDate(isStart: false),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              child: Text("Set Reminder"),
            )
          ],
        ),
      ),
    );
  }
}