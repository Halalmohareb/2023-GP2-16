import 'package:Dhyaa/screens/contactPage.dart';
import 'package:Dhyaa/screens/policy.dart';
import 'package:Dhyaa/screens/student/showTutorProfilePage.dart';
import 'package:Dhyaa/screens/student/student_showprofile.dart';
import 'package:Dhyaa/screens/tutor/tutor_frofile.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/signinMethodScreen/signin_method_screen.dart';
import 'package:Dhyaa/screens/student/studentProfile_screen.dart';
import 'package:Dhyaa/screens/update_profile.dart';

import '../constant.dart';

class Menu extends StatefulWidget {
  final UserData userData;
  const Menu({Key? key, required this.userData}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Variables
  UserData userData = emptyUserData;

  // Functions
  @override
  void initState() {
    userData = widget.userData;
    getUserData();
    // user();
    super.initState();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      if (mounted) setState(() {});
    });
  }

  showCancelAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(20),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 70,
            ),
            SizedBox(height: 10),
            Text('هل انت متأكد من الخروج ؟'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    side: BorderSide(color: kBlueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('لا، تراجع'),
                ),
                TextButton(
                  onPressed: () async {
                    doCancel();
                    Navigator.of(context, rootNavigator: true).pop();

                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    side: BorderSide(color: kBlueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('نعم، خروج'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  doCancel() async {
    SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.clear();
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context, rootNavigator: true)
          .pushReplacement(
        MaterialPageRoute(
          builder: (context) => new SignInMethod(),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: theme.bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: userData.avatar,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  userData.username,
                  style: TextStyle(fontSize: 20, fontFamily: 'cb'),
                ),
              ),
              Center(child: Text(userData.email)),
              SizedBox(height: 50),
              ListTile(
                shape: Border(),
                title: Text('استعراض صفحتي الشخصية'),
                leading: Icon(Icons.person),
                onTap: () {
                  if (userData.type == "Student") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => StudentShowProfile(
                          userData: userData,
                        ),
                      ),
                    );
                  } else if (userData.type == "Tutor") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => tutorFrofile(
                          userData: userData,
                          myUserId: userData.userId,
                        ),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                shape: Border(),
                title: Text('تحديث بياناتي'),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UpdateProfile(userData: userData),
                    ),
                  ).then((value) {
                    if (value != null) {
                      userData = value;
                      if (mounted) setState(() {});
                    }
                  });
                },
              ),
              ListTile(
                shape: Border(),
                title: Text('سياسة ضياء'),
                leading: Icon(Icons.payment),
                 onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          policy(),
                    ),
                  );
                },
              ),
              ListTile(
                shape: Border(),
                title: Text('تواصل معنا'),
                leading: Icon(Icons.call),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          contactPage(emil: userData.email),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    showCancelAlert(context);
                    // SharedPreferences preferences =
                    //     await SharedPreferences.getInstance();
                    // await preferences.clear();
                    // await FirebaseAuth.instance.signOut().then((value) {
                    //   Navigator.of(context, rootNavigator: true)
                    //       .pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (context) => new SignInMethod(),
                    //     ),
                    //   );
                    // });
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.redColor,
                    ),
                    child: Center(
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontFamily: 'cb',
                          color: theme.fillColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
