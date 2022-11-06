import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/menu.dart';

class TutorTopBarNavigator extends StatefulWidget {
  const TutorTopBarNavigator({super.key});

  @override
  State<TutorTopBarNavigator> createState() => _TutorTopBarNavigatorState();
}

class _TutorTopBarNavigatorState extends State<TutorTopBarNavigator> {
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
                // New Code Start
                Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                        builder: (context) => Menu(userData: userData),
                        maintainState: false));
                // New Code End
                // old code
                // await FirebaseAuth.instance.signOut().then((value) {
                //   Navigator.of(context, rootNavigator: false).push(
                //     MaterialPageRoute(
                //         builder: (context) => TutorProfileScreen(),
                //         maintainState: false),
                //   );
                // });
              },
              icon: SvgPicture.asset('assets/icons/profile.svg'),
            ),
            Image.asset(
              'assets/icons/DhyaaLogo.png',
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
