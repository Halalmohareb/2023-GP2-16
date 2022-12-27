import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/student/tutor_card.dart';
import 'package:Dhyaa/theme/studentTopBarNavigator.dart';

class FindTutorScreen extends StatefulWidget {
  const FindTutorScreen({Key? key}) : super(key: key);

  @override
  State<FindTutorScreen> createState() => _FindTutorScreenState();
}

class _FindTutorScreenState extends State<FindTutorScreen> {
  int count = 0;
  TextEditingController searchTextController = new TextEditingController();
  UserData emptyTutor = emptyUserData;
  List<UserData> tutors = [];
  List<UserData> foundUsers = [];

  @override
  void initState() {
    setState(() {
      tutors.add(emptyTutor);
    });
    FirestoreHelper.getTopTutors().then((value) {
      setState(() {
        tutors = value;
        foundUsers = value;
      });
    });
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<UserData> results = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        results = tutors;
      });
    } else {
      results = tutors.where((user) {
        return user.degree.toLowerCase().contains(enteredKeyword.toLowerCase());
      }).toList();
    }
    setState(() {
      foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StudentTopBarNavigator(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        padding: EdgeInsets.only(
                          left: 40,
                        ),
                        decoration: BoxDecoration(
                          color: kBlueColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) => _runFilter(value),
                                controller: searchTextController,
                                // textDirection: TextDirection.rtl,
                                decoration: InputDecoration.collapsed(
                                  hintText: '... ابحث عن مادة',
                                  // hintTextDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                color: kYellowColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/search.svg',
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'معلمين ضياء',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: kTitleTextColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: kBlueColor,
                      ),
                      SizedBox(height: 20),
                      StreamBuilder(
                        builder: (context, snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: foundUsers.length,
                            itemBuilder: (context, index) {
                              return TutorCardWidget(
                                tutor: foundUsers[index],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
