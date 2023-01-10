import 'dart:convert';
import 'dart:math';
import 'package:Dhyaa/screens/student/bookAppointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/models/task.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import '../chat_screen.dart';

class ShowTutorProfilePage extends StatefulWidget {
  const ShowTutorProfilePage({Key? key, required this.userData});
  final UserData userData;
  @override
  State<ShowTutorProfilePage> createState() => _ShowTutorProfilePageState();
}

class _ShowTutorProfilePageState extends State<ShowTutorProfilePage> {
  UserData userData = emptyUserData;
  UserData myUserData = emptyUserData;
  List<Task> tasks = [];
  int selectedTime = 1;
  bool moreBool = false;

  @override
  void initState() {
    userData = widget.userData;
    getRecommendedTutors();
    FirestoreHelper.getTutorTasks(userData).then((value) {
      for (var task in value) {
        var d = task.day.split('-');
        DateTime _d =
            DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]));
        bool isNotPassed =
            _d.isAfter(DateTime.now().subtract(Duration(days: 1)));
        if (isNotPassed) tasks.add(task);
      }
      if (mounted) setState(() {});
    });
    FirestoreHelper.getMyUserData().then((value) {
      myUserData = value;
      if (mounted) setState(() {});
    });
    super.initState();
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
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        children: List.generate(temp.length, (index) {
          var item = temp[index];
          return Container(
            height: 30,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15),
                side: BorderSide(color: kBlueColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
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
              Divider(color: Colors.black, thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          userData.username,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 10),
                        RatingBar.builder(
                          initialRating: 4,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding: EdgeInsets.all(0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rate_rounded,
                            color: kBlueColor,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18),
                        SizedBox(width: 5),
                        Text(
                          userData.location + ', ' + userData.address,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.broadcast_on_personal, size: 18),
                        SizedBox(width: 5),
                        Text(
                          lessonTypePipe2(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'التخصص: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(text: userData.majorSubjects),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'نبذه عني: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(text: userData.bio),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'المواعيد المتاحة:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: _showTasks(),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'المواد:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              degreePipe(),
              SizedBox(height: 10),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'التقييم:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.accents[6].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'سارة',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 10),
                              RatingBar.builder(
                                initialRating: 4,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 10,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0.5),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rate_rounded,
                                  color: kBlueColor,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                          Text(
                            ' ممتاز و تعامل جيد',
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.accents[6].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'فهد',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 10),
                              RatingBar.builder(
                                initialRating: 4,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 10,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0.5),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rate_rounded,
                                  color: kBlueColor,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                          Text(
                            ' ممتاز',
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: moreBool,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.accents[6].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'جميل',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    RatingBar.builder(
                                      initialRating: 4,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 10,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.5),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star_rate_rounded,
                                        color: kBlueColor,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                                Text(
                                  'جميل',
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.accents[6].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'محمد',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    RatingBar.builder(
                                      initialRating: 4,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 10,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.5),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star_rate_rounded,
                                        color: kBlueColor,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ],
                                ),
                                Text(
                                  'اوصي به',
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !moreBool,
                      child: TextButton(
                        onPressed: () {
                          moreBool = !moreBool;
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          side: BorderSide(color: kBlueColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('..المزيد'),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 150,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            friendId: userData.userId,
                            friendName: userData.username,
                            userData: myUserData,
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      side: BorderSide(color: kBlueColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.chat_rounded, size: 18),
                        SizedBox(width: 10),
                        Text("تواصل مع المعلم"),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'قد يعجبك',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: recommendedWidget,
              ),
              SizedBox(height: 10),
              Divider(color: Colors.black, thickness: 1),
              SizedBox(height: 50),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointment(
                        userData: userData,
                        myUserData: myUserData,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  side: BorderSide(color: kBlueColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('احجز موعد مع المعلم'),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: getMinPrice(userData),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ريال/ساعة',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recommendedWidget = Container();
  

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
    // excluding (0) from the minimum comparison
    priceList.removeWhere((element) => element == 0);
    return priceList.length > 0 ? priceList.reduce(min).toString() : '-';
  }

  getRecommendedTutors() {
    FirestoreHelper.getRecommendedTutors(userData).then((tutors) {
      recommendedWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(tutors.length, (index) {
            UserData _tutor = tutors[index];
            return Container(
              width: MediaQuery.of(context).size.width / 2.2,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              constraints: BoxConstraints(
                minHeight: 220,
              ),
              decoration: BoxDecoration(
                color: kBlueColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tutor.username,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: kTitleTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
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
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        'السعر يبدأ من:  ' + getMinPrice(_tutor) +' '+'ريال/ساعة',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          side: BorderSide(color: kBlueColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowTutorProfilePage(
                                userData: _tutor,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "عرض ملف المعلم",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      );
      if (mounted) setState(() {});
    });
  }

  _showTasks() {
    List<Task> selectedTasks = tasks;
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: tasks.length == 0
          ? Align(
              alignment: Alignment.topRight,
              child: Text('المعلم غير متوفر لتحديد موعد'),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedTasks.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  height: 60,
                  width: 100,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.accents[6].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedTasks[index].day.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        selectedTasks[index].startTime +
                            ' - ' +
                            selectedTasks[index].endTime,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
