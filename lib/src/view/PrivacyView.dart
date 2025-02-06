import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/AppColors.dart';

class Privacyview extends StatefulWidget {
  const Privacyview({Key? key}) : super(key: key);

  @override
  PrivacyState createState() => PrivacyState();
}

class PrivacyState extends State<Privacyview> {
  String termsText = "";

  @override
  void initState() {
    super.initState();
    loadTermsAndConditions();
  }

  Future<void> loadTermsAndConditions() async {
    String text = await rootBundle.loadString("assets/word/privacy.txt");
    setState(() {
      termsText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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