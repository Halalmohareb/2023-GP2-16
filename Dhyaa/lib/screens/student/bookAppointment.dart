import 'dart:convert';

import 'package:Dhyaa/globalWidgets/toast.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/appointment.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/provider/auth_provider.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/student/paymentPage.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class BookAppointment extends StatefulWidget {
  final dynamic userData;
  final dynamic myUserData;
  const BookAppointment({
    super.key,
    required this.userData,
    required this.myUserData,
  });

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  UserData userData = emptyUserData;
  UserData myUserData = emptyUserData;
  String selectedDegree = '';
  var lessonType = '';
  List<Task> tasks = [];
  List session = [];
  List selectedTime = [];
  int selectedDateIndex = -1;

  @override
  void initState() {
    userData = widget.userData;
    myUserData = widget.myUserData;
    selectedDegree = degreePipe().first;
    FirestoreHelper.getTutorTasks(userData).then((value) {
      tasks = value;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  List<String> degreePipe() {
    dynamic val = userData.degree;
    List<String> temp = [val];

    if (val != '' && val != null) {
      if (val[0] == '[' && val[val.length - 1] == ']') {
        temp = [];
        List arr = jsonDecode(val);
        for (var element in arr) {
          temp.add(element);
        }
      }
    }
    return temp;
  }

  _hPipe() {
    double temp = 0.0;
    if (userData.isOnlineLesson) temp += 55;
    if (userData.isStudentHomeLesson) temp += 55;
    if (userData.isTutorHomeLesson) temp += 55;
    return temp;
  }

  calculateTotalPrice() {
    int t = 0;
    if (lessonType != '' && selectedTime.isNotEmpty) {
      int rate = 0;
      if (lessonType == 'online') {
        rate = int.parse(userData.onlineLessonPrice);
      }
      if (lessonType == 'studentSide') {
        rate = int.parse(userData.studentsHomeLessonPrice);
      }
      if (lessonType == 'tutorSide') {
        rate = int.parse(userData.tutorsHomeLessonPrice);
      }
      t = rate * selectedTime.length;
    }
    return t.toString();
  }

  doValidation() {
    if (lessonType == '') {
      showToast('الرجاء تحديد نوع الدرس');
    } else if (selectedDateIndex <= -1) {
      showToast('يرجى تحديد تاريخ الدرس');
    } else if (selectedTime.isEmpty) {
      showToast('الرجاء تحديد الوقت');
    } else {
      goNext();
    }
  }

  goNext() {
    Appointment appointmentData = Appointment(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      [],
      '',
      DateTime.now(),
      '',
      '',
    );
    List time = [];
    for (var i in selectedTime) {
      time.add(session[i]);
    }
    appointmentData.tutorId = userData.userId;
    appointmentData.tutorName = userData.username;
    appointmentData.studentId = myUserData.userId;
    appointmentData.studentName = myUserData.username;
    appointmentData.degree = selectedDegree;
    appointmentData.lessonType = lessonType;
    appointmentData.date = tasks[selectedDateIndex].day;
    appointmentData.time = time;
    appointmentData.amount = calculateTotalPrice();
    appointmentData.createdAt = DateTime.now();
    appointmentData.status = 'مؤكد';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(appointmentData: appointmentData),
      ),
    );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.black, thickness: 1),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'المعلم :',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: userData.username,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'المادة:',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 30,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            border: Border.all(color: kBlueColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDegree,
                              items: degreePipe().map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                              onChanged: (_) {
                                selectedDegree = _.toString();
                                if (mounted) setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: _hPipe(),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  'نوع الدرس:',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: userData.isOnlineLesson,
                                  child: Container(
                                    height: 55,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: lessonType == 'online',
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.all(0),
                                            shape: CircleBorder(),
                                            onChanged: (value) {
                                              lessonType =
                                                  value! ? 'online' : '';
                                              if (mounted) setState(() {});
                                            },
                                            title: Text('أون لاين'),
                                          ),
                                        ),
                                        Text(
                                          userData.onlineLessonPrice +
                                              ' ريال/ساعة',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: userData.isStudentHomeLesson,
                                  child: Container(
                                    height: 55,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: lessonType == 'studentSide',
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.all(0),
                                            shape: CircleBorder(),
                                            onChanged: (value) {
                                              lessonType =
                                                  value! ? 'studentSide' : '';
                                              if (mounted) setState(() {});
                                            },
                                            title: Text('حضوري (مكان الطالب)'),
                                          ),
                                        ),
                                        Text(
                                          userData.studentsHomeLessonPrice +
                                              ' ريال/ساعة',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: userData.isTutorHomeLesson,
                                  child: Container(
                                    height: 55,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CheckboxListTile(
                                            value: lessonType == 'tutorSide',
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.all(0),
                                            shape: CircleBorder(),
                                            onChanged: (value) {
                                              lessonType =
                                                  value! ? 'tutorSide' : '';
                                              if (mounted) setState(() {});
                                            },
                                            title: Text('حضوري (مكان المعلم)'),
                                          ),
                                        ),
                                        Text(
                                          userData.tutorsHomeLessonPrice +
                                              ' ريال/ساعة',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'تاريخ الدرس:',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    _showDate(),
                    SizedBox(height: 20),
                    Visibility(
                      visible: selectedDateIndex > -1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وقت البداية:',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          _showTime(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'السعر الكلي:     ' + calculateTotalPrice(),
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: kSearchBackgroundColor,
            border: Border(
              top: BorderSide(width: 0.8, color: Colors.black),
            ),
          ),
          child: TextButton(
            onPressed: () {
              doValidation();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 15),
              side: BorderSide(color: kBlueColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text('الدفع والحجز'),
          ),
        ),
      ),
    );
  }

  _showDate() {
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: tasks.length == 0
          ? Text('المعلم غير متوفر لتحديد موعد')
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tasks.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    onDateSelect(index);
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedDateIndex == index
                          ? Colors.accents[6].withOpacity(0.2)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      tasks[index].day.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  bool isChecking = false;
  isAppointmentExist(timeObj, date, tutorId) {
    isChecking = true;
    if (mounted) setState(() {});
    FirestoreHelper.isAppointmentExist(timeObj, date, tutorId)
        .then((isAvailableForAppointment) {
      if (isAvailableForAppointment) {
        isChecking = false;
        session.add(timeObj);
        if (mounted) setState(() {});
      }
    });
  }

  onDateSelect(index) {
    selectedDateIndex = index;
    var date = tasks[selectedDateIndex];
    session = [];
    selectedTime = [];
    if (selectedDateIndex > -1) {
      int s = int.parse(date.startTime.split(':')[0]);
      int e = int.parse(date.endTime.split(':')[0]);
      int counter = e - s;
      for (var i = 0; i < counter.abs(); i++) {
        isAppointmentExist(
          {
            'start': (s + i).toString() + ':00',
            'end': ((s + i) + 1).toString() + ':00'
          },
          tasks[selectedDateIndex].day,
          userData.userId,
        );
      }
    }
    if (mounted) setState(() {});
  }

  _showTime() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: session.length == 0 && !isChecking
          ? Text('المعلم محجوز في هذا الوقت ،الرجاء تحديد وقت اخر')
          : Wrap(
              children: List.generate(session.length, (index) {
                var temp = session[index];
                return GestureDetector(
                  onTap: () {
                    (selectedTime.contains(index))
                        ? selectedTime.remove(index)
                        : selectedTime.add(index);
                    if (mounted) setState(() {});
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedTime.contains(index)
                          ? Colors.accents[6].withOpacity(0.2)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      temp['start'] + ' - ' + temp['end'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
