
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view_model/ReportViewModel.dart';
import 'package:provider/provider.dart';

class ReportDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Consumer<ReportViewModel>(builder: (context, reportViewModel, child) {
        return AlertDialog(
          title: Text('Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide a reason for reporting this post.'),
              SizedBox(height: 20),
              TextField(
                controller: reportViewModel.reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter reason',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                reportViewModel.submitReport();
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

  }

}