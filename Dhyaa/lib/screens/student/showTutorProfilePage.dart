import 'dart:convert';
import 'dart:math';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/models/review.dart';
import 'package:Dhyaa/responsiveBloc/size_config.dart';
import 'package:Dhyaa/screens/reviews_component.dart';
import 'package:Dhyaa/screens/student/bookAppointment.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../chat_screen.dart';

class ShowTutorProfilePage extends StatefulWidget {
  final UserData userData;
  final String myUserId;
  const ShowTutorProfilePage({
    Key? key,
    required this.userData,
    required this.myUserId,
  });
  @override
  State<ShowTutorProfilePage> createState() => _ShowTutorProfilePageState();
}

class _ShowTutorProfilePageState extends State<ShowTutorProfilePage> {
  UserData userData = emptyUserData;
  UserData myUserData = emptyUserData;
  List<Task> tasks = [];
  List availability = [];
  List<Review> allReviews = [];
  int tabIndex = 0;

  @override
  void initState() {
    userData = widget.userData;
    getAllReviews();
    getRecommendedTutors();
    getAvailability();
    FirestoreHelper.getMyUserData().then((value) {
      myUserData = value;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  getAvailability() {
    FirestoreHelper.getTutorTasks(userData).then((value) async {
      for (var task in value) {
        var s = task.day.split('-');
        DateTime d =
            DateTime(int.parse(s[0]), int.parse(s[1]), int.parse(s[2]));
        bool isAfter = d.isAfter(DateTime.now());
        if (isAfter) tasks.add(task);
      }
      tasks.sort((Task a, Task b) => a.day.compareTo(b.day));
      if (mounted) setState(() {});
      // Availability checker
      availabilityChecker();
      // Availability checker end
    });
  }

  getAllReviews() {
    FirestoreHelper.getAllReview(userData.userId).then((value) {
      allReviews = value;
      if (mounted) setState(() {});
    });
  }

  Widget degreePipe() {
    dynamic val = userData.degree;
    List temp = [val];

    if (val != '' && val != null) {
      if (val[0] == '[' && val[val.length - 1] == ']') {
        temp = [];
        List arr = jsonDecode(val);
        for (var element in arr) {
          temp.add(element);
        }
      }
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Wrap(
        children: List.generate(temp.length, (index) {
          var item = temp[index];
          return Container(
            height: 25,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15),
                backgroundColor: theme.fillLightColor,
                side: BorderSide(color: kBlueColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(item),
            ),
          );
        }),
      ),
    );
  }

  lessonTypePipe2() {
    String temp = '';
    if (userData.isOnlineLesson) {
      temp += 'أون لاين' + ' | ';
    }
    if (userData.isStudentHomeLesson) {
      temp += 'حضوري (مكان الطالب)' + ' | ';
    }
    if (userData.isTutorHomeLesson) {
      temp += 'حضوري (مكان المعلم)';
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = SizeConfig.widthMultiplier;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            margin: EdgeInsets.only(right: 20),
            child: Image.asset('assets/icons/DhyaaLogo.png', height: 40),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(color: Colors.grey, thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: userData.avatar,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kBlueColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: getMinPrice(userData),
                                  style: TextStyle(
                                    fontFamily: 'cb',
                                  ),
                                ),
                                TextSpan(
                                  text: ' ريال/ساعة',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userData.username,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'cb',
                          ),
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating:
                                  double.parse(userData.averageRating),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: EdgeInsets.all(0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rate_rounded,
                                color: kBlueColor,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(width: 5),
                            Text(
                              userData.averageRating,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'cb',
                                color: kBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16),
                        SizedBox(width: 5),
                        Text(
                          userData.location + ', ' + userData.address,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.broadcast_on_personal_outlined, size: 16),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(lessonTypePipe2()),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'التخصص: ',
                            style: TextStyle(fontFamily: 'cb'),
                          ),
                          TextSpan(text: userData.majorSubjects),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              degreePipe(),
              SizedBox(height: 5),
              Container(
                height: tabHight(),
                width: MediaQuery.of(context).size.width,
                child: DefaultTabController(
                  initialIndex: 0,
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: kBlueColor,
                        onTap: (value) {
                          tabIndex = value;
                          if (mounted) setState(() {});
                        },
                        tabs: <Widget>[
                          Tab(
                            text: 'نبذه عني',
                          ),
                          Tab(
                            text: 'التوفر',
                          ),
                          Tab(
                            text: 'التقييم',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                userData.bio == ''
                                    ? 'غير متوفرة'
                                    : userData.bio,
                              ),
                            ),
                            showAvailability(),
                            ReviewsComponent(allReviews: allReviews),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (recommendationCount > 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'معلمين اخرين',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'cb',
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: recommendedWidget,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(screenWidth * 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointment(
                          userData: userData, myUserData: myUserData),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2.3,
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                      .copyWith(bottom: screenWidth),
                  padding: EdgeInsets.all(screenWidth * 2.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.blueColor),
                  child: text(
                    'احجز موعدًا',
                    screenWidth * 3.4,
                    theme.whiteColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          friendId: userData.userId,
                          friendName: userData.username),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2.3,
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                      .copyWith(bottom: 0),
                  padding: EdgeInsets.all(screenWidth * 2.5),
                  decoration: BoxDecoration(
                    color: theme.fillColor,
                    border: Border.all(color: theme.mainColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: text(
                    "تواصل مع المعلم",
                    screenWidth * 3.4,
                    theme.mainColor,
                  ),
                ),
              ),
            ],
          ),
          height: 80),
    );
  }

  degreeTextPipe(var val) {
    var temp = val;
    if (val != '' && val != null) {
      if (val[0] == '[' && val[val.length - 1] == ']') {
        temp = '';
        List arr = jsonDecode(val);
        int i = 0;
        for (var item in arr) {
          temp += item;
          if (i != arr.length - 1) {
            temp += ' | ';
          }
          i++;
        }
      }
    }
    return temp;
  }

  lessonTypePipe(UserData tutor) {
    String temp = '';
    if (tutor.isOnlineLesson) {
      temp += 'أون لاين' + ' | ';
    }
    if (tutor.isStudentHomeLesson) {
      temp += 'حضوري (مكان الطالب)' + ' | ';
    }
    if (tutor.isTutorHomeLesson) {
      temp += 'حضوري (مكان المعلم)';
    }
    return temp;
  }

  String getMinPrice(UserData tutor) {
    var priceList = [
      int.parse(tutor.onlineLessonPrice == '' ? '0' : tutor.onlineLessonPrice),
      int.parse(tutor.studentsHomeLessonPrice == ''
          ? '0'
          : tutor.studentsHomeLessonPrice),
      int.parse(
          tutor.tutorsHomeLessonPrice == '' ? '0' : tutor.tutorsHomeLessonPrice)
    ];
    priceList.removeWhere((element) => element == 0);
    return priceList.length > 0 ? priceList.reduce(min).toString() : '-';
  }

  Widget recommendedWidget = Container();
  int recommendationCount = 0;

  getRecommendedTutors() {
    FirestoreHelper.getRecommendedTutors(userData).then((tutors) {
      recommendationCount = tutors.length;
      if (mounted) setState(() {});
      recommendedWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(tutors.length, (index) {
            UserData _tutor = tutors[index];
            return Container(
              height: 320,
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: MediaQuery.of(context).size.width / 1.5,
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowTutorProfilePage(
                              userData: _tutor,
                              myUserId: widget.myUserId,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                        height: 270,
                        decoration: BoxDecoration(
                          color: theme.bgColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.darkTextColor.withOpacity(0.3),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              _tutor.username,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: kTitleTextColor,
                                fontFamily: 'cb',
                              ),
                            ),
                            RatingBar.builder(
                              initialRating: double.parse(_tutor.averageRating),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemSize: 15,
                              itemPadding: EdgeInsets.all(0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rate_rounded,
                                color: kBlueColor,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            SizedBox(height: 5),
                            Wrap(
                              children: [
                                Icon(Icons.location_on, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  _tutor.location + ', ' + _tutor.address,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                Icon(Icons.broadcast_on_personal, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  lessonTypePipe(_tutor),
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Text(
                              'المادة: ' + degreeTextPipe(_tutor.degree),
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              'السعر يبدأ من:  ' +
                                  getMinPrice(_tutor) +
                                  ' ' +
                                  'ريال/ساعة',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowTutorProfilePage(
                              userData: _tutor,
                              myUserId: widget.myUserId,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: _tutor.avatar,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
      if (mounted) setState(() {});
    });
  }

  isAppointmentExist(timeObj, date, tutorId, index) {
    FirestoreHelper.isAppointmentExist(timeObj, date, tutorId)
        .then((isAvailableForAppointment) {
      if (!isAvailableForAppointment) {
        availability[index]['counter']--;
        if (availability[index]['counter'] < 1) {
          availability.removeAt(index);
        }
        if (mounted) setState(() {});
      }
    });
  }

  availabilityChecker() {
    for (var i = 0; i < tasks.length; i++) {
      var task = tasks[i];
      int s = int.parse(task.startTime.split(':')[0]);
      int e = int.parse(task.endTime.split(':')[0]);
      int counter = e - s;
      availability.insert(i, {"availability": task, "counter": counter});
      if (mounted) setState(() {});
      for (var j = 0; j < counter.abs(); j++) {
        var d = task.day.split('-');
        if (int.parse(d[0]) == DateTime.now().year &&
            int.parse(d[1]) == DateTime.now().month &&
            int.parse(d[2]) == DateTime.now().day) {
          if (((s + j) + 1) > DateTime.now().hour) {
            isAppointmentExist(
              {
                'start': (s + j).toString() + ':00',
                'end': ((s + j) + 1).toString() + ':00'
              },
              task.day,
              userData.userId,
              i,
            );
          }
        } else {
          isAppointmentExist(
            {
              'start': (s + j).toString() + ':00',
              'end': ((s + j) + 1).toString() + ':00'
            },
            task.day,
            userData.userId,
            i,
          );
        }
      }
    }
  }

  showAvailability() {
    var widget = Container();
    widget = Container(
      height: 55,
      margin: EdgeInsets.all(10),
      child: availability.length == 0
          ? Align(
              alignment: Alignment.topRight,
              child: Text('المعلم غير متوفر لتحديد موعد'),
            )
          : Wrap(
              spacing: 10.0,
              children: List.generate(availability.length, (index) {
                return Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width / 3 - 15,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: kBlueColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        availability[index]['availability'].day.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'cb',
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        availability[index]['availability'].startTime +
                            ' - ' +
                            availability[index]['availability'].endTime,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'cb',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
    return widget;
  }

  tabHight() {
    double h = 0;
    if (tabIndex == 0) {
      h = 50.0 + (25.0 * getNumberOfLines(userData.bio, context));
    }
    if (tabIndex == 1) {
      h = availability.length > 3 ? (availability.length / 2) * 100 : 120;
    }
    if (tabIndex == 2) {
      h = 200;
    }
    return h;
  }

  int getNumberOfLines(String text, BuildContext context) {
    final textSpan = TextSpan(
      text: text,
      style: DefaultTextStyle.of(context).style,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    final lines = textPainter.computeLineMetrics();
    return lines.length;
  }
}
