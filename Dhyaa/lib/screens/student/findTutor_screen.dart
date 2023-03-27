import 'dart:convert';
import 'package:Dhyaa/_helper/subject.dart';
import 'package:Dhyaa/screens/student/filter_options.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:Dhyaa/theme/topAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/student/tutor_card.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../singlton.dart';

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
  dynamic filterData = null;

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
    FirebaseMessaging.instance.getInitialMessage();
    storeNotificationsToken();
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

  storeNotificationsToken() async{

    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('Users').doc(Singleton.instance.userId!).collection('token').doc(Singleton.instance.userId).set({
      "token": token,
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
                  TopAppBar(isHome: true),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(15),
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xFF2d99cd),
                              Color(0xFF94c6e7),
                              Color(0xFF2d99cd),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ابدأ التعلم \nمع ضياء",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'cb',
                                    color: kWhiteColor,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/reading-book.png',
                                  height: 60,
                                )
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 110,
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
                                              oldData: filterData,
                                              tutorList: foundUsers,
                                              onChange: (val) {
                                                filterData = val['filterData'];
                                                filterTutors = val['list'];
                                                searchTutorList = val['list'];
                                                if (mounted) setState(() {});
                                                doSearch();
                                              },
                                              onReset: (value) {
                                                filterTutors = foundUsers;
                                                searchTutorList = foundUsers;
                                                filterData = null;
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
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      if (filterData != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.fillColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    (filterData['priceRange'].start)
                                            .toString() +
                                        '-' +
                                        (filterData['priceRange'].end)
                                            .toString(),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.fillColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      Text(filterData['location'].toString()),
                                ),
                                if (filterData['isOnlineLesson'])
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('أون لاين'),
                                  ),
                                if (filterData['isStudentHomeLesson'])
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('حضوري (مكان الطالب)'),
                                  ),
                                if (filterData['isTutorHomeLesson'])
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('حضوري (مكان المعلم)'),
                                  ),
                                if (filterData['star1'])
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width:
                                        MediaQuery.of(context).size.width / 5 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.star_rounded, size: 18),
                                        Text('1'),
                                      ],
                                    ),
                                  ),
                                if (filterData['star2'])
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width:
                                        MediaQuery.of(context).size.width / 5 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.star_rounded, size: 18),
                                        Text('2'),
                                      ],
                                    ),
                                  ),
                                if (filterData['star3'])
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width:
                                        MediaQuery.of(context).size.width / 5 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.star_rounded, size: 18),
                                        Text('3'),
                                      ],
                                    ),
                                  ),
                                if (filterData['star4'])
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width:
                                        MediaQuery.of(context).size.width / 5 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.star_rounded, size: 18),
                                        Text('4'),
                                      ],
                                    ),
                                  ),
                                if (filterData['star5'])
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width:
                                        MediaQuery.of(context).size.width / 5 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: theme.fillColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.star_rounded, size: 18),
                                        Text('5'),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              'تم العثور على المعلمين ضياء' + ': ',
                              style: TextStyle(
                                fontFamily: 'cb',
                                color: kTitleTextColor,
                              ),
                            ),
                            Text(
                              searchTutorList.length.toString(),
                              style: TextStyle(
                                fontFamily: 'cb',
                                color: theme.mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
