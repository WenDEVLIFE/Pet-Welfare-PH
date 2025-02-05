import 'package:flutter/cupertino.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  MenuViewState createState() => MenuViewState();
}

class MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: Text('Menu View'),
      ),
    );
  }
}