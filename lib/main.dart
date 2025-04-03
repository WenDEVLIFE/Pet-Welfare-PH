import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';
import 'package:pet_welfrare_ph/src/utils/FirebaseIntialize.dart';
import 'package:pet_welfrare_ph/src/utils/NotificationUtils.dart';
import 'package:pet_welfrare_ph/src/utils/Route.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:pet_welfrare_ph/src/view_model/ApplyAdoptionViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/CreatePostViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/DonateViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/DrawerHeadViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/AddAdminViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/ChangePasswordViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MapViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MenuViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/MessageViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/NotificationViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/OTPViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/PostViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/LoginViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SelectViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/EstablishmentViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/LoadingViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/SubcriptionViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UploadIDViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UserDataViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UserViewModel.dart';
import 'package:provider/provider.dart';
import 'package:pet_welfrare_ph/src/widgets/NotificationListener.dart' as custom;
import 'package:workmanager/workmanager.dart'; // Import the workmanager package
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseRestAPI.run();
  await NotificationUtils.initNotifications();
  await FirebaseRestAPI().initNotificationPermission();
  await FirebaseRestAPI().initFirebaseMessage();

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Register background task
  await Workmanager().registerOneOffTask(
    "fetchNotificationsTask",
    "simpleOneTimeTask",
    initialDelay: Duration(minutes: 1),
  );

  // Handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationUtils.showNotification(
      id: message.messageId.hashCode,
      title: message.notification?.title ?? "New Notification",
      body: message.notification?.body ?? "You have a new message",
    );
  });

  // Initialize background service
  initializeService();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseRestAPI.run();
  NotificationUtils.showNotification(
    id: message.messageId.hashCode,
    title: message.notification?.title ?? "New Notification",
    body: message.notification?.body ?? "You have a new message",
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await FirebaseRestAPI.run();
    final notificationRepository = NotificationRepositoryImpl();
    final notifications = await notificationRepository.getNotificationsStream().first;

    for (DocumentSnapshot doc in notifications) {
      print('Showing notification for doc: ${doc['notificationID']}');  // Debug statement
      NotificationUtils.showNotification(
        id: doc.id.hashCode,
        title: 'New Notification: ${doc['category']}',
        body: doc['content'],
      );

      // Mark notifications as read
      await doc.reference.update({'isRead': true});
    }

    // Re-register task for every 1 minute
    Workmanager().registerOneOffTask(
      "fetchNotificationsTask",
      "simpleOneTimeTask",
      initialDelay: const Duration(minutes: 1),
    );

    return Future.value(true);
  });
}

void initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
}

// 🔹 Background Service Task (Runs Every 1 Minute)
void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(minutes: 1), (timer) async {
    print('Background service is running...');
    await FirebaseRestAPI.run();
    final notificationRepository = NotificationRepositoryImpl();
    final notifications = await notificationRepository.getNotificationsStream().first;

    for (DocumentSnapshot doc in notifications) {
      print('Showing notification for doc in service: ${doc['notificationID']}');  // Debug statement
      NotificationUtils.showNotification(
        id: doc.id.hashCode,
        title: 'New Notification: ${doc['category']}',
        body: doc['content'],
      );

      print('Notification shown for doc: ${doc['notificationID']}');  // Additional debug statement

      await doc.reference.update({'isRead': true});
      print('Notification marked as read for doc: ${doc['notificationID']}');  // Additional debug statement
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel2()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SelectViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => UploadIDViewModel()),
        ChangeNotifierProvider(create: (_) => OTPViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => AddAdminViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
        ChangeNotifierProvider(create: (_) => DrawerHeadViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
        ChangeNotifierProvider(create: (_) => UserDataViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => EstablishmentViewModel()),
        ChangeNotifierProvider(create: (_) => ApplyAdoptionViewModel()),
        ChangeNotifierProvider(create: (_) => DonateViewModel()),
        ChangeNotifierProvider(create: (_) => MessageViewModel()),
        ChangeNotifierProvider(create: (_) => CreatePostViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel())
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            MaterialApp(
              key: GlobalKey(),
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.loadingScreen,
              routes: AppRoutes.routes,
            ),
            custom.NotificationListener1(),
          ],
        ),
      ),
    );
  }
}