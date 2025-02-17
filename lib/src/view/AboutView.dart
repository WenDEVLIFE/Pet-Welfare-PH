import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/AppColors.dart';

class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  TermsAndConditionState createState() => TermsAndConditionState();
}

class TermsAndConditionState extends State<AboutView> {
  String termsText = "";

  @override
  void initState() {
    super.initState();
    loadTermsAndConditions();
  }

  Future<void> loadTermsAndConditions() async {
    final String text = await rootBundle.loadString("assets/word/terms.txt");
    setState(() {
      termsText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About us',
          style: TextStyle(
            fontFamily: 'SmoochSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.orange,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              termsText,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontFamily: 'SmoochSans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}