import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/appointment.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/chat_screen.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/theme/studentTopBarNavigator.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:flutter/material.dart';

import '../responsiveBloc/size_config.dart';

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
  List<Appointment> allAppointments = [];

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
        setState(() {
          allAppointments = value;
        });
      });
    } else {
      FirestoreHelper.getPreviousAppointmentList(
        userData.type == 'Student' ? 'studentId' : 'tutorId',
        userData.userId,
      ).then((value) {
        setState(() {
          allAppointments = value;
        });
      });
    }
  }

  timePipe(time) {
    String t = '';
    for (var element in time) {
      t += (element['start'] + ' ' + element['end']);
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

  doComplete(index) {
    FirestoreHelper.changeAppointmentStatus(allAppointments[index].id, 'انتهى')
        .then((value) => loadData());
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
                    fontWeight: FontWeight.w900,
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
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.accents[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  ListTile(
                                    title: Text(
                                      userData.type == 'Student'
                                          ? item.tutorName
                                          : item.studentName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.w700,
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
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                ' | ' +
                                                    lessonTypePipe(
                                                        item.lessonType) +
                                                    ' | ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                item.amount.toString() +
                                                    ' ريال/ساعة ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
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
                                    visible: item.status == 'مؤكد',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            showCompleteAlert(context, index);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            side: BorderSide(color: kBlueColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: Text('انتهى الدرس'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  friendId:
                                                      userData.type == 'Student'
                                                          ? item.tutorId
                                                          : item.studentId,
                                                  friendName:
                                                      userData.type == 'Student'
                                                          ? item.tutorName
                                                          : item.studentName,
                                                 // userData: userData,(i dont know why this line is causing an error )
                                                ),
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            side: BorderSide(color: kBlueColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: Text('محادثة'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showCancelAlert(context, index);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            side: BorderSide(color: kBlueColor),
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
                                    visible: item.status != 'مؤكد',
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            side: BorderSide(color: kBlueColor),
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
