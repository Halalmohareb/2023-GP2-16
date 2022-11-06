import 'package:flutter/material.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/bookedLesson.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/screens/tutor/bookedLesson_card.dart';
import 'package:Dhyaa/theme/tutorTopBarNavigator.dart';

class upcomingLessonsScreen extends StatefulWidget {
  const upcomingLessonsScreen({Key? key}) : super(key: key);

  @override
  State<upcomingLessonsScreen> createState() => _upcomingLessonsScreenState();
}

class _upcomingLessonsScreenState extends State<upcomingLessonsScreen> {
  List<BookedLesson> BookedLessons = [];
  int count = 0;

  @override
  void initState() {
    getBookedLessons();
    super.initState();
  }

  Future getBookedLessons() async {
    FirestoreHelper.getMyBookedList().then((value) {
      print("object" + value[0].tutorMail);
      setState(() {
        BookedLessons = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () {
      //    setState(() {
      //      count++;
      //    });
      //    FirestoreHelper.addNewBookedLesson(BookedLesson(
      //        '',
      //        'student@gmail.com',
      //        'studentName' + count.toString(),
      //        'tutor@gmail.com',
      //        'tutorName',
      //        'Math',
      //        DateTime.now(),
      //        'Beginner',
      //        'active'));
      //    getBookedLessons();
      //  },
      //  child: const Icon(Icons.add),
      //  backgroundColor: Colors.red,
      //),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TutorTopBarNavigator(),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'الدروس القادمة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kTitleTextColor,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: BookedLessons.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        BookedLessonCard(bookedLesson: BookedLessons[index]),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
