import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';

import '../signinMethodScreen/loginScreen/login_screen.dart';

class EditStudentPage extends StatefulWidget {
  const EditStudentPage({super.key});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  UserData userData = emptyUserData;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController location = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController subject = new TextEditingController();
  TextEditingController degree = new TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  getMyData() async {
    FirestoreHelper.getMyUserData().then((value) {
      setState(() {
        userData = value;
      });
    });
  }

  @override
  void initState() {
    getMyData();
    super.initState();
  }

  updateUser() async {
    setState(() {
      isLoading = true;
    });

    print('location;;;' + location.text);
    print('username;;;;' + username.text);
    print('phone///' + phone.text);
    print('subject' + subject.text);
    print('' + degree.text);

    await db.collection("Users").doc(userData.userId).update({
      "location": location.text.length > 0 ? location.text : userData.location,
      "username": username.text.length > 0 ? username.text : userData.username,
      "phone": phone.text.length > 0 ? phone.text : userData.phone,
      "majorSubjects":
          subject.text.length > 0 ? subject.text : userData.majorSubjects,
      "degree": degree.text.length > 0 ? degree.text : userData.degree,
    });
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);

    getMyData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                });
              },
              icon: Icon(Icons.logout)),
        ],
        title: Text(
          userData.username + ': ملف الطالب',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.accents[6].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ListView(
                                shrinkWrap: true,
                                padding:
                                    EdgeInsets.only(left: 12.0, right: 12.0),
                                children: [
                                  Center(
                                    child: Text(
                                      'تعديل حسابك',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'cb',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      controller: username,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText: userData.username +
                                            ': اسم المستخدم',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      controller: location,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintText:
                                            userData.location + ': الموقع ',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      controller: phone,
                                      decoration: InputDecoration(
                                        hintText: userData.phone + ':الهاتف ',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            )),
                        Divider(),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () {
                                updateUser();
                              },
                              child: Text('تحديث'),
                            )
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      )),
    );
  }
}
