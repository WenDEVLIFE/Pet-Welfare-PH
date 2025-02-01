import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_welfrare_ph/src/utils/YahooCredentials.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class YahooMail {

  // Get the API key from EmailKey.dart
  String username = YahooCredentials().email;
  String password = YahooCredentials().password;

  void sendEmail(int otp, String recipient, Function(bool) setLoading, BuildContext context) async {
    setLoading(true); // Start loading

    final smtpServer = SmtpServer('smtp.mail.yahoo.com',
        port: 587,
        username: username,
        password: password,
        ignoreBadCertificate: true);

    final message = Message()
      ..from = Address(username, 'Aid Anchor')
      ..recipients.add(recipient)
      ..subject = 'Aid Anchor Verification code'
      ..text = 'Your OTP is $otp. Please enter this OTP to proceed.';

    try {
      final sendReport = await send(message, smtpServer);
      Fluttertoast.showToast(
          msg: 'OTP sent to your email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    } finally {
      setLoading(false); // Stop loading
    }
  }

  void SendEmailQR(String email, void Function(bool isLoading) setLoading, BuildContext context, String fullname, String data) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Sending it to $email...',
      backgroundColor: const Color(0xFF6E738E),
      progressBgColor: Colors.transparent,
      progressValueColor: Colors.blue,
      msgColor: Colors.white,
      valueColor: Colors.white,
    );
    setLoading(true); // Start loading

    final smtpServer = SmtpServer('smtp.mail.yahoo.com',
        port: 587,
        username: username,
        password: password,
        ignoreBadCertificate: true);

    final message = Message()
      ..from = Address(username, 'Aid Anchor')
      ..recipients.add(email)
      ..subject = 'Aid Anchor Verification code'
      ..text = 'Hello $fullname, \n\nPlease find the attached QR code for your attendance. \n\nThank you.';

    try {
      final sendReport = await send(message, smtpServer);
      Fluttertoast.showToast(
          msg: 'email sent to the user\'s email',  // Updated message
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        pd.close();
      });
      setLoading(false); // Stop loading
    }
  }
}