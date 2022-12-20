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
    return Container(
      child: Row(
      mainAxisAlignment: isMe ?  MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: isMe ?  MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey,
    //borderRadius:BorderRadius.all(Radius.circular(12)),
            borderRadius: isMe?
            BorderRadius.only(
              topLeft:Radius.circular(23),
              topRight:Radius.circular(23),
                bottomLeft:Radius.circular(23),
               ):
            BorderRadius.only(
              topLeft:Radius.circular(23),
              topRight:Radius.circular(23),
              bottomRight:Radius.circular(23),
            )
          ),
    child: Text(message,style: TextStyle(color: Colors.white,)),
    ),
          // child:
          //     Column(
          //       children: [
           //  Text(message,style: TextStyle(color: Colors.black54,)),
          Align(
            alignment:isMe? Alignment.bottomRight:Alignment.bottomLeft,
             child:
           Text(time, style: TextStyle(color: Colors.black54,),),
        ),
               ], ),


      ],
      ),

    );

  }
}
