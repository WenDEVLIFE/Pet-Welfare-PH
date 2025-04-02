import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';

import '../model/NotificationModel.dart';

class NotificationViewModel extends ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  final NotificationRepository notificationRepository = NotificationRepositoryImpl();

  List<NotificationModel> notifications = [];

  Stream<List<NotificationModel>> get getNotification => notificationRepository.getnotificationData();


  void setSearchQuery(String value) {

  }


}