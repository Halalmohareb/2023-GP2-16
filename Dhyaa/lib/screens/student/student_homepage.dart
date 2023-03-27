import 'package:Dhyaa/screens/myAppointments.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/screens/student/findTutor_screen.dart';

import '../../constant.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _children[tabIndex],
        pageRoute: PageRoutes.materialPageRoute,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
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
      ),
    );
  }
}
