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
    subscriptionViewModel.loadUserSubscription();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subscriptions",
                  style: theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Section: Current Plan
                    const SizedBox(height: 12),
                    CustomText(
                      text: 'Your Current Subscription',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 10),
                    _buildCurrentPlanCard(),

                    const SizedBox(height: 24),

                    /// Section: Available Plans
                    CustomText(
                      text: 'Available Plans',
                      size: 18,
                      color: Colors.black,
                      weight: FontWeight.w700,
                      align: TextAlign.left,
                      screenHeight: screenHeight,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<SubscriptionModel>>(
                      future: subscriptionViewModel.subscriptionsStream.first,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No subscriptions found.'));
                        }

                        final subscriptions = snapshot.data!;
                        subscriptionViewModel.setSubscriptions(subscriptions);

                        return Consumer<SubscriptionViewModel>(
                          builder: (context, viewModel, child) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.subscriptionsdata.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final subscription = viewModel.subscriptionsdata[index];
                                return _buildSubscriptionCard(subscription);
                              },
                            );
                          },
                        );
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

  /// Current Plan UI Card
  Widget _buildCurrentPlanCard() {
    return Card(
      color: AppColors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelValueRow("Subscription Type", subscriptionViewModel.SubscriptionName),
            const SizedBox(height: 8),
            _labelValueRow("Monthly Plan", "₱ ${subscriptionViewModel.SubscriptionPrice}"),
            const SizedBox(height: 8),
            _labelValueRow("Expires At", subscriptionViewModel.SubscriptionDuration),
          ],
        ),
      ),
    );
  }

  /// Available Plans UI Card
  Widget _buildSubscriptionCard(SubscriptionModel subscription) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: const Icon(Icons.stars_rounded, color: AppColors.orange, size: 30),
        title: Text(
          subscription.subscriptionName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Duration: ${subscription.subscriptionDuration} days"),
              Text("Amount: ₱ ${subscription.subscriptionAmount}"),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Optional: handle plan tap
        },
      ),
    );
  }

  /// Label + Value Row helper
  Widget _labelValueRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
