import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/screens/student/findTutor_screen.dart';

import '../../constant.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({Key? key}) : super(key: key);

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  int count = 0;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int _currentIndex = 1;
  final List _children = [
    Center(child: Icon(Icons.mail, size: 40)),
    FindTutorScreen(),
    Center(child: Icon(Icons.list, size: 40)),
  ];

  void onTabTapped(int index) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    _currentIndex = index;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _children[_currentIndex],
        pageRoute: PageRoutes.materialPageRoute,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: '',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          new BottomNavigationBarItem(icon: Icon(Icons.list), label: '')
        ],
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
