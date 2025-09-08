import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create a high priority notification channel
    const AndroidNotificationChannel androidChannel =
        AndroidNotificationChannel(
          'task_channel',
          'Task Notifications',
          description: 'Reminder notifications for your tasks',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(androidChannel);
    }
  }

  // Generate a safe 32-bit int ID from todo ID string
  int idForTodo(String todoId) => todoId.hashCode & 0x7FFFFFFF;

  Future<void> scheduleDeadline({
    required String todoId,
    required String title,
    required DateTime deadlineUtc,
  }) async {
    final scheduled = tz.TZDateTime.from(deadlineUtc, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    if (scheduled.isBefore(now)) {
      return; // don’t schedule past notifications
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      idForTodo(todoId),
      'Task Reminder',
      'Your task "$title" is due now!',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'Reminder notifications for your tasks',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelForTodo(String todoId) async {
    await _flutterLocalNotificationsPlugin.cancel(idForTodo(todoId));
  }
}
