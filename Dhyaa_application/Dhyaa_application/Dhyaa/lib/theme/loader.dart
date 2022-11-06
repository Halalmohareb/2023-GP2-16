import 'package:flutter/material.dart';


  showAlertDialog(BuildContext context, message) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: CircularProgressIndicator(),
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
