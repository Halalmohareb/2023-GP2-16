import 'package:Dhyaa/screens/message_textfield.dart';
import 'package:Dhyaa/screens/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';


class ChatScreen extends StatelessWidget {
   final String friendId;
   final String friendName;
   UserData userData ;


   ChatScreen({
    required this.friendId,
    required this.friendName,
    required this.userData,
});



   @override
  Widget build(BuildContext context) {
     print(userData.username);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xff4B7FFB),
        title: Row(
          children: [
           Text(friendName,style: TextStyle(fontSize: 20),)
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),

        ),
        // actions: [
        //   Container(
        //     padding: EdgeInsets.symmetric(vertical: 10),
        //     margin: EdgeInsets.only(right: 20),
        //     child: Text(friendName,style: TextStyle(fontSize: 20,color:Colors.black),),
        //   ),
        // ],
        // title: Row(
        //   children: [
        //    Text(friendName,style: TextStyle(fontSize: 20,color:Colors.black),),
        //
        //   ],
        // ),
      ),
        body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25)
              )
            ),
           child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Users").doc(userData.userId).collection('message').doc(friendId).collection('chats').orderBy("date",descending: true).snapshots(),
                builder:(context,AsyncSnapshot snapshot){
                if(snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return Center(
                      child: Text("say hi"),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        bool isMe = snapshot.data.docs[index]['senderId']==userData.userId;
                        print(DateTime.now().toString().substring(11, 16));
                        print(DateTime.now());
                        return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe,date: snapshot.data.docs[index]['date']);
                      });
                }
                return Center(
                  child: CircularProgressIndicator()
                );
              }),
          )),
  //       Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Divider(),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             MessageTextField(friendName, friendId)
  //             //  Expanded(child: Container(
  //                // padding: EdgeInsets.all(10),
  //                //  decoration: BoxDecoration(
  //                //    color: Colors.white,
  //                //    borderRadius: BorderRadius.only(
  //                //     topLeft: Radius.circular(25),
  //                //     topRight: Radius.circular(25)
  //                //   ),
  //                //  ),
  //             // child: Container(),
  //             // ))
  //
  // ],
  //   ),
  //   ),
       MessageTextField(friendName, friendId)
      ],
    ),
    );
  }

}
