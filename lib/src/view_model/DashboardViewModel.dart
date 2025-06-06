import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/respository/DashboardRepository.dart';

class DashboardViewModel extends ChangeNotifier {
   int totalUser = 0;
   int totalPost = 0;
   int totalBannedUser = 0;
   int totalPendingUser = 0;
   int totalApprovedUser = 0;

  final DashboardRepository dashboardRepository = DashboardRepositoryImpl();

  Future <void> initDashboard() async {

    totalUser = await dashboardRepository.getTotalUsers();
    totalPost = await dashboardRepository.getTotalPosts();
    totalBannedUser = await dashboardRepository.getBannedUsers();
    totalPendingUser = await dashboardRepository.getUnverifiedUsers();
    totalApprovedUser = await dashboardRepository.getVerifiedUsers();

  }
}