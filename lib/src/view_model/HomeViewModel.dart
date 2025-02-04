import 'package:flutter/material.dart';

class HomeViewMode extends ChangeNotifier {

  void loadPost(){
    // Load post from the server
    notifyListeners();
  }


}