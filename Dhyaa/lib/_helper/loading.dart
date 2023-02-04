import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:flutter/material.dart';

showLoader(BuildContext context, message) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(1),
          child: CircularProgressIndicator(
            backgroundColor: kWhiteColor,
            color: kBlueColor,
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(7),
          child: Text(
            message,
            maxLines: 5,
          ),
        )),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

pop(BuildContext context) {
  Navigator.pop(context);
}
