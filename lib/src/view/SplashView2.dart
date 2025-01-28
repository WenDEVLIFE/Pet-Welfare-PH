import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class SplashView2 extends StatefulWidget {
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView2> {
  // initializing video player
  final VideoPlayerController videoPlayerController =
  VideoPlayerController.asset("assets/dogcat.mp4");

  ChewieController? chewieController;

  // init State
  @override
  void initState() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9 / 20,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      showControls: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Expanded(
              child: Chewie(
                controller: chewieController!,
              )),
          Container(color: Colors.black54),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'WELCOME, USER'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      letterSpacing: 0.2,
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'Looking for a pet? You are in the right place!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () {},
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}