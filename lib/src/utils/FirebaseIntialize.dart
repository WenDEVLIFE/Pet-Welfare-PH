import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseRestAPI {
  static Future<void> run() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAmF4Kj89FwcdZEOXqJ3Y2A0Df9kUdzvb4',
        appId: '1:552598368291:android:0625d565323e92c2768196',
        messagingSenderId: '552598368291',
        projectId: 'pet-welfare-ph',
        storageBucket: 'pet-welfare-ph.firebasestorage.app',  // Add this line
      ),
    );

    if (Firebase.apps.isEmpty) {
      Fluttertoast.showToast(
        msg:  'App is not connected to Database',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:  Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Firebase is not initialized');
    } else {
      Fluttertoast.showToast(
        msg: 'App is connected to Database',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:  Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Firebase is initialized');
    }
  }

  static Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  static Future<void> initializeAppCheck() async {
    try {
      await FirebaseAppCheck.instance.activate(
        // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
        // argument for `webProvider`
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Safety Net provider
        // 3. Play Integrity provider
        androidProvider: AndroidProvider.debug,
        // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
        appleProvider: AppleProvider.appAttest,
      );
    } catch (e) {
      print('Error during App Check activation: $e');
      await Future.delayed(Duration(seconds: 5));  // retry with delay
      await FirebaseAppCheck.instance.activate(
        // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
        // argument for `webProvider`
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Safety Net provider
        // 3. Play Integrity provider
        androidProvider: AndroidProvider.debug,
        // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
        appleProvider: AppleProvider.appAttest,
      );
    }
  }
}