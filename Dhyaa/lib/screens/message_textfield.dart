
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../singlton.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import'package:http/http.dart' as http;

class MessageTextField extends StatefulWidget {
  final String? currentId;
  final String? friendId;
  //final int? numberOfUnRead;

  MessageTextField(
      this.currentId,
      this.friendId,
      //this.numberOfUnRead
      );
  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}
class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  UserData userData = emptyUserData;

  @override
  // void initState() {
  //   FirestoreHelper.getMyUserData().then((value) {
  //     setState(() {
  //       userData = value;
  //     });
  //   });
  //   super.initState();
  // }
  int numberOfUnRead =0;
  String currentname = Singleton.instance.userData!.username;
  bool ismessage = false;
  MaterialColor coloricon =Colors.grey;
  String lastMessageId = "";
  String rseverToken = "";

  updateRead() async {
    print("numberOfUnRead");
    print(numberOfUnRead);
    var document = await FirebaseFirestore.instance.collection('Users')
        .doc(widget.friendId).collection('message').doc(Singleton.instance.userId);
    document.get().then((document) {
      print("hiiiiiiiiiiiiiiiiii");
      print(document.data()!['numberOfRead']);
      numberOfUnRead = document.data()!['numberOfRead']+1;
    });

  }

  gettoken() async {
    print("rseverToken");
    print(rseverToken);
    DocumentSnapshot snap =
    await FirebaseFirestore.instance.collection("Users").doc(widget.friendId).collection('token').doc(widget.friendId).get();

    rseverToken = snap['token'];
    // var document = await FirebaseFirestore.instance.collection('Users')
    //     .doc(widget.friendId).collection('token').doc(widget.friendId);
    // document.get().then((document) {
    print("to  get token");
    print(rseverToken);
    //   rseverToken = document.data()!['token'];
    // });

  }

  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();


    //
    //   FirebaseMessaging.onMessage.listen((event) {
    //     print('incoming message is : $event');
    //     String? messageId = event.messageId ;
    // print("message send");
    // if( lastMessageId != messageId) {
    // lastMessageId = messageId!;
    // print(
    // '_mapListenToMessagesToState onMessage() listener: received new message');
    // LocalNotificationService.display(event);
    // }else{
    //   print("you have alredy send this message");
    // }
    //    // LocalNotificationService.display(event);
    //   });
    // storeNotificationsToken();
    // sendNotification('title', "cBD9V4dsTxaQRLE5inYfli:APA91bHvScLQYpGaRv4zxcSPfA2y2xhtQvjlToYtR8vTJ7sMYzCzd5lL");

  }



  sendNotification(String title, String token, String messages)async{


    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '0',
      'status': 'done',
      'message': title,
      "title_loc_key": "notification_title",
      "body_loc_key": "notification_message"
    };

    try{
      http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAIVO33Gg:APA91bH0Bus7E6OwJi2bR3Qoj3clfScVv7_SP1PFhLZYCQPI5ys659fZC6mjJ3oNkMEgGszPQdBOHZBw6Znn3FqZy6W2-zgEj_PkHY0wbMC3RYA2HnDfB-GrX0_d7NWomod6Nddg1bHd'
      },
          body: jsonEncode(<String,dynamic>{
            'notification': <String,dynamic> {'title': title,'body': messages},
            'priority': 'high',
            'data': data,
            'to': '$token'
          })
      );


      if(response.statusCode == 200){
        print("Yeh notificatin is sended");
      }else{
        print("Error");
      }

    }catch(e){

    }

  }

  @override
  Widget build(BuildContext context) {

    print("reeeeeeeeeeeeeeeeeeeeeeee");
    print(Singleton.instance.userId);
    // initState();
    print(userData.username);
    print(widget.friendId);
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.end ,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(child: TextField(
            textAlign: TextAlign.right,
            controller: _controller,
            textDirection: TextDirection.rtl,
            onChanged: (value) {
              setState(() {
                if(value == ""){
                  ismessage = false;
                  print(ismessage);
                  coloricon =Colors.grey;
                }else{
                  ismessage = true;
                  print(ismessage);
                  coloricon =Colors.blue;
                }
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25)
              ),
              labelText:"                                                           ....اكتب",
              hintTextDirection: TextDirection.rtl,
              fillColor: Colors.grey[100],
              filled: true,
            ),
          )),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: ()async{
              if (_controller.text == ""){
                ismessage = false;
                print(ismessage);
              }else {
                ismessage = true;
                print("_controller.text");
                print(_controller.text);
                gettoken();
                updateRead();
                String message = _controller.text;
                _controller.clear();
                // DocumentSnapshot document = await FirebaseFirestore.instance.collection('users').doc(widget.friendId).get();
                // number = document['numberOfRead'];
                // print("number");
                // print(number);
                // number =FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('message').doc(widget.friendId)['numberOfRead'];
                await FirebaseFirestore.instance.collection('Users').doc(
                    Singleton.instance.userId).collection('message').doc(
                    widget.friendId).collection('chats').add({
                  "senderId": Singleton.instance.userId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "isRead": false,
                  "date": DateTime.now(),
                  //.toString().substring(11, 16)

                }).then((value) {
                  FirebaseFirestore.instance.collection('Users').doc(
                      Singleton.instance.userId).collection('message').doc(
                      widget.friendId).set({
                    'last_msg': message,
                    "datemsg": DateTime.now(),
                    "numberOfRead": 0,
                  });
                });
                await FirebaseFirestore.instance.collection('Users').doc(
                    widget.friendId).collection('message').doc(
                    Singleton.instance.userId).collection('chats').add({
                  "senderId": Singleton.instance.userId,
                  "receiverId": widget.friendId,
                  "message": message,
                  "type": "text",
                  "isRead": false,
                  "date": DateTime.now(),
                }).then((value) {
                  FirebaseFirestore.instance.collection('Users').doc(
                      widget.friendId).collection('message').doc(
                      Singleton.instance.userId).set({
                    'last_msg': message,
                    "datemsg": DateTime.now(),
                    "numberOfRead": numberOfUnRead,
                  });
                });
                if(numberOfUnRead != 0) {
                  sendNotification(currentname,
                      rseverToken,
                      message);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: coloricon,
              ),
              child: Icon(Icons.send,
                color: Colors.white,
                textDirection: TextDirection.rtl,
              ),
            ),

          )
        ],
      ),
    );
  }
}
