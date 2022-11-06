import 'package:flutter/material.dart';
import 'package:Dhyaa/models/bookedLesson.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/screens/tutor/studentDetail_screen.dart';

class BookedLessonCard extends StatefulWidget {
  const BookedLessonCard({Key? key, required this.bookedLesson})
      : super(key: key);
  final BookedLesson bookedLesson;
  @override
  State<BookedLessonCard> createState() => _BookedLessonCardState();
}

class _BookedLessonCardState extends State<BookedLessonCard> {
  UserData student =
      UserData('aaa', 'bbb', 'ccc', 'dddd', 'eee', 'fff', 'ggg', 'hhh');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.accents[0].withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "اسم الطالب :" + widget.bookedLesson.studentName,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "المادة :" + widget.bookedLesson.subject,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "المرحلة :" + widget.bookedLesson.level,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "التاريخ :" +
                              widget.bookedLesson.time.month.toString() +
                              '/' +
                              widget.bookedLesson.time.day.toString() +
                              '/' +
                              widget.bookedLesson.time.year.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: Image.asset('assets/images/doctor1.png'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetailScreen(
                              userData: student,
                            ),
                          ),
                        );
                      },
                      child: const Text("ملف الطالب")),
                  TextButton(onPressed: () {}, child: const Text("الغاء")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
