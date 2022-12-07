import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';


class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final  date;

  SingleMessage({
    required this.message,
    required this.isMe,
    required this.date,
});

  @override
  Widget build(BuildContext context) {
   print(date.toDate().toString().substring(11, 16));
   // print(date.toDate().substring(11, 16));
String time = date.toDate().toString().substring(11, 16);
    return Row(
      mainAxisAlignment: isMe ?  MainAxisAlignment.end : MainAxisAlignment.start,
      children: [


        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
   // child: Text(message,style: TextStyle(color: Colors.white,)),

          child:
              Column(
                children: [
                 Text(message,style: TextStyle(color: Colors.white,)),
          Align(
            alignment: Alignment.centerRight,
            child:
            Text(time, style: TextStyle(color: Colors.grey),),
          ),
                ], ),

        ),


      ],
    );

  }
}
