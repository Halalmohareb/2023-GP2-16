import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/menu.dart';

class StudentTopBarNavigator extends StatefulWidget {
  const StudentTopBarNavigator({super.key});

  @override
  State<StudentTopBarNavigator> createState() => _StudentTopBarNavigatorState();
}

class _StudentTopBarNavigatorState extends State<StudentTopBarNavigator> {
  UserData userData = emptyUserData;
  // Functions
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
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                      builder: (context) => Menu(
                            userData: userData,
                          ),
                      maintainState: false),
                );
              },
              icon: SvgPicture.asset('assets/icons/profile.svg'),
            ),
            Image.asset('assets/icons/DhyaaLogo.png', height: 40),
          ],
        ),
      ),
    );
  }
}
