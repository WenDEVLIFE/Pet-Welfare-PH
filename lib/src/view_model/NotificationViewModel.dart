import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';

import '../model/NotificationModel.dart';

class NotificationViewModel extends ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  final NotificationRepository notificationRepository = NotificationRepositoryImpl();

  List<NotificationModel> notifications = [];
  List <NotificationModel> filteredNotifications = [];

  Stream<List<NotificationModel>> get getNotification => notificationRepository.getnotificationData();

// Added search functions
  void setSearchQuery(String value) {
    if (value.isEmpty) {
      filteredNotifications = notifications;
      ToastComponent().showMessage(Colors.red, '$value not found');
    } else {
      filteredNotifications = notifications.where((element) => element.content.toLowerCase().contains(value.toLowerCase())).toList();
    }
    notifyListeners();

  }

  // Delete notification from the database
  void deleteNotifications(String id) async{
   try{
     await notificationRepository.deleteNotification(id);
   } catch(e){
     print(e);
   }

  }


}