import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static bool _isInitialized = false; // Prevent multiple initializations

  /// **Initialize notifications (should be called once at app startup)**
  static Future<void> initNotifications() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Initialize timezone data for scheduling notifications
    tz.initializeTimeZones();

    // Android-specific initialization
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS-specific initialization
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    // Apply settings
    final InitializationSettings settings = const InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the notifications plugin
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔔 Notification Clicked: ${response.payload}");
      },
    );

    // Configure FCM
    _firebaseMessaging.requestPermission();

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(
        id: message.messageId.hashCode,
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
        payload: message.data['payload'],
      );
    });

    // Background and terminated state message handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.messageId}');
      // You can navigate to specific screens or handle actions here
    });

    // Handle notification when app is terminated or in the background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Background handler for when app is terminated or in the background
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // You can show a notification here too, or perform other actions
    showNotification(
      id: message.messageId.hashCode,
      title: message.notification?.title ?? 'Background Notification',
      body: message.notification?.body ?? 'No Body',
      payload: message.data['payload'],
    );
  }

  /// **Show an immediate notification**
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initNotifications();

    print('Showing notification: $title');  // Debug statement
    print('Notification ID: $id');  // Debug statement

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', // Channel ID
      'General Notifications', // Channel name
      channelDescription: 'Notifications for general updates',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  /// **Schedule a notification at a specific time**
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) await initNotifications();

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'Scheduled Notifications',
          channelDescription: 'Notifications scheduled for future events',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// **Cancel a specific notification by ID**
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// **Cancel all scheduled and active notifications**
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
