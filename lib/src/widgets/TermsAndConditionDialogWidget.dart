
import 'package:flutter/material.dart';

class TermsAndConditionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText1;
  final String buttonText2;
  final Function onAccept;
  final Function onDecline;
  final String imagePath;

  const TermsAndConditionDialog({
    required this.title,
    required this.content,
    required this.buttonText1,
    required this.buttonText2,
    required this.onAccept,
    required this.onDecline,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(imagePath, height: 80, width: 80),
            const SizedBox(height: 20),
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(buttonText1),
          onPressed: () => onAccept(),
        ),
        TextButton(
          child: Text(buttonText2),
          onPressed: () => onDecline(),
        ),
      ],
    );
  }
}