import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'NotificationUtils.dart';

class FirebaseRestAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> run() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAmF4Kj89FwcdZEOXqJ3Y2A0Df9kUdzvb4',
        appId: '1:552598368291:android:0625d565323e92c2768196',
        messagingSenderId: '552598368291',
        projectId: 'pet-welfare-ph',
        storageBucket: 'pet-welfare-ph.firebasestorage.app',
      ),
    );

    if (Firebase.apps.isEmpty) {
      print('Firebase is not initialized');
    } else {
      print('Firebase is initialized');
    }
  }

  static Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> initNotificationPermission() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('payload: ${message.data}');
  NotificationUtils.showNotification(
    id: message.messageId.hashCode,
    title: message.notification?.title ?? 'No Title',
    body: message.notification?.body ?? 'No Body',
    payload: message.data['payload'],
  );
}