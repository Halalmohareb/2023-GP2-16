import 'package:Dhyaa/screens/student/filter_options.dart';
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
  List<UserData> tutorList = [];

  @override
  void initState() {
    setState(() {
      tutors.add(emptyTutor);
    });
    FirestoreHelper.getTopTutors().then((value) {
      tutors = value;
      foundUsers = value;
      tutorList = foundUsers;
      if (mounted) setState(() {});
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
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: kBlueColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchTextController,
                                onChanged: (value) => _runFilter(value),
                                textDirection: TextDirection.rtl,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: 'ابحث عن مادة...',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FilterOptions(
                                            tutorList: foundUsers,
                                            onChange: (val) {
                                              tutorList = val;
                                              if (mounted) setState(() {});
                                            },
                                            onRest: (value) {
                                              tutorList = foundUsers;
                                              if (mounted) setState(() {});
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Image.asset(
                                      'assets/images/setting.png',
                                      width: 25,
                                    ),
                                  ),
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
                      SizedBox(height: 10),
                      Text(
                        'معلمين ضياء',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: kTitleTextColor,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: kBlueColor,
                      ),
                      SizedBox(height: 10),
                      tutorList.length == 0
                          ? Center(
                              child: Container(
                                height: 270,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/doctor1.png',
                                      height: 150,
                                    ),
                                    Spacer(),
                                    Text(
                                      'لم يتم العثور على مدرسين!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'حاول كلمات مختلفة أو إزالة عوامل تصفية البحث',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tutorList.length,
                              itemBuilder: (context, index) {
                                return TutorCardWidget(
                                  tutor: tutorList[index],
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
