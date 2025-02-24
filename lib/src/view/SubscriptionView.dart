import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import '../components/DrawerHeaderWidget.dart';
import '../components/LogoutDialog.dart';
import '../model/SubcriptionModel.dart';
import '../utils/Route.dart';
import '../utils/SessionManager.dart';
import 'package:provider/provider.dart';
import '../view_model/SubcriptionViewModel.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  SubscriptionState createState() => SubscriptionState();
}

class SubscriptionState extends State<SubscriptionView> {
  late SubscriptionViewModel _subscriptionViewModel;

  @override
  void initState() {
    super.initState();
    _subscriptionViewModel = Provider.of<SubscriptionViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            Navigator.pushNamed(context, AppRoutes.homescreen);
          }),
          _buildDrawerItem(Icons.attach_money, 'Subscriptions', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.subscription);
          }),
          _buildDrawerItem(Icons.report_gmailerrorred_sharp, 'Reports', () {
            Navigator.pop(context);
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
          'List of Subscriptions',
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
          Container(
            width: screenWidth * 0.99,
            height: screenHeight * 0.08,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent, width: 7),
            ),
            child: TextField(
              controller: _subscriptionViewModel.searchController,
              onChanged: (query) {
                _subscriptionViewModel.filterSubscriptions(query);
              },
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent, width: 2),
                ),
                hintText: 'Search a subscription....',
                hintStyle: const TextStyle(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              ),
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Expanded(
            child: FutureBuilder<List<SubscriptionModel>>(
              future: _subscriptionViewModel.subscriptionsStream.first,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('No subscriptions found'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No subscriptions available'));
                } else {
                  final subscriptions = snapshot.data!;
                  _subscriptionViewModel.setSubscriptions(subscriptions);
                  return Consumer<SubscriptionViewModel>(
                    builder: (context, viewModel, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.builder(
                          itemCount: viewModel.subscriptionsdata.length,
                          itemBuilder: (context, index) {
                            SubscriptionModel subscription = viewModel.subscriptionsdata[index];
                            return Card(
                              color: AppColors.orange,
                              child: ListTile(
                                title: Text(subscription.subscriptionName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'SmoochSans',
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Duration: ${subscription.subscriptionDuration} days',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text('Amount: ₱ ${subscription.subscriptionAmount}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white),
                                      onPressed: () => _editSubscription(context, subscription, subscription.uid),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      onPressed: () {
                                        viewModel.deleteSubscription(context, subscription.uid);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Provider.of<SubscriptionViewModel>(context, listen: false).addSubscriptionRoute(context);
                },
                backgroundColor: AppColors.orange,
                child: const Icon(Icons.add, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editSubscription(BuildContext context, SubscriptionModel subscription, String uid) {
    TextEditingController nameController = TextEditingController(text: subscription.subscriptionName);
    TextEditingController durationController = TextEditingController(text: subscription.subscriptionDuration.toString());
    TextEditingController amountController = TextEditingController(text: subscription.subscriptionAmount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.orange,
          title: const Text('Edit Subscription',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: 'SmoochSans',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Subscription Name',
                    labelStyle: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days)',
                    labelStyle: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Update the subscription details
                subscription.subscriptionName = nameController.text;
                subscription.subscriptionDuration = durationController.text;
                subscription.subscriptionAmount = amountController.text;

                // Call the update method in the ViewModel
                var subscriptionData = {
                  'SubscriptionName': nameController.text,
                  'SubscriptionDuration': durationController.text,
                  'SubscriptionPrice': amountController.text,
                };

                // pass the subscription data to the updateSubscription method
                Provider.of<SubscriptionViewModel>(context, listen: false).updateSubscription(subscriptionData, context, uid);
              },
              child: const Text('Save',
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
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