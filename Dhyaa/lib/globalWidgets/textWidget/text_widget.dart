import 'package:flutter/material.dart' show FontWeight, Text, TextAlign, TextDecoration, TextStyle, Widget;

Widget text(
  text,
  fontSize,
  textColor, {
  align = TextAlign.left,
  textDecoration = TextDecoration.none,
  fontWeight = FontWeight.w400,
  fontFamily = 'cr',
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      decoration: textDecoration,
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    ),
  );
}

TextStyle textStyle(
  fontSize,
  textColor, {
  textDecoration = TextDecoration.none,
  fontWeight = FontWeight.w400,
  fontFamily = 'cr',
}) {
  return TextStyle(
    decoration: textDecoration,
    color: textColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
  );
}
