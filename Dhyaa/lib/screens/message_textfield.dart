
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
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
  void initState() {
    FirestoreHelper.getMyUserData().then((value) {
      setState(() {
        userData = value;
      });
    });
    super.initState();
  }
  int numberOfUnRead =0;
  updateRead() async {

    print("numberOfUnRead");
    print(numberOfUnRead);
    var document = await FirebaseFirestore.instance.collection('Users')
        .doc(widget.friendId).collection('message').doc(userData.userId);
    document.get().then((document) {
      print("hiiiiiiiiiiiiiiiiii");
      print(document.data()!['numberOfRead']);
      numberOfUnRead = document.data()!['numberOfRead']+1;
    });

  }
  @override
  Widget build(BuildContext context) {

    print("reeeeeeeeeeeeeeeeeeeeeeee");
    print("numberOfUnRead");
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
              updateRead();
              String message =_controller.text;
              _controller.clear();
              // DocumentSnapshot document = await FirebaseFirestore.instance.collection('users').doc(widget.friendId).get();
              // number = document['numberOfRead'];
              // print("number");
              // print(number);
             // number =FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('message').doc(widget.friendId)['numberOfRead'];
              await FirebaseFirestore.instance.collection('Users').doc(userData.userId).collection('message').doc(widget.friendId).collection('chats').add({
                "senderId":userData.userId,
                "receiverId":widget.friendId,
                "message": message,
                "type":"text",
                "isRead":false,
                "date":DateTime.now(),
                //.toString().substring(11, 16)

              }).then((value) {
                FirebaseFirestore.instance.collection('Users').doc(userData.userId).collection('message').doc(widget.friendId).set({
                  'last_msg':message,
                  "datemsg":DateTime.now(),
                  "numberOfRead": 0 ,
                });
              });
              await FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('message').doc(userData.userId).collection('chats').add({
                "senderId":userData.userId,
                "receiverId":widget.friendId,
                "message": message,
                "type":"text",
                "isRead":false,
                "date":DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('message').doc(userData.userId).set({
                  'last_msg':message,
                  "datemsg":DateTime.now(),
                  "numberOfRead": numberOfUnRead ,
                });
              });

            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
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
