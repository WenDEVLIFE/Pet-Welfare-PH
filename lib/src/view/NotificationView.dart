import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/NotificationViewModel.dart';
import 'package:pet_welfrare_ph/src/widgets/SearchTextField.dart';
import 'package:provider/provider.dart';

import '../model/NotificationModel.dart';
import '../utils/AppColors.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    final NotificationViewModel viewModel = Provider.of<NotificationViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'SmoochSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchTextField(
              controller: viewModel.searchController,
              screenHeight: screenHeight,
              hintText: 'Search Notifications',
              fontSize: 16,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                // Perform search operation
                viewModel.setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<NotificationModel>>(
              stream: viewModel.getNotification,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notifications found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].content),
                        subtitle: Text(snapshot.data![index].timestamp.toString()),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}