import 'dart:async';

import 'package:Dhyaa/_helper/loading.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/globalWidgets/toast.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/appointment.dart';
import 'package:Dhyaa/models/review.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/chat_screen.dart';
import 'package:Dhyaa/screens/student/showTutorProfilePage.dart';
import 'package:Dhyaa/screens/student/studentProfile_screen.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/theme/studentTopBarNavigator.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart' as intl;
import '../responsiveBloc/size_config.dart';

List<Appointment> allAppointments = [];

class MyAppointmentPage extends StatefulWidget {
  const MyAppointmentPage({super.key});

  @override
  State<MyAppointmentPage> createState() => _MyAppointmentPageState();
}

class _MyAppointmentPageState extends State<MyAppointmentPage> {
  // Variables
  UserData userData = emptyUserData;
  var screenWidth = SizeConfig.widthMultiplier;
  bool upcomingTab = true;

  // Functions
  @override
  void initState() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      if (mounted) setState(() {});
      loadData();
    });
    super.initState();
  }

  loadData() {
    if (upcomingTab) {
      FirestoreHelper.getUpcomingAppointmentList(
        userData.type == 'Student' ? 'studentId' : 'tutorId',
        userData.userId,
      ).then((value) {
        allAppointments = value;
        if (mounted) setState(() {});
      });
    } else {
      FirestoreHelper.getPreviousAppointmentList(
        userData.type == 'Student' ? 'studentId' : 'tutorId',
        userData.userId,
      ).then((value) {
        allAppointments = value;
        if (mounted) setState(() {});
      });
    }
  }

  timePipe(List time) {
    time.sort((a, b) => a['start'].compareTo(b['start']));
    String t = '';
    for (var element in time) {
      t += (element['start'] + '-' + element['end']) + ' | ';
    }

    return t;
  }

  lessonTypePipe(type) {
    String temp = '';

    if (type == 'online') {
      temp += 'أون لاين' + ' ';
    }
    if (type == 'studentSide') {
      temp += 'حضوري (مكان الطالب)' + ' ';
    }
    if (type == 'tutorSide') {
      temp += 'حضوري (مكان المعلم)';
    }
    return temp;
  }

  showCancelAlert(BuildContext context, index) {
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
            Text('هل انت متأكد من إلغاء موعدك  ؟'),
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
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    doCancel(index);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    side: BorderSide(color: kBlueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('نعم، إلغاء'),
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

  doCancel(index) {
    FirestoreHelper.changeAppointmentStatus(allAppointments[index].id, 'ملغي')
        .then((value) => loadData());
  }

  showCompleteAlert(BuildContext context, index) {
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
              Icons.check_circle_outline,
              color: Colors.green[700],
              size: 70,
            ),
            SizedBox(height: 10),
            Text('رائع ! انتهى الدرس؟ لا تنسى تقييم تجربتك'),
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
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    doComplete(index);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    side: BorderSide(color: kBlueColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('نعم، انتهى'),
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

  doComplete(index) {
    FirestoreHelper.changeAppointmentStatus(allAppointments[index].id, 'انتهى')
        .then((value) => loadData());
  }

  // =====================================
  // ============== Reviews ==============
  // =====================================

  showLeaveReviewAlert(BuildContext context, index) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(20),
      content: ReviewComponent(
        index: index,
        userData: userData,
        onReview: (value) {
          if (value == 'Student') {
            allAppointments[index].isStudentLeavedReview = true;
          } else {
            allAppointments[index].isTutorLeavedReview = true;
          }
          if (mounted) setState(() {});
        },
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

  checkForPassed(Appointment item, int index) {
    item.time.sort((a, b) => a['start'].compareTo(b['start']));
    List d = item.date.split('-');
    DateTime _d = DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]));
    bool isPassed = _d.isBefore(DateTime.now().add(Duration(days: 1)));
    if (isPassed) {
      List t = item.time.last['end'].split(':');
      if (int.parse(t.first) <= DateTime.now().hour) {
        doComplete(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffF9F9F9),
        toolbarHeight: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    Navigator.canPop(context)
                        ? Container(
                            width: 30,
                            child: IconButton(
                              padding: EdgeInsets.only(left: 15, right: 0),
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(child: StudentTopBarNavigator()),
                  ],
                ),
              ),
              Divider(color: Colors.black, thickness: 1),
              Center(
                child: Text(
                  'مواعيد دروسك',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'cb',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: screenWidth * 8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(bottom: screenWidth * 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.mainColor),
                    borderRadius: BorderRadius.circular(screenWidth),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            upcomingTab = false;
                            setState(() {});
                            loadData();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: !upcomingTab
                                ? theme.blueColor
                                : theme.whiteColor,
                            child: text(
                              'السابقة',
                              screenWidth * 3.2,
                              !upcomingTab ? theme.whiteColor : theme.blueColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            upcomingTab = true;
                            setState(() {});
                            loadData();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: upcomingTab
                                ? theme.blueColor
                                : theme.whiteColor,
                            child: text(
                              'القادمة',
                              screenWidth * 3.2,
                              upcomingTab ? theme.whiteColor : theme.blueColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(15),
                child: allAppointments.isEmpty
                    ? Center(child: Text('لم يتم العثور على مواعيد'))
                    : Column(
                        children:
                            List.generate(allAppointments.length, (index) {
                          Appointment item = allAppointments[index];
                          if (upcomingTab) checkForPassed(item, index);
                          return Card(
                            margin: EdgeInsets.only(bottom: 15),
                            elevation: 5,
                            color: kBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: upcomingTab
                                    ? kBlueColor.withOpacity(0.1)
                                    : Colors.accents[0].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    ListTile(
                                      title: GestureDetector(
                                        onTap: () {
                                          if (userData.type == 'Student') {
                                            FirestoreHelper.getUserById(
                                                    item.tutorId)
                                                .then((value) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowTutorProfilePage(
                                                    userData: value,
                                                    myUserId: userData.userId,
                                                  ),
                                                ),
                                              );
                                            });
                                          } else {
                                            FirestoreHelper.getUserById(
                                                    item.studentId)
                                                .then((value) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          StudentProfileScreen(
                                                    userData: value,
                                                  ),
                                                ),
                                              );
                                            });
                                          }
                                        },
                                        child: Text(
                                          userData.type == 'Student'
                                              ? item.tutorName
                                              : item.studentName,
                                          style: const TextStyle(
                                            fontFamily: 'cb',
                                          ),
                                        ),
                                      ),
                                      subtitle: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Wrap(
                                              children: [
                                                Text(
                                                  item.status,
                                                  style: TextStyle(
                                                    color: item.status == 'ملغي'
                                                        ? Colors.red[700]
                                                        : Colors.green[700],
                                                    fontFamily: 'cb',
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Text(item.date),
                                                SizedBox(width: 15),
                                                Text(timePipe(item.time)),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  item.degree,
                                                  style: TextStyle(
                                                    fontFamily: 'cb',
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  ' | ' +
                                                      lessonTypePipe(
                                                          item.lessonType) +
                                                      ' | ',
                                                  style: TextStyle(
                                                    fontFamily: 'cb',
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  item.amount.toString() +
                                                      ' ريال/ساعة ',
                                                  style: TextStyle(
                                                    fontFamily: 'cb',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Visibility(
                                      visible:
                                          item.status == 'مؤكد', // if Confirmed
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Spacer(),
                                          // TextButton(
                                          //   onPressed: () {
                                          //     showCompleteAlert(context, index);
                                          //   },
                                          //   style: TextButton.styleFrom(
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: 15),
                                          //     side:
                                          //         BorderSide(color: kBlueColor),
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius:
                                          //           BorderRadius.circular(30),
                                          //     ),
                                          //   ),
                                          //   child: Text('انتهى الدرس'),
                                          // ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    friendId: userData.type ==
                                                            'Student'
                                                        ? item.tutorId
                                                        : item.studentId,
                                                    friendName: userData.type ==
                                                            'Student'
                                                        ? item.tutorName
                                                        : item.studentName,
                                                    //userData: userData,//(i dont know why this line is causing an error )
                                                  ),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              side:
                                                  BorderSide(color: kBlueColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Text('محادثة'),
                                          ),
                                          SizedBox(width: 20),
                                          TextButton(
                                            onPressed: () {
                                              showCancelAlert(context, index);
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              side:
                                                  BorderSide(color: kBlueColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Text('إلغاء الموعد'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      // visible If status Done and not leaved review before
                                      visible: item.status == 'انتهى' &&
                                          ((userData.type == 'Student')
                                              ? item.isStudentLeavedReview ==
                                                  false
                                              : item.isTutorLeavedReview ==
                                                  false),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              showLeaveReviewAlert(
                                                context,
                                                index,
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              side:
                                                  BorderSide(color: kBlueColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Text('تقييم'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewComponent extends StatefulWidget {
  final dynamic index;
  final dynamic userData;
  final ValueChanged onReview;
  const ReviewComponent({
    super.key,
    required this.index,
    required this.userData,
    required this.onReview,
  });

  @override
  State<ReviewComponent> createState() => _ReviewComponentState();
}

class _ReviewComponentState extends State<ReviewComponent> {
  // Variables
  var screenWidth = SizeConfig.widthMultiplier;
  Review reviewData = Review('', '', '', '', '', '');

  double stars = 0.0;
  var review = TextEditingController();
  UserData userData = emptyUserData;
  int index = 0;
  late Appointment item;
  bool isLoading = true;
  bool isCreated = false;

  List<Review> allReviews = [];

  // Functions
  leaveReview(index) {
    FocusScope.of(context).unfocus();
    if (stars == 0.0) {
      showToast('التقييم مطلوب');
    } else {
      createReview();
    }
  }

  showReviewCompletedAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(10),
      titlePadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(20),
      content: ReviewDonePopUp(),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  createReview() {
    showLoader(context, 'لحظة واحدة');
    reviewData.stars = stars.toString();
    reviewData.review = review.text;
    reviewData.createdAt =
        intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    double avRating = 0.0;
    double sum = stars;
    int count = allReviews.length + 1;
    for (var i = 0; i < allReviews.length; i++) {
      Review item = allReviews[i];
      sum += double.parse(item.stars);
    }
    avRating = sum / count;
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (isLoading == false && isCreated == false) {
        isCreated = true;
        if (mounted) setState(() {});
        FirestoreHelper.createReview(reviewData).then((value) async {
          var uObj = {"averageRating": avRating.toStringAsFixed(1).toString()};
          await FirestoreHelper.updateUserData(reviewData.userId, uObj);
          var aObj = userData.type == 'Student'
              ? {"isStudentLeavedReview": true}
              : {"isTutorLeavedReview": true};
          FirestoreHelper.updateAppointment(item.id, aObj);
          widget.onReview(userData.type);
          pop(context);
          pop(context);
          showReviewCompletedAlert(context);
        });
      }
    });
  }

  @override
  void initState() {
    index = widget.index;
    userData = widget.userData;
    item = allAppointments[index];
    reviewData.reviewerId = userData.userId;
    reviewData.reviewerName = userData.username;
    if (userData.type == 'Student') {
      reviewData.userId = item.tutorId;
    } else {
      reviewData.userId = item.studentId;
    }
    getAllReviews();
    super.initState();
  }

  getAllReviews() {
    FirestoreHelper.getAllReview(reviewData.userId).then((value) {
      isLoading = false;
      allReviews = value;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                'كيف كان درسك؟',
                style: const TextStyle(
                  fontFamily: 'cb',
                ),
              ),
            ),
            Center(
              child: Text(
                'مع ' +
                    (userData.type == 'Student'
                        ? item.tutorName
                        : item.studentName),
                style: const TextStyle(
                  fontFamily: 'cb',
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'التقييم:  ',
                  style: const TextStyle(
                    fontFamily: 'cb',
                  ),
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  glow: false,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  ignoreGestures: false,
                  itemCount: 5,
                  itemSize: 22,
                  itemPadding: EdgeInsets.all(0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rate_rounded,
                    color: kBlueColor,
                  ),
                  onRatingUpdate: (rating) {
                    stars = rating;
                    if (mounted) setState(() {});
                  },
                ),
                Text(stars.toString()),
              ],
            ),
            Text(
              'أكتب تقييم:  ',
              style: const TextStyle(
                fontFamily: 'cb',
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: review,
                maxLines: 6,
                style: textStyle(screenWidth * 3.7, theme.mainColor),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 4,
                    vertical: screenWidth * 3,
                  ),
                  hintText: 'أخبرنا المزيد عن ذلك...',
                  hintStyle: textStyle(
                    screenWidth * 3.3,
                    theme.lightTextColor,
                  ),
                  filled: true,
                  fillColor: Colors.white24,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 5),
                    borderSide:
                        BorderSide(width: .3, color: theme.lightTextColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 5),
                    borderSide: BorderSide(
                      width: .6,
                      color: theme.yellowColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  leaveReview(index);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  side: BorderSide(color: kBlueColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('تقييم'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewDonePopUp extends StatefulWidget {
  const ReviewDonePopUp({super.key});

  @override
  State<ReviewDonePopUp> createState() => _ReviewDonePopUpState();
}

class _ReviewDonePopUpState extends State<ReviewDonePopUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Column(
        children: [
          Text(
            '! رائع',
            style: TextStyle(
              fontFamily: 'cb',
            ),
          ),
          SizedBox(height: 5),
          Text(
            'تم التقييم بنجاح',
            style: TextStyle(
              fontFamily: 'cb',
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 15),
              side: BorderSide(color: kBlueColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text('تم'),
          ),
        ],
      ),
    );
  }
}
