import 'package:Dhyaa/screens/myAppointments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/screens/student/findTutor_screen.dart';

import '../../constant.dart';
import '../../singlton.dart';
import '../badge_icon.dart';
import '../chat_page.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({Key? key}) : super(key: key);

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int tabIndex = 1;
  final List _children = [
    ChatPage(),
    FindTutorScreen(),
    MyAppointmentPage(),
  ];

  void onTabTapped(int index) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    tabIndex = index;
    if (mounted) setState(() {});
  }
  int num=0;

  Future <dynamic> getusertoken() async {
    FirebaseFirestore.instance.collection('Users').doc(
        Singleton.instance.userId).collection('message').orderBy("datemsg",descending: false) .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
            (event) =>  num =  doc.data()["numberOfRead"];
      }
      print(num);
    });
  }

  @override
  Widget build(BuildContext context) {

    getusertoken();
    print(num);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _children[tabIndex],
        pageRoute: PageRoutes.materialPageRoute,
      ),
      bottomNavigationBar:StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance.collection('Users').doc(
            Singleton.instance.userId).collection('message').orderBy("datemsg",descending: true).limit(1).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.data!.docs.length < 1) {
      return  BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: BadgeIcon(
              icon: Icon(Icons.chat, size: 25),
              badgeCount:0,
            ),
            label: 'محادثة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: 'دروسك',
          ),
        ],
        currentIndex: tabIndex,
        onTap: onTabTapped,
      );
    }
          return  ListView(
    shrinkWrap: true,
    children:
    snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          return  BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: BadgeIcon(
                  icon: Icon(Icons.chat, size: 25),
                  badgeCount: data['numberOfRead'],
                ),
                label: 'محادثة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month_rounded,
                ),
                label: 'دروسك',
              ),
            ],
            currentIndex: tabIndex,
            onTap: onTabTapped,
          );
    }).toList(),
    );
        })
    );
  }
}
