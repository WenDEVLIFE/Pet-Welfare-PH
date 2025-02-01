import 'package:flutter/material.dart';

class TermsAndConditionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function onAccept;
  final String imagePath;

  TermsAndConditionDialog({
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onAccept,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(imagePath),
            SizedBox(height: 20),
            Text(content),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(buttonText),
          onPressed: () => onAccept(),
        ),
      ],
    );
  }
}