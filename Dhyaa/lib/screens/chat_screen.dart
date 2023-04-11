import 'package:Dhyaa/screens/message_textfield.dart';
import 'package:Dhyaa/screens/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../singlton.dart';


class ChatScreen extends StatelessWidget {
  final String friendId;
  final String friendName;
  //  UserData userData ;
  // int numberread;
  int numberOfUnRead = 0;

  ChatScreen({
    required this.friendId,
    required this.friendName,
    //required this.userData,
    //  int? numberread,

  });


  updateUser(id) async {
    await FirebaseFirestore.instance.collection("Users").doc(Singleton.instance.userId).collection('message').doc(friendId).collection('chats').doc(id).update({
      "isRead": true,
    });
  }

  updateUserread() async {
    print("Singleton.instance.userId");
    print(Singleton.instance.userId);
    await FirebaseFirestore.instance.collection("Users").doc(Singleton.instance.userId).collection('message').doc(friendId).set({
      "numberOfRead": 0,
    },SetOptions(merge: true)
    );
    //Do your stuff.
  }

  updateUserRead(numberOfUnRead) async {
    print("numberOfUnRead");
    print(numberOfUnRead);
    //updateRead();
    await FirebaseFirestore.instance.collection('Users').doc(friendId).collection('message').doc(Singleton.instance.userId).set({
      "numberOfRead": numberOfUnRead,
    },SetOptions(merge: true)
    );
  }

  //  updateRead() async {
  //
  //   print("numberOfUnRead");
  //   print(numberOfUnRead);
  //   var document = await FirebaseFirestore.instance.collection('Users')
  //       .doc(friendId).collection('message').doc(userData.userId);
  //   document.get().then((document) {
  //     print("hiiiiiiiiiiiiiiiiii");
  //   print(document.data()!['numberOfRead']);
  //     numberOfUnRead = document.data()!['numberOfRead'];
  //   });
  //
  // }


  @override
  Widget build(BuildContext context) {
    updateUserread();
    //updateRead();
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xff2d99cd),
        title: Row(
          children: [
            Text(friendName,style: TextStyle(fontSize: 20),)
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),

        ),

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
                stream: FirebaseFirestore.instance.collection("Users").doc(Singleton.instance.userId).collection('message').doc(friendId).collection('chats').orderBy("date",descending: true).snapshots(),
                builder:(context,AsyncSnapshot snapshot){
                  if(snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text("say hi"),
                      );
                    }
                    //numberOfUnRead = 0;

                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          bool isMe = snapshot.data.docs[index]['senderId']==Singleton.instance.userId;
                          if (snapshot.data.docs[index]['senderId']==friendId && snapshot.data.docs[index]['isRead']== false ) {
                            print(snapshot.data.docs[index].id);
                            updateUser(snapshot.data.docs[index].id);
                            updateUserread();
                            // updateRead();
                            print(numberOfUnRead);
                          }
                          //  if (snapshot.data.docs[index]['receiverId']==friendId && snapshot.data.docs[index]['isRead']== false ) {
                          //    print(snapshot.data.docs[index].id);
                          //    numberOfUnRead++;
                          //    // snapshot.data.docs[index].id.update({
                          //    //  "isRead": true,});
                          //    print(numberOfUnRead);
                          // //   numberOfUnRead = 0;
                          //  }

                          // updateUserRead(numberOfUnRead);
                          print(DateTime.now().toString().substring(11, 16));
                          print(DateTime.now());

                          return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe,date: snapshot.data.docs[index]['date']);

                        });
                  }
                  print("numberOfUnRead");
                  print(numberOfUnRead);
                  return Center(
                      child: CircularProgressIndicator()
                  );

                }),

          )),

          MessageTextField(friendName, friendId),

        ],
      ),
    );
  }

}
