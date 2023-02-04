import 'dart:convert';
import 'package:Dhyaa/_helper/subject.dart';
import 'package:Dhyaa/screens/student/filter_options.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/student/tutor_card.dart';
import 'package:Dhyaa/theme/studentTopBarNavigator.dart';
import 'package:textfield_search/textfield_search.dart';

class FindTutorScreen extends StatefulWidget {
  const FindTutorScreen({Key? key}) : super(key: key);

  @override
  State<FindTutorScreen> createState() => _FindTutorScreenState();
}

class _FindTutorScreenState extends State<FindTutorScreen> {
  int count = 0;
  UserData userData = emptyUserData;
  TextEditingController searchTextController = new TextEditingController();
  List<UserData> tutors = [];
  List<UserData> foundUsers = [];
  List<UserData> filterTutors = [];
  List<UserData> searchTutorList = [];

  @override
  void initState() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      FirestoreHelper.getTopTutors().then((value) {
        tutors = value;
        foundUsers = value;
        filterTutors = value;
        searchTutorList = value;
        if (mounted) setState(() {});
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

  doSearch() {
    FocusScope.of(context).unfocus();
    if (searchTextController.text.isEmpty) {
      searchTutorList = filterTutors;
    } else {
      List<UserData> temp = [];
      for (var item in filterTutors) {
        List arr = jsonDecode(item.degree);
        if (arr.contains(searchTextController.text)) {
          temp.add(item);
        }
      }
      searchTutorList = temp;
    }
    if (mounted) setState(() {});
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
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
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
                              GestureDetector(
                                onTap: () => doSearch(),
                                child: Container(
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
                              ),
                              Expanded(
                                child: TextFieldSearch(
                                  initialList: subjects,
                                  label: "",
                                  controller: searchTextController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'ابحث عن مادة...',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 5,
                                    ),
                                    hintTextDirection: TextDirection.rtl,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FilterOptions(
                                              tutorList: foundUsers,
                                              onChange: (val) {
                                                filterTutors = val;
                                                searchTutorList = val;
                                                if (mounted) setState(() {});
                                                doSearch();
                                              },
                                              onRest: (value) {
                                                filterTutors = foundUsers;
                                                searchTutorList = foundUsers;
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
                            ],
                          ),
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
                      searchTutorList.length == 0
                          ? Center(
                              child: Container(
                                height: 270,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/cant-find.png',
                                      height: 150,
                                    ),
                                    Spacer(),
                                    Text(
                                      'لم يتم العثور على معلمين!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'حاول البحث بكلمات مختلفة أو إزالة خيارات تصفية البحث',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: searchTutorList.length,
                              itemBuilder: (context, index) {
                                return TutorCardWidget(
                                  tutor: searchTutorList[index],
                                  myUserId: userData.userId,
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
