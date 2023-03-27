import 'package:Dhyaa/globalWidgets/toast.dart';
import 'package:Dhyaa/models/appointment.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/theme/loader.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class VerifyPayment extends StatefulWidget {
  final Appointment appointmentData;
  final dynamic url;
  final dynamic userData;
  final dynamic myUserData;
  const VerifyPayment(
      {super.key, required this.url, required this.appointmentData, this.userData, this.myUserData});

  @override
  State<VerifyPayment> createState() => _VerifyPaymentState();
}

class _VerifyPaymentState extends State<VerifyPayment> {
  String studentToken = "";
  String tutartoken = "";


  void initState() {
    super.initState();
    getusertoken();
    getusertokenB();
  }

  getusertoken() async {
    DocumentSnapshot snap =
    await FirebaseFirestore.instance.collection("Users").doc(widget.userData.userId).collection('token').doc(widget.userData.userId).get();
    tutartoken = snap['token'];
    print("to  get token");
    print(tutartoken);
  }
  getusertokenB() async {
    DocumentSnapshot snap =
    await FirebaseFirestore.instance.collection("Users").doc(widget.myUserData.userId).collection('token').doc(widget.myUserData.userId).get();
    studentToken = snap['token'];
    print("to  get token");
    print(studentToken);
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


  doBook(id) {
    widget.appointmentData.paymentId = id;
    FirestoreHelper.bookAppointment(widget.appointmentData).then((value) {
      showToast('تم حجز الموعد بنجاح');
    });
    sendNotification("ضياء",
        tutartoken,
        "تم اضافه موعد جديد بنجاح");
    sendNotification("ضياء",
        studentToken,
        "تم اضافه موعد جديد بنجاح  ");
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'الدفع قيد المعالجة',
          style: TextStyle(
            color: theme.mainColor,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            margin: EdgeInsets.only(right: 20),
            child: Image.asset('assets/icons/DhyaaLogo.png', height: 40),
          ),
        ],
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {
          final uri = Uri.parse(url);
          if (uri.host == 'www.google.com' || uri.host == 'google.com') {
            print(uri.queryParameters);
            if (uri.queryParameters['status'] == 'paid') {
              doBook(uri.queryParameters['id']);
            } else {
              showToast('فشل الدفع ، يرجى المحاولة مرة أخرى.');
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
