import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/screens/tutor/tutor_home_screen.dart';

class TutorHomepage extends StatefulWidget {
  const TutorHomepage({Key? key}) : super(key: key);

  @override
  State<TutorHomepage> createState() => _TutorHomepageState();
}

class _TutorHomepageState extends State<TutorHomepage> {
  int _currentIndex = 1;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List _children = [
    Center(child: Icon(Icons.mail, size: 40)),
    TutorHomeScreen(),
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
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _children[_currentIndex],
        pageRoute: PageRoutes.materialPageRoute,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
