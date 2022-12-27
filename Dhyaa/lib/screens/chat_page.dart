import 'package:Dhyaa/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../theme/studentTopBarNavigator.dart';

 class ChatPage  extends StatefulWidget {


  @override
  State<ChatPage>  createState() => _ChatPageState();
}

 class _ChatPageState extends State<ChatPage> {
  UserData userData = emptyUserData;



  @override
  void  initState() {
    FirestoreHelper.getMyUserData().then((value) {
      setState(() {
        userData = value;
      });
    });
    super.initState();
    print("initState Called");
  }

   Widget build(BuildContext context) {
   // print(userData.username);
     print("initState Called 2");
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xffF9F9F9),
          title: StudentTopBarNavigator(), toolbarHeight: 70,),

    // return GestureDetector(
    //     onTap: () {
    //   FocusScope.of(context).unfocus();
    // },
    // child: Scaffold(
    // backgroundColor: kBackgroundColor,
    // body: SafeArea(
    // bottom: false,
    // child: SingleChildScrollView(
    // child: Column(
    // children: [
    // StudentTopBarNavigator(),
    // Padding(
    // padding: EdgeInsets.symmetric(horizontal: 20),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.end,
    // children: [
    // Divider(),
    // SizedBox(
    // height: 10,
    // ),
     body:  StreamBuilder(

        stream: FirebaseFirestore.instance.collection('Users').doc(userData.userId).collection('message').snapshots() ,
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length < 1 ){
              //print("no no no ");
              return Center(
                child: Text("no chat"),
              );
            }
            return ListView.builder(
              itemCount:snapshot.data.docs.length ,
              itemBuilder:(context,index){
                var friendId = snapshot.data.docs[index].id;
                var lastMsg = snapshot.data.docs[index]['last_msg'];
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('Users').doc(friendId).get() ,
                  builder: (context,AsyncSnapshot asyncSnapshot){
                    if(asyncSnapshot.hasData){
                      var friend = asyncSnapshot.data;
                      return ListTile(
                        leading: CircleAvatar(
                           child: Icon(Icons.account_circle,
                               color:Color(0xff4B7FFB),
                               size: 35,
                             ),
                            backgroundColor:Colors.white,
                        ),
                        title: Text(friend['username'],),
                        subtitle: Container(
                          child:Text("$lastMsg",style: TextStyle(color: Colors.grey),overflow:TextOverflow.ellipsis,),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                              friendId: friend['userId'],
                              friendName: friend['username'],
                              userData: userData)));
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
        })
    //],
    // ),
    // ),
    // ],
    // ),
    // ),
    // ),
    // ),
    );

  }
}
