import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';

import '../model/NotificationModel.dart';

class NotificationViewModel extends ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  final NotificationRepository notificationRepository = NotificationRepositoryImpl();

  List<NotificationModel> notifications = [];
  List <NotificationModel> filteredNotifications = [];

  Stream<List<NotificationModel>> get getNotification => notificationRepository.getnotificationData();

// Added search functions
  void setSearchQuery(String value) {
    filteredNotifications = notifications.where((element) => element.content.contains(value)).toList();
    notifyListeners();

  }

  void deleteNotifications(String id) async{
   try{
     await notificationRepository.deleteNotification(id);
   } catch(e){
     print(e);
   }

  }


}