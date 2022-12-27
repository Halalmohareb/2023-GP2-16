import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/myAppointments.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/globalWidgets/sizedBoxWidget/sized_box_widget.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/home_page.dart';
import 'package:Dhyaa/theme/tutorTopBarNavigator.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({Key? key}) : super(key: key);

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  int count = 0;
  UserData userData = emptyUserData;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TutorTopBarNavigator(),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kSearchBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/teach.gif',
                            width: 150,
                          ),
                          Expanded(
                            child: Text(
                              'مرحبا معلم ' + userData.username,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomePage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 160,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.accents[6].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'assets/images/available_time.png',
                                  height: 60,
                                  fit: BoxFit.fitHeight,
                                ),
                                Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'أوقاتك المتاحة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                            height: 160,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.accents[6].withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'assets/images/booked_lessons.png',
                                  height: 60,
                                ),
                                Center(
                                  child: Text(
                                    'الدروس المحجوزة',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'تحتاج الى مساعدة ؟',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    sizedBox(
                      height: 5.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.accents[6].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 200,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'تحدث الى الدعم',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.headset_mic_outlined)
                        ],
                      ),
                    ),
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
