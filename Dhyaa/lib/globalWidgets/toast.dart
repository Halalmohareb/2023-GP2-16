import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Dhyaa/theme/theme.dart';

showToast(text, {isSuccess = true}) {
  Fluttertoast.showToast(
    msg: text ?? "",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: theme.mainColor,
    textColor: isSuccess ?theme.mainColor :theme.redColor ,
    fontSize: 16.0,
  );
}
