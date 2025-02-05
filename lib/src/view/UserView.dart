import 'package:flutter/cupertino.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text('User View'),
      ),
    );
  }
}