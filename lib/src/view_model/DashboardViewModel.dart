import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/respository/DashboardRepository.dart';

class DashboardViewModel extends ChangeNotifier {
  int? totalUser;
  int? totalPost;
  int? totalBannedUser;
  int? totalPendingUser;
  int? totalApprovedUser;

  final DashboardRepository dashboardRepository = DashboardRepositoryImpl();

  Future<void> initDashboard() async {
    _setLoadingState();
    final results = await Future.wait([
      dashboardRepository.getTotalUsers(),
      dashboardRepository.getTotalPosts(),
      dashboardRepository.getBannedUsers(),
      dashboardRepository.getUnverifiedUsers(),
      dashboardRepository.getVerifiedUsers(),
    ]);

    totalUser = results[0];
    totalPost = results[1];
    totalBannedUser = results[2];
    totalPendingUser = results[3];
    totalApprovedUser = results[4];
    notifyListeners();
  }

  void _setLoadingState() {
    totalUser = null;
    totalPost = null;
    totalBannedUser = null;
    totalPendingUser = null;
    totalApprovedUser = null;
    notifyListeners();
  }
}