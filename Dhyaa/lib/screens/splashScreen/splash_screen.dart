import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/signinMethodScreen/signin_method_screen.dart';
import 'package:Dhyaa/theme/theme.dart';

import '../student/student_homepage.dart';
import '../tutor/tutor_homepage.dart';

class SplashScreen extends StatefulWidget {
  final dynamic path;
  final dynamic aspectRatio;
  const SplashScreen(
      {super.key, required this.path, required this.aspectRatio});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variables
  late BetterPlayerController _betterPlayerController;

  // Function

  @override
  void initState() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.memory,
      '',
      bytes: widget.path,
      videoExtension: "mp4",
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        autoDispose: true,
        fit: BoxFit.cover,
        aspectRatio: widget.aspectRatio,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          backgroundColor: Colors.white,
          showControls: false,
          enableMute: false,
          enableProgressBar: false,
          enableFullscreen: false,
          enableQualities: false,
          enablePip: false,
          enableProgressBarDrag: false,
          enableProgressText: false,
          enableSkips: false,
          enablePlayPause: Platform.isIOS ? false : false,
          enableAudioTracks: false,
          enableOverflowMenu: false,
          enablePlaybackSpeed: false,
          enableRetry: false,
          enableSubtitles: false,
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
    timer();
    super.initState();
  }

  timer() {
    Future.delayed(Duration(milliseconds: 4000), goNext);
  }

  goNext() {
    FirestoreHelper.getUserType().then(
      (value) {
        if (value == "Student") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => StudentHomepage(),
              ),
              (Route<dynamic> route) => false);
        } else if (value == "Tutor") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => TutorHomepage(),
              ),
              (Route<dynamic> route) => false);
        } else {
          Future.delayed(Duration(seconds: 3)).then(
            (value) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignInMethod(),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white),
      body: BetterPlayer(controller: _betterPlayerController),
    );
  }
}
