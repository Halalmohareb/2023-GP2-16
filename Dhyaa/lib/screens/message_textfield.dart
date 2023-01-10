
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../singlton.dart';
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
  bool ismessage = false;
  MaterialColor coloricon =Colors.grey;
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
