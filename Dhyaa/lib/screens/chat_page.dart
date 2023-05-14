import 'dart:convert';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/chat_screen.dart';
import 'package:Dhyaa/screens/services/local_push_notification.dart';
import 'package:Dhyaa/singlton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import'package:http/http.dart' as http;

import '../theme/topAppBar.dart';
import 'menu.dart';

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
      userData = value;
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

  }



  Widget build(BuildContext context) {

    return Scaffold (
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        toolbarHeight: 70,
        leading: Container(
        padding: EdgeInsets.symmetric(
        vertical:10,

    ),
    margin: EdgeInsets.only(left: 10),

        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) => Menu(userData: userData),
                maintainState: false,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: userData.avatar,
              height: 40,
              width: 40,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            margin: EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/icons/DhyaaLogo.png',
              height: 40,
            ),
          ),
        ],
      ),
      body:
      Center(
      child: StreamBuilder (
          stream:  FirebaseFirestore.instance.collection('Users').doc(
              Singleton.instance.userId).collection('message').orderBy("datemsg",descending: true).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return Center(
                  child: Text("لايوجد محادثه"),
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
                              child: CachedNetworkImage(
                                imageUrl: friend['avatar'],
                                placeholder: (context, url) =>
                                    Center(
                                      child: CircularProgressIndicator(),
                              ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                            ),
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

                              Text( now.day == lastMsgtime.day &&
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
