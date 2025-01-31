import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/view_model/RegisterViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/AppColors.dart';
import '../view_model/LoginViewModel.dart';


class PetrShelterRegisterview extends StatefulWidget {
  const PetrShelterRegisterview({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<PetrShelterRegisterview> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  var role = ['Pet Shelter', 'Pet Rescuer'];
  var selectedRole = 'Pet Shelter';

  late RegisterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<RegisterViewModel>(context, listen: false);
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
                                child: Text('SIGN UP FOR PET SHELTER & RESCUE',
                                    style: TextStyle(fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'SmoochSans',
                                        color: Colors.black)),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your name',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SmoochSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('EMAIL', style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SmoochSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('SELECT YOUR USER CLASSIFICATION',
                                  style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black)),
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
                                    value: selectedRole,
                                    items: role.map<DropdownMenuItem<String>>((String value) {
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
                                        selectedRole = newValue!;
                                      });
                                    },
                                    dropdownColor: AppColors.gray, // Set dropdown background color to black
                                    iconEnabledColor: Colors.grey,
                                    style: const TextStyle(color: Colors.white), // Change text color here
                                    selectedItemBuilder: (BuildContext context) {
                                      return role.map<Widget>((String item) {
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
                              const Text('ADDRESS', style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your address',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SmoochSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SmoochSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('PASSWORD', style:
                              TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black
                              )),
                              const SizedBox(height: 10),
                              // Consumer widget
                              Consumer<RegisterViewModel>(
                                builder: (context, viewmodel, child) {
                                  return TextField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.gray,
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          viewmodel.obscureText1 ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          viewmodel.togglePasswordVisibility1();
                                        },
                                      ),
                                      hintText: 'Enter your password',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SmoochSans',
                                      ),
                                    ),
                                    obscureText: viewmodel.obscureText1,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text('CONFIRM PASSWORD', style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SmoochSans',
                                  color: Colors.black)),
                              const SizedBox(height: 10),
                              // Consumer widget
                              Consumer<RegisterViewModel>(
                                builder: (context, viewmodel, child) {
                                  return TextField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.gray,
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          viewmodel.obscureText2 ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          viewmodel.togglePasswordVisibility2();
                                        },
                                      ),
                                      hintText: 'Enter confirm password',
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SmoochSans',
                                      ),
                                    ),
                                    obscureText: viewmodel.obscureText2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SmoochSans',
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              Consumer<RegisterViewModel>(
                                builder: (context, viewmodel, child) {
                                  return CheckboxListTile(
                                    title: const Text(
                                      'I agree to the terms and conditions',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SmoochSans',
                                      ),
                                    ),
                                    value: viewmodel.isChecked,
                                    onChanged: (bool? value) {
                                      viewmodel.setChecked(value!);
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                    activeColor: Colors.black,
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
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
                                      Provider.of<RegisterViewModel>(context, listen: false).proceedUploadID(context);
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
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: const Alignment(0.0, 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<RegisterViewModel>(context, listen: false).proceedLogin(context);
                                    },
                                    child: const Text(
                                      'Already have an account?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SmoochSans',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: const Alignment(0.0, 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<RegisterViewModel>(context, listen: false).proceedLogin(context);
                                    },
                                    child: const Text(
                                      'Sign in',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
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