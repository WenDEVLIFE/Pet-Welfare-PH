import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/view_model/SplashViewModel.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class SplashView2 extends StatefulWidget {
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView2> {
  final VideoPlayerController videoPlayerController =
  VideoPlayerController.asset("assets/video/dogcat.mp4");

  ChewieController? chewieController;

  late SplashViewModel2 splashViewModel;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9 / 20,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      showControls: false,
    );

    splashViewModel = Provider.of<SplashViewModel2>(context, listen: false);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SizedBox.expand(
            child: Chewie(
              controller: chewieController!,
            ),
          ),
          Container(color: AppColors.orange.withOpacity(0.8)),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'WELCOME!'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'SmoochSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      letterSpacing: 0.2,
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'Do you adore pets? Do you have one you take care of? Maybe more? This pet community warmly welcomes you in our midst.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SmoochSans',
                      fontSize: 22,
                      letterSpacing: 0.2,
                      wordSpacing: 0.2,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Provider.of<SplashViewModel2>(context, listen: false).navigateLogin(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'SmoochSans',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () {
                        Provider.of<SplashViewModel2>(context, listen: false).navigateToRegister(context);
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontFamily: 'SmoochSans',
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}