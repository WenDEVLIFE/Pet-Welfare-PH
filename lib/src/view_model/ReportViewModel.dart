import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/respository/ReportRepository.dart';
import 'package:pet_welfrare_ph/src/utils/ToastComponent.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ReportViewModel extends ChangeNotifier {
  final TextEditingController reasonController = TextEditingController();
  final ReportRepository reportRepository = ReportRepositoryImpl();

  void submitReport(String postId, BuildContext context) async{

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Submitting report...');
    progressDialog.update(value: 50, msg: 'Processing...');
    await Future.delayed(const Duration(seconds: 1));
    String reason = reasonController.text;

    if (reason.isNotEmpty) {
      // Handle the report submission logic here
      print('Report submitted with reason: $reason');
      await reportRepository.submitReport(reason, postId, clear);
    } else {
      ToastComponent().showMessage(Colors.red, 'Please provide a reason for reporting this post.');
    }
  }

  void clear() {
    reasonController.clear();
  }

}