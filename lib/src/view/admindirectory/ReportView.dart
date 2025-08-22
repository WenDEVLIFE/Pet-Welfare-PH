import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/ReportViewModel.dart';
import '../../model/ReportModel.dart';
import '../../widgets/DrawerHeaderWidget.dart';
import '../../widgets/LogoutDialog.dart';
import '../../utils/Route.dart';
import '../../utils/SessionManager.dart';
import 'package:provider/provider.dart';
import '../../view_model/SubcriptionViewModel.dart';
import '../../widgets/ReportCard.dart';
import '../../widgets/SearchTextField.dart';

// This is where the ReportView is defined. It displays a list of reports and allows users to navigate through different sections of the app.
class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportView> {
  late ReportViewModel reportViewModel;

  @override
  void initState() {
    super.initState();
    reportViewModel = Provider.of<ReportViewModel>(context, listen: false);
    reportViewModel.loadReports();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: NavigationDrawer(
        children: [
          const DrawerHeaderWidget(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }),
          _buildDrawerItem(Icons.verified_user_rounded, 'Users', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.userView);
          }),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.homescreen);
          }),
          _buildDrawerItem(Icons.attach_money, 'Subscriptions', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.subscription);
          }),
          _buildDrawerItem(Icons.holiday_village_outlined, 'All Business', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.adminViewEstablishment);
          }),
          _buildDrawerItem(Icons.report_gmailerrorred_sharp, 'Reports', () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, AppRoutes.reportView);
          }),
          _buildDrawerItem(Icons.info, 'About us', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.about);
            // Navigate to Privacy Policy
          }),
          _buildDrawerItem(Icons.check, 'Terms and Condition', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.termsAndConditions);
          }),
          _buildDrawerItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
          }),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutDialog(
                  onLogout: () async {
                    await SessionManager().clearUserInfo();
                    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                    print('User logged out');
                  },
                );
              },
            );
          }),
        ],
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'List of Reports',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.005),
           CustomSearchTextField(
          controller: reportViewModel.searchController,
            screenHeight: screenHeight,
            hintText: 'Search a report....',
            fontSize: 16,
            keyboardType: TextInputType.text,
            onChanged: (searchText) {
             reportViewModel.filterReports(searchText);
            },
          ),
          SizedBox(height: screenHeight * 0.005),
          // In lib/src/view/admindirectory/ReportView.dart

          Expanded(
            child: Consumer<ReportViewModel>(
              builder: (context, viewModel, _) {
                final reports = viewModel.filteredReports.isNotEmpty || viewModel.searchController.text.isNotEmpty
                    ? viewModel.filteredReports
                    : viewModel.reports;
                if (reports.isEmpty) {
                  return const Center(child: Text('No reports found'));
                }
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    return ReportCard(
                      model: reports[index],
                      onDelete: () {
                        viewModel.deleteReport(reports[index].id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Report deleted successfully')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontFamily: 'SmoochSans',
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      onTap: onTap,
    );
  }
}