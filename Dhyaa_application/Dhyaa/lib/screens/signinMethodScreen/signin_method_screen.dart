import 'package:flutter/material.dart';
import 'package:Dhyaa/globalWidgets/sizedBoxWidget/sized_box_widget.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/screens/signinMethodScreen/createAccount/create_account.dart';
import 'package:Dhyaa/screens/signinMethodScreen/loginScreen/login_screen.dart';
import 'package:Dhyaa/theme/theme.dart';

import '../../responsiveBloc/size_config.dart';

class SignInMethod extends StatefulWidget {
  const SignInMethod({Key? key}) : super(key: key);

  @override
  State<SignInMethod> createState() => _SignInMethodState();
}

class _SignInMethodState extends State<SignInMethod> {
  @override
  void initState() {
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              sizedBox(),
              Image.asset(
                'assets/icons/DhyaaLogo.png',
                height: screenWidth * 50,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                            .copyWith(bottom: screenWidth),
                        padding: EdgeInsets.all(screenWidth * 4.3),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 50),
                            color: theme.blueColor),
                        child: text('تسجيل الدخول', screenWidth * 3.4,
                            theme.whiteColor)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateAccountScreen()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                            .copyWith(bottom: 0),
                        padding: EdgeInsets.all(screenWidth * 4.3),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.mainColor),
                          borderRadius: BorderRadius.circular(screenWidth * 50),
                        ),
                        child: text(
                            'إنشاء حساب', screenWidth * 3.4, theme.mainColor)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
