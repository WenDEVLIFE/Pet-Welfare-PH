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
  SubscriptionModel? _selectedSubscription;

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
                    /// Current Subscription
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

                    /// Available Subscriptions
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

                    /// Subscribe Button
                    if (_selectedSubscription != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Handle subscription logic
                            print("User selected plan: ${_selectedSubscription!.subscriptionName}");
                          },
                          icon: const Icon(Icons.check_circle),
                          label: const Text("Subscribe to this Plan"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
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

  /// Current Subscription Card
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

  /// Subscription Plan Card with selection logic
  Widget _buildSubscriptionCard(SubscriptionModel subscription) {
    final isSelected = _selectedSubscription?.subscriptionName == subscription.subscriptionName;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.orange.withOpacity(0.1) : Colors.white,
        border: Border.all(
          color: isSelected ? AppColors.orange : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected
            ? [BoxShadow(color: AppColors.orange.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 4))]
            : [],
      ),
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
        trailing: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: isSelected
              ? const Icon(Icons.check_circle_rounded, color: AppColors.orange, size: 28, key: ValueKey(true))
              : const SizedBox(width: 28, key: ValueKey(false)),
        ),
        onTap: () {
          setState(() {
            _selectedSubscription = subscription;
          });
        },
      ),
    );
  }

  /// Label & Value Row
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
