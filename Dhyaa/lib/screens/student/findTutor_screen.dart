import 'dart:convert';
import 'package:Dhyaa/_helper/subject.dart';
import 'package:Dhyaa/screens/student/filter_options.dart';
import 'package:Dhyaa/theme/theme.dart';
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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StudentTopBarNavigator(),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 50,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: kFillColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                  prefixIcon: IconButton(
                                    onPressed: () => doSearch(),
                                    icon: SvgPicture.asset(
                                      'assets/icons/search.svg',
                                      color: theme.darkTextColor,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => doSearch(),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: kFillColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
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
                                    color: theme.darkTextColor,
                                    width: 23,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'تم العثور على معلمين ضياء' + ': ',
                              style: TextStyle(
                                fontFamily: 'cb',
                                fontSize: 16,
                                color: kTitleTextColor,
                              ),
                            ),
                            Text(
                              searchTutorList.length.toString(),
                              style: TextStyle(
                                fontFamily: 'cb',
                                fontSize: 16,
                                color: theme.mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                     
                      Divider(),
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
                                        fontFamily: 'cb',
                                      ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
