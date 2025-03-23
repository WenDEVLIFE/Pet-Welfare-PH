import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../respository/UserRepository.dart';
import '../utils/Route.dart';

class RegisterViewModel extends ChangeNotifier {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  var role = ['Pet Shelter', 'Pet Rescuer'];
  var establismentrole =['Vet Clinic personnel', 'Pet Grooming Services personnel', 'Pet Sitting & Dog Walking personnel',
  'Pet Training personnel', 'Pet Boarding & Daycare personnel','Pet Bakery personnel', 'Pet Adoption Agency personnel',
  'Pet Transportation personnel', 'Mobile Pet Grooming', 'Pet Spa personnel', 'Pet Insurance Agency personnel', 'Pet Waste Removal Service personnel',
  'Pet Clothing & Apparel personnel', 'Pet Training Supplies Store personnel', 'Pet Food & Treats Store personnel', 'Pet Accessories Store personnel',];
  var selectedEstablishmentRole ='Vet Clinic personnel';
  var selectedRole = 'Pet Shelter';

  final UserRepository _repository = UserRepositoryImpl();

  // Password Visibility
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isChecked = false;

  // Getter
  bool get obscureText1 => _obscureText1;
  bool get obscureText2 => _obscureText2;
  bool get isChecked => _isChecked;

  // Setter
  void togglePasswordVisibility1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _obscureText2 = !_obscureText2;
    notifyListeners();
  }

  void proceedLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  Future<void> checkData(BuildContext context, String role) async {
    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill all the fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return; // Stop further execution
    }


    bool userExists = await _repository.checkIfUserExists(nameController.text, emailController.text);
    bool checkEmail = await _repository.checkValidateEmail(emailController.text);
    bool checkPassword = await _repository.checkPassword(passwordController.text, confirmPasswordController.text);
    bool checkPasswordComplexity = await _repository.checkPasswordComplexity(passwordController.text);

    if (userExists) {
      Fluttertoast.showToast(
        msg: 'User with this name or email already exists',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return; // Stop further execution
    }

    if (!checkEmail) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return; // Stop further execution
    }

    if (!checkPassword) {
      Fluttertoast.showToast(
        msg: 'Password does not match',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return; // Stop further execution
    }

    if (!checkPasswordComplexity) {
      Fluttertoast.showToast(
        msg: 'Password must contain at least 1 uppercase, 1 lowercase, 1 number, 1 special character and must be 8 characters long',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return; // Stop further execution
    }

    // Proceed with adding the user
    Navigator.pushNamed(context, AppRoutes.uploadIDScreen, arguments: {
      'email': emailController.text,
      'name': nameController.text,
      'clearData': clearData,
      'password': passwordController.text,
      'role': role == 'FurUser' ? 'Fur User' :
      role == 'Pet Shelter' ? 'Pet Shelter' :
      role == 'Pet Rescuer' ? 'Pet Rescuer' :
      role == 'Animal Welfare Advocate' ? 'Animal Welfare Advocate' : '',
      if (role == "Pet Rescuer" || role == "Pet Shelter") "address": addressController.text,
    });
  }


  void showTermsAndConditionDialog(BuildContext context) async {
    String termsText = await loadTermsAndConditions();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Terms and Conditions"),
          content: SingleChildScrollView(
            child: Text(termsText, textAlign: TextAlign.justify),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<String> loadTermsAndConditions() async {
    // Load text from the text file
    String text = await rootBundle.loadString("assets/word/terms.txt");
    return text;
  }

  void clearData() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    addressController.clear();
    selectedRole = 'Pet Shelter';
    notifyListeners();
  }
}