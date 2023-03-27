import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/contactPage.dart';
import 'package:Dhyaa/screens/myAppointments.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:Dhyaa/theme/topAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/singlton.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/home_page.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({Key? key}) : super(key: key);

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  UserData userData = emptyUserData;

  @override
  void initState() {
    getUserData();
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    storeNotificationsToken();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      if (mounted) setState(() {});
    });
  }

  storeNotificationsToken() async{

    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('Users').doc(Singleton.instance.userId!).collection('token').doc(Singleton.instance.userId).set({
      "token": token,
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig.widthMultiplier;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TopAppBar(isHome: true),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/teach.gif',
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    SizedBox(height: 80),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                            .copyWith(bottom: screenWidth),
                        padding: EdgeInsets.all(screenWidth * 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.blueColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/available_time.png',
                              height: 20,
                              color: kWhiteColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              textAlign: TextAlign.center,
                              'أوقاتك المتاحة',
                              style: TextStyle(
                                fontFamily: 'cb',
                                color: kWhiteColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: false).push(
                          MaterialPageRoute(
                            builder: (context) => MyAppointmentPage(),
                            maintainState: false,
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                            .copyWith(bottom: screenWidth),
                        padding: EdgeInsets.all(screenWidth * 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF94c6e7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/booked_lessons.png',
                              height: 20,
                              color: kWhiteColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              textAlign: TextAlign.center,
                              'الدروس المحجوزة',
                              style: TextStyle(
                                fontFamily: 'cb',
                                color: kWhiteColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                contactPage(emil: userData.email),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                            .copyWith(bottom: screenWidth),
                        padding: EdgeInsets.all(screenWidth * 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFd2e7f5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.headset_mic_outlined,
                            ),
                            SizedBox(width: 10),
                            Text(
                              textAlign: TextAlign.center,
                              'تحدث الى الدعم',
                              style: TextStyle(fontFamily: 'cb'),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
