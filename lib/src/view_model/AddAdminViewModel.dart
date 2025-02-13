import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../respository/AddUserRespository.dart';
import '../utils/FirebaseIntialize.dart';

class AddAdminViewModel extends ChangeNotifier {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  final List<String> adminRole = ['Admin', 'Sub-Admin'];
  String? selectedRole = 'Admin';

  bool obscureText1 = true;
  bool obscureText2 = true;

  final AddUserRepository _repository = AddUserImpl();

  bool get isobscure1 => obscureText1;
  bool get isobscure2 => obscureText2;

  void togglePasswordVisibility1() {
    obscureText1 = !obscureText1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    obscureText2 = !obscureText2;
    notifyListeners();
  }

  void setSelectedRole(String? value) {
    selectedRole = value;
    print(selectedRole);
    notifyListeners();
  }

  Future<void> checkData(BuildContext context) async {

    FirebaseRestAPI.signInAnonymously();
    if (email.text.isEmpty || name.text.isEmpty || password.text.isEmpty || confirmpassword.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill all the fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
    } else {
      bool userExists = await _repository.checkIfUserExists(name.text, email.text);
      bool checkEmail = await _repository.checkValidateEmail(email.text);
      bool checkPassword = await _repository.checkPassword(password.text, confirmpassword.text);
      bool checkPasswordComplexity = await _repository.checkPasswordComplexity(password.text);
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
      }
      else {
        // Proceed with adding the user
        var userData = {
          'name': name.text,
          'email': email.text,
          'password': password.text,
          'role': selectedRole,
        };
        _repository.registerUser(userData, context, clearText);
      }
    }
  }

  void clearText() {
    email.clear();
    name.clear();
    password.clear();
    confirmpassword.clear();
    selectedRole = 'Admin';
    notifyListeners();
  }
}