import 'package:flutter/material.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/signinMethodScreen/signin_method_screen.dart';
import 'package:Dhyaa/theme/theme.dart';

import '../student/student_homepage.dart';
import '../tutor/tutor_homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig.widthMultiplier;
    return Scaffold(
      backgroundColor: theme.appBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/DhyaaLogo.png',
                height: screenWidth * 50,
                fit: BoxFit.contain,
              )
            ],
          ),
        ),
      ),
    );
  }
}
