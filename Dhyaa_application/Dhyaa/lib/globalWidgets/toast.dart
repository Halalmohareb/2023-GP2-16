import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Dhyaa/theme/theme.dart';

showToast(text, {isSuccess = true}) {
  Fluttertoast.showToast(
      msg: text ?? "",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isSuccess ? theme.mainColor : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
