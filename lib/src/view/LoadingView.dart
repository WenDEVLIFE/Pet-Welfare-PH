import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/AppColors.dart';
import '../utils/ImageUtils.dart';
import '../view_model/LoadingViewModel.dart';

class LoadingView extends StatefulWidget {
  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoadingViewModel>(context, listen: false).startLoading(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashViewModel = Provider.of<LoadingViewModel>(context, listen: true);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.orange,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(), // Empty space at the top
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageUtils.logoPath),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  splashViewModel.isLoading
                      ? const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : const Text(''),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'PET ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'WELFARE ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'PH',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'SmoochSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}