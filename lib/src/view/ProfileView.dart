import 'package:flutter/cupertino.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();

}

class ProfileViewState  extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text('Profile View'),
      ),
    );
  }
}
