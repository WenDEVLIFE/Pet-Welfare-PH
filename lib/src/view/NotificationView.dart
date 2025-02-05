import 'package:flutter/cupertino.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState  extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text('Notification View'),
      ),
    );
  }
}