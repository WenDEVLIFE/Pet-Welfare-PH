import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../view_model/DrawerHeadViewModel.dart';

class DrawerHeaderWidget extends StatefulWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  _DrawerHeaderWidgetState createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget> {
  @override
  void initState() {
    super.initState();
    // Load profile data when the widget is initialized

    Provider.of<DrawerHeadViewModel>(context, listen: false).loadData();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerHeadViewModel>(
      builder: (context, viewModel, child) {
        return DrawerHeader(
          decoration: const BoxDecoration(color: AppColors.orange),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(viewModel.profileImage),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        viewModel.name,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontFamily: 'SmoochSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified_user_rounded, color: Colors.green),
                    ],
                  ),
                  Text(
                    viewModel.role,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}