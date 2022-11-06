import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool isEmail(String em) {

  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

bool validatePassword(String value) {

    // String validateMyInput(String value) {
    String pattern = r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)";
    RegExp regex =  RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
    // }
}


bool isPhoneNoValid(String? phoneNo) {
  if (phoneNo == null) return false;
  final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  return regExp.hasMatch(phoneNo);
}

class InternationalPhoneFormatter extends TextInputFormatter {

  String internationalPhoneFormat(value) {
    String nums = value.replaceAll(RegExp(r'[\D]'), '');
    String internationalPhoneFormatted = nums.length >= 1
        ? '+' + nums.substring(0, nums.length >= 1 ? 1 : null) + (nums.length  > 1 ? ' (' : '') + nums.substring(1, nums.length >= 4 ? 4 : null)
        + (nums.length  > 4 ? ') ' : '') + (nums.length > 4
        ? nums.substring(4, nums.length >= 7 ? 7 : null) + (nums.length > 7
        ? '-' + nums.substring(7, nums.length >= 11 ? 11 : null)
        : '')
        : '')
        : nums;
    return internationalPhoneFormatted;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    return newValue.copyWith(
        text: internationalPhoneFormat(text),
        selection: new TextSelection.collapsed(offset: internationalPhoneFormat(text).length)
    );
  }
}