import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/widgets/AlertMenuDialog.dart';
import 'package:pet_welfrare_ph/src/view_model/UserViewModel.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';
import '../DialogView/BanDialogForm.dart';

class ViewUserDataPage extends StatefulWidget {
  const ViewUserDataPage({Key? key}) : super(key: key);

  @override
  _ViewUserDataPageState createState() => _ViewUserDataPageState();
}

class _ViewUserDataPageState extends State<ViewUserDataPage> {

  late UserViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final Map<String, dynamic>? userData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    print(userData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View User Information',
          style: TextStyle(
            color: AppColors.white,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${userData?['name'] ?? ''}',
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'Email: ${userData?['email'] ?? ''}',
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'Role: ${userData?['role'] ?? ''}',
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            if (userData?['role'].toLowerCase() != 'admin') ...[
              const Text(
                'ID Front:',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Padding(padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      userData?['idfronturl'] ?? '',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              const Text(
                'ID Back:',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Padding(padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      userData?['idbackurl'] ?? '',
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: screenHeight * 0.005),
            if (userData?['role'].toLowerCase() == 'pet rescuer' || userData?['role'].toLowerCase() == 'pet shelter') ...[
              Text(
                'Address: ${userData?['address'] ?? ''}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
            Center(
              child: Container(
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.transparent),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Alertmenudialog(
                          title: 'Approve User',
                          content: 'Are you sure you want to approve this user?',
                          onAction: () async {
                            Provider.of<UserViewModel>(context, listen: false).updateStatus(userData?['id']);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Approved',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SmoochSans',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Center(
              child: Container(
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.transparent),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Alertmenudialog(
                          title: 'Deny User',
                          content: 'Are you sure you want to deny this user?',
                          onAction: () async {
                            Provider.of<UserViewModel>(context, listen: false).deniedUser(userData?['id']);
                          },
                        );
                      },
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Denied',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SmoochSans',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Center(
              child: Container(
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.transparent),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showBanDialog (
                        context, userData
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Ban User',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SmoochSans',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBanDialog(BuildContext context , Map<String, dynamic>? userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BanDialog(userData: {
          'name': userData?['name'],
          'email': userData?['email'],
          'id': userData?['id'],
        });
      },
    );
  }
}