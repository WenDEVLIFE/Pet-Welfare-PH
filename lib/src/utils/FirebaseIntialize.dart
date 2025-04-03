import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'NotificationUtils.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis_auth/auth.dart' as auth;
class FirebaseRestAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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


  // This method will retrieve the FCM token and store it in Firestore
  Future<void> retrieveAndStoreFCMToken() async {
    User ? user = _auth.currentUser;
    try {
      // Get the current token
      String? fcmToken = await _firebaseMessaging.getToken();

      if (user != null && fcmToken != null) {
        // Store the token in Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'fcmToken': fcmToken,
        }, SetOptions(merge: true));
        print("FCM Token stored successfully");
        sendFCMNotification(fcmToken, "Test Notification", "This is a test notification");
      } else {
        print("User is not logged in or FCM token is null");
      }
    } catch (e) {
      print("Error retrieving or storing FCM token: $e");
    }
  }

  Future<void> initFirebaseMessage() async {
    // Request notification permissions for iOS & Android
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationUtils.showNotification(
        id: message.messageId.hashCode,
        title: message.notification?.title ?? "New Notification",
        body: message.notification?.body ?? "You have a new message",
      );
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission!");
    } else {
      print("User declined or has not accepted permission.");
    }
  }

  // Send FCM notification using the token
  Future<void> sendFCMNotification(String fcmToken, String title, String body) async {
    String accessToken = await getAccessToken();

    var uri = Uri.parse('https://fcm.googleapis.com/v1/projects/pet-welfare-ph/messages:send');

    var notificationData = {
      "message": {
        "token": fcmToken, // The recipient's FCM token
        "notification": {
          "title": title,
          "body": body
        },
      }
    };

    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(notificationData),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  Future<String> getAccessToken() async {
    // Path to the service account JSON file you downloaded
    String serviceAccountJsonPath = 'assets/key/serviceaccount.json'; // Correct the path here

    // Load the service account JSON file from assets
    try {
      String jsonString = await rootBundle.loadString(serviceAccountJsonPath);
      var credentials = json.decode(jsonString);

      var accountCredentials = auth.ServiceAccountCredentials.fromJson(jsonString);
      var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      var client = http.Client();
      var accessCredentials = await auth.obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        scopes,
        client,
      );

      return accessCredentials.accessToken.data;
    } catch (e) {
      throw Exception('Error loading service account JSON file: $e');
    }
  }

}


