import 'package:flutter/cupertino.dart';

class DashboardViewModel extends ChangeNotifier {
  final int totalUser = 0;
  final int totalPost = 0;
  final int totalBannedUser = 0;
  final int totalPendingUser = 0;
  final int totalApprovedUser = 0;

  void initDashboard() {
    // Fetch data from database
  }
}