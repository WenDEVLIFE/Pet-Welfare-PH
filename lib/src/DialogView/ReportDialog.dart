import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:provider/provider.dart';

import '../view_model/ReportViewModel.dart';

class ReportDialog extends StatelessWidget {
  final String postId;

  ReportDialog(this.postId);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(builder: (context, reportViewModel, child) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text(
          'Report Post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please state your reason and provide optional evidence for reporting this post.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reportViewModel.reasonController,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Enter reason here...',
                  labelText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  reportViewModel.picImagePicker();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: reportViewModel.filePath.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.photo_on_rectangle,
                                  color: Colors.grey.shade500,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to upload evidence',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            File(reportViewModel.filePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              reportViewModel.submitReport(postId, context);
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      );
    });
  }
}