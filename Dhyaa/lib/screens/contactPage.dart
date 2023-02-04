import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import '../globalWidgets/textWidget/text_widget.dart';
import '../globalWidgets/toast.dart';
import '../models/UserData.dart';
import '../provider/firestore.dart';
import '../responsiveBloc/size_config.dart';
import '../singlton.dart';
import 'package:Dhyaa/theme/theme.dart';
class contactPage extends StatefulWidget {
  final String emil;
  contactPage({Key? key, required this.emil}) : super(key: key);
  @override
  State<contactPage> createState() => _contactPageState();
}
final nameController = TextEditingController();
final subjectController = TextEditingController();
final emailController = emaile;
final messagesController = TextEditingController();
final messageController = TextEditingController();
String emaile = "";
String ErrorTextEmail = '';
bool EmailValid = false;
bool notempty = false;
String ErrorAllFields = '';
bool AllFieldsValid = false;
String message = '';
Future sendEmail() async{
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceid ="service_t1ixpxo";
  const templateid ="template_jqgkfck";
  const userid ="ea_rtg-tVuvu21nh7";
  final response = await http.post(url,
      headers:{
        'origin': 'http:localhost',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "service_id":serviceid,
        "template_id":templateid,
        "user_id":userid,
        "template_params": {
          'from_name':nameController.text,
          'message':messagesController.text,
          'reply_to':emailController,
        }
      })
  );
  print(response.body);
}
user() async {
  var document = await FirebaseFirestore.instance.collection('Users')
      .doc((Singleton.instance.userId));
  document.get().then((document) {
    print("hiiiiiiiiiiiiiiiiii");
    emaile = document.data()!['email'];
    print(emaile);
  });
}
class _contactPageState extends State<contactPage> {
  Widget build(BuildContext context) {
    // user();
    emaile = widget.emil;
    print(widget.emil);
    var screenWidth = SizeConfig.widthMultiplier;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
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
      body: SingleChildScrollView(
        child: Padding (
          padding: const EdgeInsets.symmetric(horizontal:12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:25,
              ),
              Text(
                  "تواصل معنا",
                  style:TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                  )
              ),
              SizedBox(
                height:25,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  // icon: Icon(Icons.account_circle_outlined),
                  hintText: 'الاسم',
                  hintTextDirection:TextDirection.rtl ,
                  border:InputBorder.none,
                  filled: true,
                ),
              ),
              SizedBox(
                height:25,
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  //icon: Icon(Icons.subject),
                  hintText: 'الموضوع',
                  hintTextDirection:TextDirection.rtl ,
                  border:InputBorder.none,
                  filled: true,
                ),
              ),
              SizedBox(
                height:25,
              ),
              TextFormField(
                initialValue: emaile,
                textDirection:TextDirection.rtl ,
                decoration: const InputDecoration(
                  border:InputBorder.none,
                  filled: true,
                ),
              ),
              // TextField(
              //   restorationId :emailController,
              //   onChanged: (enteredEmail) => validateEmail(enteredEmail),
              //   //controller: emailController,
              //   decoration: const InputDecoration(
              //   //  icon: Icon(Icons.email),
              //     hintText: 'البريد الالكتروني',
              //     hintTextDirection:TextDirection.rtl ,
              //     border:InputBorder.none,
              //     filled: true,
              //   ),
              // ),
              SizedBox(
                height:25,
              ),
              TextField(
                maxLines: 7,
                controller: messagesController,
                decoration: const InputDecoration(
                  // icon: Icon(Icons.message),
                  hintText: 'الرسالة',
                  hintTextDirection:TextDirection.rtl ,
                  border:InputBorder.none,
                  filled: true,
                ),
              ),
              SizedBox(
                height:9,
              ),
              MaterialButton(
                  height: 45,
                  minWidth: double.infinity,
                  color: Color(0xff4B7FFB),
                  onPressed: (){
                    if(nameController.text.isEmpty ||
                        messagesController.text.isEmpty ||
                        //emailController.text.isEmpty ||
                        subjectController.text.isEmpty){
                      ErrorAllFields = 'خانه فاضيه';
                      print(ErrorAllFields);
                      showToast("خانه فاضيه", isSuccess: false);
                      // }else{
                      //   if(message.length > 0){
                      //     showToast("ادخل ايميل صحيح", isSuccess: false);
                      //     print(message);
                    }else {
                      sendEmail();
                      showToast("تم ارسال الرسالة ", isSuccess: true);
                    }
                    //  }
                  },
                  child: Text(
                    "ارسال",
                    style: TextStyle(color: Colors.white),
                  )),
              // ElevatedButton(
              //     onPressed: (){
              //       sendEmail();
              //     },
              //     child: Text(
              //       "send",
              //     ))
            ],
          ),
        ),
      ),
    );
  }
  void validateEmail(String enteredEmail) {
    if (EmailValidator.validate(enteredEmail)) {
      setState(() {
        message = '';
      });
    } else {
      setState(() {
        message = 'Please enter a valid email address!';
      });
    }
  }
}