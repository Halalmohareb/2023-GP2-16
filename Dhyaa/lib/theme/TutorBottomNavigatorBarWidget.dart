import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/samplePage.dart';
import 'package:Dhyaa/screens/tutor/tutorProfile_screen.dart';
import 'package:Dhyaa/screens/tutor/upcomingLessons_screen.dart';

class TutorBottomNavigatorBarWidget extends StatefulWidget {
  const TutorBottomNavigatorBarWidget({super.key});

  @override
  State<TutorBottomNavigatorBarWidget> createState() =>
      _TutorBottomNavigatorBarWidgetState();
}

class _TutorBottomNavigatorBarWidgetState
    extends State<TutorBottomNavigatorBarWidget> {
  int _currentIndex = 1;

  final List _children = [
    PlaceholderWidget(Colors.white),
    upcomingLessonsScreen(),
    TutorProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kOrangeColor,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
      ),
      body: _children[_currentIndex],
    );
  }
}
