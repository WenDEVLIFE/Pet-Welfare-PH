import 'package:flutter/cupertino.dart';
import 'package:pet_welfrare_ph/src/respository/LoadProfileRespository.dart';
import '../utils/SessionManager.dart';

class UserDataViewModel extends ChangeNotifier {
  String name = '';
  String email = '';
  String idType = '';
  String profilepath = '';
  String idfrontpath = '';
  String idbackpath = '';
  String role = '';
  String address = '';
  String id = '';
  String status = '';

  final Loadprofilerespository _loadprofilerespository = LoadProfileImpl();
  final sessionManager = SessionManager();

  Future<void> loadInformation() async {
    final Map<String, dynamic>? userData = await _loadprofilerespository.loadProfile1();
    name = userData?['name']?? '';
    email = userData?['email']?? '';
    idType = userData?['idType']?? '';
    profilepath = userData?['profilepath']?? '';
    idfrontpath = userData?['idfrontpath']?? '';
    idbackpath = userData?['idbackpath']?? '';
    role = userData?['role']?? '';
    address = userData?['address'] ?? '';
    status = userData?['status'] ?? '';
    notifyListeners();
  }
}