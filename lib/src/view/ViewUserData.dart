import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class ViewUserData extends StatefulWidget {
  const ViewUserData({Key? key}) : super(key: key);

  @override
  _ViewUserDataState createState() => _ViewUserDataState();
}

// TODO : Implement the state of the ViewUserData and the UI of the ViewUserData
class _ViewUserDataState extends State<ViewUserData>{
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final Map<String, dynamic>? userData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    print(userData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information',
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
              'Name:',
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'Email:',
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              'Role:',
              style: const TextStyle(
                color: AppColors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            if (userData?['role'].toLowerCase() != 'admin') ...[

              Text(
                'IDType: ${userData?['idtype'] ?? ''}',
                style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'SmoochSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}