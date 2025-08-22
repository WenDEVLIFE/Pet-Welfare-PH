import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/model/ReportModel.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

class ReportCard extends StatefulWidget {
  final ReportModel model;
  final VoidCallback? onDelete; // Optional delete callback

  const ReportCard({super.key, required this.model, this.onDelete});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _expanded = false;
  static const int _maxLines = 2;
  bool _showSeeMore = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Report ID: ${widget.model.id}',
              size: 20,
              color: Colors.black,
              weight: FontWeight.w700,
              align: TextAlign.left,
              screenHeight: screenHeight,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: screenHeight * 0.01),
            if (widget.model.filePath.isNotEmpty)
              Image.network(widget.model.filePath, fit: BoxFit.cover),
            SizedBox(height: screenHeight * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final span = TextSpan(
                    text: 'Reason: ${widget.model.description}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                  final tp = TextPainter(
                    text: span,
                    maxLines: _maxLines,
                    textDirection: TextDirection.ltr,
                  );
                  tp.layout(maxWidth: constraints.maxWidth);
                  _showSeeMore = tp.didExceedMaxLines;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason: ${widget.model.description}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: _expanded ? null : _maxLines,
                        overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                      if (_showSeeMore)
                        GestureDetector(
                          onTap: () => setState(() => _expanded = !_expanded),
                          child: Text(
                            _expanded ? 'See less' : 'See more',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Delete Report',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: widget.onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}