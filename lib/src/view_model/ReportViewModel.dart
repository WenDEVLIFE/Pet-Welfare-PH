import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_welfrare_ph/src/model/ReportModel.dart';
import 'package:pet_welfrare_ph/src/respository/ReportRepository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ReportViewModel extends ChangeNotifier {
  final TextEditingController reasonController = TextEditingController();
  final ReportRepository reportRepository = ReportRepositoryImpl();
  final ReportRepositoryImpl reportRepositoryImpl = ReportRepositoryImpl();
  final TextEditingController searchController = TextEditingController();

  String filePath = '';
  final ImagePicker imagePicker = ImagePicker();

  List<ReportModel> reports = [];
  List<ReportModel> filteredReports = [];

  Stream <List<ReportModel>> get reportStream => reportRepositoryImpl.loadReports();

  void submitReport(String postId, BuildContext context) async{

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Submitting report...');
    progressDialog.update(value: 50, msg: 'Processing...');
    await Future.delayed(const Duration(seconds: 1));
    String reason = reasonController.text;

    if (reason.isNotEmpty) {
      // Handle the report submission logic here
      var reportData = {
        'PostID': postId,
        'Reason': reason,
        'FilePath': filePath,
      };
      print('Report submitted with reason: $reason');
      await reportRepository.submitReport(reportData, clear);
    } else {
      ToastComponent().showMessage(Colors.red, 'Please provide a reason for reporting this post.');
    }
  }

  void clear() {
    reasonController.clear();
  }

  void picImagePicker(){
    imagePicker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        filePath = pickedFile.path;
        notifyListeners();
      }
    });

  }

  Future <void> loadReports() async {
    try {
      reportRepositoryImpl.loadReports().listen((reportList) {
        reports = reportList;
        notifyListeners();
      });
      print('Reports loaded successfully.');
    } catch (e) {
      print('Error loading reports: $e');
      ToastComponent().showMessage(Colors.red, 'Failed to load reports.');
    }
  }

  Future<void> filterReports(String query) async {
    try {
      if (query.isEmpty) {
        filteredReports = reports;
      } else {
        filteredReports = reports.where((report) {
          return report.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Error filtering reports: $e');
      ToastComponent().showMessage(Colors.red, 'Failed to filter reports.');
    }
  }

}