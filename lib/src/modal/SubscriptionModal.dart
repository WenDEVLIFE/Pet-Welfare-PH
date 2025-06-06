import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/SubcriptionViewModel.dart';
import 'package:provider/provider.dart';

import '../model/SubcriptionModel.dart';
import '../utils/AppColors.dart';
import '../widgets/CustomText.dart';

class SubscriptionModal extends StatefulWidget {
  const SubscriptionModal({Key? key}) : super(key: key);

  @override
  _SubscriptionModalState createState() => _SubscriptionModalState();
}

class _SubscriptionModalState extends State<SubscriptionModal> {
  late SubscriptionViewModel subscriptionViewModel;

  @override
  void initState() {
    super.initState();
    subscriptionViewModel = Provider.of<SubscriptionViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Subscription",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    CustomText(
                      text: 'Manage your subscriptions here',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    FutureBuilder<List<SubscriptionModel>>(
                      future: subscriptionViewModel.subscriptionsStream.first,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('No subscriptions found'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No subscriptions available'));
                        } else {
                          final subscriptions = snapshot.data!;
                          subscriptionViewModel.setSubscriptions(subscriptions);
                          return Consumer<SubscriptionViewModel>(
                            builder: (context, viewModel, child) {
                              return ListView.builder(
                                shrinkWrap: true, // Prevents unbounded height issues
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.subscriptionsdata.length,
                                itemBuilder: (context, index) {
                                  SubscriptionModel subscription = viewModel.subscriptionsdata[index];
                                  return Card(
                                    color: AppColors.orange,
                                    child: ListTile(
                                      title: Text(
                                        subscription.subscriptionName,
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
                                          Text(
                                            'Duration: ${subscription.subscriptionDuration} days',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'SmoochSans',
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Amount: ₱ ${subscription.subscriptionAmount}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'SmoochSans',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}