import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:pet_welfrare_ph/src/view_model/UploadIDViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../view_model/LoginViewModel.dart';


class Uploadidview extends StatefulWidget {
  const Uploadidview({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Uploadidview> {

  late UploadIDViewModel viewModel;

  var idType = ['Passport', 'Driver\'s License', 'SSS ID', 'UMID', 'Voter\'s ID', 'Postal ID', 'PRC ID',
    'OFW ID', 'Senior Citizen ID', 'PWD ID', 'Student ID', 'Company ID', 'Police Clearance', 'NBI Clearance',
    'Barangay Clearance', 'Health Card', 'PhilHealth ID', 'TIN ID', 'GSIS ID', 'Pag-IBIG ID', 'DFA ID'];

  var selectedIdType='Select ID Type';

  final ImagePicker imagePicker = ImagePicker();

  String ImagePath = '';


  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<UploadIDViewModel>(context, listen: false);
  }
  Future<void> _pickImage() async {
    // Open the image picker
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        ImagePath = pickedFile.path; // Update new image path to the selected file
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.orange,
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon/Logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Center(
                                child: Text('Upload ID',
                                    style: TextStyle(fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.black)),
                              ),
                              const SizedBox(height: 20),
                              const Text('Select ID Type',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 380,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.gray,
                                  border: Border.all(color: AppColors.gray, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.grey[800], // Set dropdown background color to black
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedIdType,
                                    items: idType.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'SmoochSans',
                                            fontWeight: FontWeight.w600,
                                          ), // Change text color here
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                       selectedIdType = newValue!;
                                      });
                                    },
                                    dropdownColor: AppColors.gray, // Set dropdown background color to black
                                    iconEnabledColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white), // Change text color here
                                    selectedItemBuilder: (BuildContext context) {
                                      return idType.map<Widget>((String item) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'SmoochSans',
                                              fontWeight: FontWeight.w600,
                                            ), // Change text color here
                                          ),
                                        );
                                      }).toList();
                                    },
                                    isExpanded: true, // Ensure the dropdown button is expanded
                                    alignment: Alignment.bottomLeft, // Align the text to the left
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('ID Front',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                ),
                              ),
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 95,
                                      backgroundImage: ImagePath.isNotEmpty
                                          ? FileImage(File(ImagePath)) // Use FileImage for local files
                                          : ImagePath.isNotEmpty
                                          ? CachedNetworkImageProvider(ImagePath)
                                          : const AssetImage('assets/fufu.png') as ImageProvider,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.photo_camera),
                                        onPressed: _pickImage,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text('ID Back',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black,
                                ),
                              ),
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 100,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 95,
                                      backgroundImage: ImagePath.isNotEmpty
                                          ? FileImage(File(ImagePath)) // Use FileImage for local files
                                          : ImagePath.isNotEmpty
                                          ? CachedNetworkImageProvider(ImagePath)
                                          : const AssetImage('assets/fufu.png') as ImageProvider,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.photo_camera),
                                        onPressed: _pickImage,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                      // call the controller
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text('Proceed',
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}