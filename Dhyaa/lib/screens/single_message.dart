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
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
   print(DateTime.now());
   print("DateTime.now()");
   print(DateTime.now().day == date.toDate().toString().substring(8, 10));
   print(DateTime.now().month == date.toDate().toString().substring(6, 7));
   print(DateTime.now().year == date.toDate().toString().substring(0, 4));
   print("DateTime");
   print(date.toDate().toString().substring(8, 10));
   print(date.toDate().toString().substring(6, 7));
   print(date.toDate().toString().substring(0, 4));
   // print(date.toDate().substring(11, 16));
String time = date.toDate().toString().substring(11, 16);
    return Container(
      child: Row(
        crossAxisAlignment:isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: isMe ?  MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          //textDirection:TextDirection.RTL,
          crossAxisAlignment:isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
          //Align(
          Container(
           // alignment:isMe? Alignment.bottomRight:Alignment.bottomLeft,
             child:
           // Text(time,
           //     style: TextStyle(color: Colors.black54,),
           //     textAlign:TextAlign.end),

            Text((now.day.toString() == date.toDate().toString().substring(8, 10)) &&
                now.month == _getday(date.toDate().toString().substring(5, 7)) &&
                now.year.toString() == date.toDate().toString().substring(0, 4)
                ?date.toDate().toString().substring(11, 16)
                : date.toDate().toString().substring(8, 10)+" "+_getMonth(
                date.toDate().toString().substring(5, 7)),
              style: TextStyle(color: Colors.black54,),
              textAlign:TextAlign.end),
        ),
               ], ),


      ],
      ),

    );

  }
  static _getMonth(String date){
    switch(date){
      case "01":
        return 'jan';
      case "02":
        return 'Feb';
      case "03":
        return 'Mar';
      case "04":
        return 'Apr';
      case "05":
        return 'May';
      case "06":
        return 'Jun';
      case "07":
        return 'Jul';
      case "08":
        return 'Aug';
      case "09":
        return 'Sept';
      case "10":
        return 'Oct';
      case "11":
        return 'Nov';
      case "12":
        return 'Dec';
    }
  }
  static _getday(String date){
    switch(date){
      case "01":
        return 1;
      case "02":
        return 2;
      case "03":
        return 3;
      case "04":
        return 4;
      case "05":
        return 5;
      case "06":
        return 6;
      case "07":
        return 7;
      case "08":
        return 8;
      case "09":
        return 9;
      case "10":
        return 10;
      case "11":
        return 11;
      case "12":
        return 12;
    }
  }
}
