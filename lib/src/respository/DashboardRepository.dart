abstract class DashboardRepository {

  Future <int> getTotalUsers();

  Future <int> getTotalPosts();

  Future <int> getVerifiedUsers();

  Future <int> getUnverifiedUsers();

  Future <int> getBannedUsers();
}

class DashboardRepositoryImpl implements DashboardRepository {

  Future <int> getTotalUsers() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return 100; // Example total users count
  }

  Future <int> getTotalPosts() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return 50; // Example total posts count
  }

  Future<int> getVerifiedUsers() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return 30; // Example total verified users count
  }

  Future <int> getUnverifiedUsers() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return 200; // Example total pets count
  }

  Future <int> getBannedUsers() async {
    // Simulate a network call or database query
    await Future.delayed(Duration(seconds: 1));
    return 10; // Example total banned users count
  }

}