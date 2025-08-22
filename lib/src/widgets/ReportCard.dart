import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/ReportModel.dart';

class ReportCard extends StatelessWidget {

  final ReportModel model;

  const ReportCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report ID: ${model.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${model.description}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (model.filePath.isNotEmpty)
              Image.network(model.filePath, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

}