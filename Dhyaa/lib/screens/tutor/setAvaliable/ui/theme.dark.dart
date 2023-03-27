import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color kBackgroundColor = Color(0xffF9F9F9);
const Color kWhiteColor = Color(0xffffffff);
const Color kOrangeColor = Color(0xffEF716B);
const Color kBlueColor = Color(0xff2d99cd);
const Color kYellowColor = Color(0xffFFB167);
const Color kTitleTextColor = Color(0xff1E1C61);
const Color kSearchBackgroundColor = Color(0xffF2F2F2);
const Color kSearchTextColor = Color(0xffC0C0C0);
const Color kCategoryTextColor = Color(0xff292685);

const Color white = Colors.white;
const primaryClr = kBlueColor;
const Color darkGreyClr = Color(0xFF121212);
Color? darkHeaderClr = Colors.grey[800];

class Themes {
  static final light = ThemeData(
    backgroundColor: kBackgroundColor,
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
    primaryColor: primaryClr,
  );
}

TextStyle get headingTextStyle {
  return TextStyle(
    fontSize: 20,
    fontFamily: 'cb',
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get subHeadingTextStyle {
  return TextStyle(
    fontSize: 18,
    fontFamily: 'cb',
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  );
}

TextStyle get titleTextStle {
  return TextStyle(
    fontSize: 18,
    fontFamily: 'cb',
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get subTitleTextStle {
  return TextStyle(
    fontSize: 16,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
  );
}

TextStyle get bodyTextStyle {
  return TextStyle(
    fontSize: 14,
    fontFamily: 'cb',
    color: Get.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get body2TextStyle {
  return TextStyle(
      fontSize: 14,
      fontFamily: 'cb',
      color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[600]);
}
