import 'package:flutter/material.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/theme/theme.dart';

import '../../screens/signinMethodScreen/signin_method_screen.dart';

AppBar appBar1(title, screenWidth, context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInMethod()));
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: theme.mainColor,
          size: screenWidth * 5,
        )),
    centerTitle: true,
    title: text(title, screenWidth * 4, theme.mainColor,
        fontWeight: FontWeight.w500),
  );
}
