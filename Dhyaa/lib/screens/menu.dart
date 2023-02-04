import 'package:Dhyaa/screens/contactPage.dart';
import 'package:Dhyaa/screens/student/showTutorProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/signinMethodScreen/signin_method_screen.dart';
import 'package:Dhyaa/screens/student/studentProfile_screen.dart';
import 'package:Dhyaa/screens/update_profile.dart';

import '../singlton.dart';

class Menu extends StatefulWidget {
  final UserData userData;
  const Menu({Key? key, required this.userData}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Variables
  UserData userData = emptyUserData;
  String email = "";

  // Functions
  @override
  void initState() {
    userData = widget.userData;
    getUserData();
    user();
    super.initState();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      print(' @@@@@@@@@@@@ user email @@@@@@@@@@@@');
      print(userData.email);
      if (mounted) setState(() {});
    });
  }

  user() async {
    var document = await FirebaseFirestore.instance.collection('Users')
        .doc((Singleton.instance.userId));
    document.get().then((document) {
      print("hiiiiiiiiiiiiiiiiii");
      //print(document.data()!['numberOfRead']);
      email = document.data()!['email'];
      print(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/icons/DhyaaLogo.png',
                  height: 120,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  userData.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(userData.email),
              ),
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
                        builder: (BuildContext context) => StudentProfileScreen(
                          userData: userData,
                        ),
                      ),
                    );
                  } else if (userData.type == "Tutor") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowTutorProfilePage(
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
                title: Text('سياسة الدفع'),
                leading: Icon(Icons.payment),
                onTap: () {},
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
                          contactPage(emil:email),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () async {
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
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.red.shade300,
                    ),
                    child: Center(
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffF2F2F2),
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
