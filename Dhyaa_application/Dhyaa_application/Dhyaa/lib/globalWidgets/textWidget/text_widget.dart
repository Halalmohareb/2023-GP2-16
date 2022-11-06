import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget text(
  text,
  fontSize,
  textColor, {
  align = TextAlign.left,
  textDecoration = TextDecoration.none,
  fontWeight = FontWeight.w400,
}) {
  return Text(
    text,
    textAlign: align,
    style: GoogleFonts.poppins(
      decoration: textDecoration,
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

TextStyle textStyle(
  fontSize,
  textColor, {
  textDecoration = TextDecoration.none,
  fontWeight = FontWeight.w400,
}) {
  return GoogleFonts.poppins(
    decoration: textDecoration,
    color: textColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}
