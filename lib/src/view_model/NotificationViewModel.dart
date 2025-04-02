import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/respository/NotificationRepository.dart';

class NotificationViewModel extends ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  final NotificationRepository _notificationRepository = NotificationRepositoryImpl();


}