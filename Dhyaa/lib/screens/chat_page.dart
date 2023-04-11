import 'dart:convert';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/chat_screen.dart';
import 'package:Dhyaa/screens/services/local_push_notification.dart';
import 'package:Dhyaa/singlton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import'package:http/http.dart' as http;

import '../theme/topAppBar.dart';

class ChatPage  extends StatefulWidget {



  @override
  State<ChatPage>  createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {
  DateTime now = DateTime.now();
  UserData userData = emptyUserData;
  String lastMessageId = "";
  var screenWidth = SizeConfig.widthMultiplier;

  @override


  void initState() {
    FirestoreHelper.getMyUserDatab().then((value) {
      if (mounted) setState(() {
      });
    });
    // getUserData();
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((event) {
      print('incoming message is : $event');
      String? messageId = event.messageId ;
      print("message send");
      if( lastMessageId != messageId) {
        lastMessageId = messageId!;
        print(
            '_mapListenToMessagesToState onMessage() listener: received new message');


        LocalNotificationService.display(event);
      }else{
        print("you have alredy send this message");
      }
      // LocalNotificationService.display(event);
    });
    //storeNotificationsToken();
    // sendNotification('title', "eLoVj1X-SvuxUEbJacb_kB:APA91bExLkuwu3gf9CXowxbToIYw3-aQOlPggki9I_NHMo09q1nT6LH0ElXUJK2an4wPSzPBehE1aoVIwQYYjnifKjsiom280One1ZNTB3PuL9bRfpPqo7lf1j5MuAHpnp20uQlWVYKT");

  }

  // sendNotification(String title, String token) async {
  //
  //   final data = {
  //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     'id': '0',
  //     'status': 'done',
  //     'message': title,
  //   };
  //
  //   try{
  //     http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
  //       'Content-Type': 'application/json',
  //       'Authorization':'key=AAAAIVO33Gg:APA91bH0Bus7E6OwJi2bR3Qoj3clfScVv7_SP1PFhLZYCQPI5ys659fZC6mjJ3oNkMEgGszPQdBOHZBw6Znn3FqZy6W2-zgEj_PkHY0wbMC3RYA2HnDfB-GrX0_d7NWomod6Nddg1bHd'
  //     },
  //         body: jsonEncode(<String,dynamic>{
  //           'notification': <String,dynamic> {'title': title,'body': 'You are followed by someone'},
  //           'priority': 'high',
  //           'data': data,
  //           'to': '$token'
  //         })
  //     );
  //
  //
  //     if(response.statusCode == 200){
  //       print("Yeh notificatin is sended");
  //     }else{
  //       print("Error");
  //     }
  //
  //   }catch(e){
  //
  //   }
  //
  // }



  Widget build(BuildContext context) {

    return Scaffold (
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        toolbarHeight: 70,),
      body:

      Center(
      child: StreamBuilder (
          stream:  FirebaseFirestore.instance.collection('Users').doc(
              Singleton.instance.userId).collection('message').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Text("no chat"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    int numberread = snapshot.data.docs[index]['numberOfRead'];
                    DateTime lastMsgtime = snapshot.data.docs[index]['datemsg'].toDate();


                    return
                      FutureBuilder(
                      future: FirebaseFirestore.instance.collection('Users')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          print("friend data");
                          print("friend data${friend["username"]}");
                          print("friend data");
                          return SingleChildScrollView(
                            //  padding: EdgeInsets.all(10),
                            child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.account_circle,
                                color: Color(0xff2d99cd),
                                size: 35,
                              ),
                              backgroundColor: Colors.white,
                            ),
                            title: Text(friend['username'],),
                            subtitle: Container(
                              child: Text("$lastMsg",
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,),
                            ),
                            trailing: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  height: 0,
                                ),

                                Text(now.day == lastMsgtime.day &&
                                    now.month == lastMsgtime.month &&
                                    now.year == lastMsgtime.year
                                    ? "$lastMsgtime".substring(11, 16)
                                    : "${lastMsgtime.day} ${_getMonth(
                                    lastMsgtime)}",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .overline
                                      ?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),

                                Container(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Icon(Icons.circle,
                                        color: numberread==0?Colors.white : Colors.red.shade300,
                                        size: screenWidth * 7,
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        "$numberread",
                                        style: TextStyle(fontSize: screenWidth * 3.9,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),),
                            onTap: () {
                              //   sendNotification('title', "eRL7_SxLQM6Z0b_esIWeT0:APA91bEhjVms40CukwPIjX16AqGMXGJVYCED8TVKcF5L_7fUIiFjaWcEWRxydhyescRM1sIu24h73EkroUkbUTwRyFEpQCPnFu4W2sFqkcJj1DnOA1Kc3_sSciLK2sr9N-2b832no8jd");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      ChatScreen(
                                        friendId: friend['userId'],
                                        friendName: friend['username'],
                                      )));
                            },

                          )
                          );
                        }
                        return LinearProgressIndicator(

                        );
                      },
                      );
                  });
            }
            return Center(child: CircularProgressIndicator(),);
          }),
    ),
    );
  }

  static _getMonth(DateTime date){
    switch(date.month){
      case 1:
        return 'jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
  }
}
