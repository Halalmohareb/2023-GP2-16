import 'package:Dhyaa/globalWidgets/sizedBoxWidget/sized_box_widget.dart';
import 'package:Dhyaa/screens/chat_screen.dart';
import 'package:Dhyaa/singlton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../constant.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../theme/studentTopBarNavigator.dart';

class ChatPage  extends StatefulWidget {



  @override
  State<ChatPage>  createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {
  DateTime now = DateTime.now();
  @override

  void initState() {
    // getUserData();
    super.initState();
  }

  // getUserData() async  {
  //   print("calling this data");
  //    await FirestoreHelper.getMyUserData().then((value) {
  //     userData = value;
  //     if (mounted) setState(() {print(userData.userId+"5");
  //     });
  //     print(userData.userId+"3");
  //   });
  // }

  Widget build(BuildContext context) {
    // print(userData.userId+"4");
    return Scaffold (
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        title: StudentTopBarNavigator(), toolbarHeight: 70,),
      body: // userData == emptyUserData?
      //  Center(child: Text(userData.email,),)
      StreamBuilder (
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

                    print("friendIdfriendIdfriendId");
                    print("friendIdfriendIdfriendId${friendId}hh");
                    print("friendIdfriendIdfriendId");
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    int numberread = snapshot.data.docs[index]['numberOfRead'];
                    DateTime lastMsgtime = snapshot.data.docs[index]['datemsg'].toDate();
                    // var readno = FirebaseFirestore.instance.collection("Users").doc(userData.userId).collection('message').doc(friendId).collection('chats')

                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('Users')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          print("friend data");
                          print("friend data${friend["username"]}");
                          print("friend data");
                          return ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.account_circle,
                                color: Color(0xff4B7FFB),
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
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 9,
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
                                  height: 4,
                                ),

                                Container(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Icon(Icons.circle,
                                        color: numberread==0?Colors.white : Colors.red.shade300,
                                        size: 30,
                                      ),
                                      Text(
                                        "$numberread",
                                        style: TextStyle(fontSize: 14,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      ChatScreen(
                                        friendId: friend['userId'],
                                        friendName: friend['username'],
                                        //userData: Singleton.instance.userData!,
                                        // numberread : numberread,
                                      )));
                            },
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
