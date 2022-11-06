import 'package:flutter/material.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/screens/student/showTutorProfilePage.dart';

class TutorCardWidget extends StatefulWidget {
  const TutorCardWidget({super.key, required this.tutor});
  final UserData tutor;
  @override
  State<TutorCardWidget> createState() => _TutorCardWidgetState();
}

class _TutorCardWidgetState extends State<TutorCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Card(
            elevation: 7,
            color: kBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
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
                        widget.tutor.username,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: kTitleTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'التخصص: ' + widget.tutor.majorSubjects,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: kTitleTextColor),
                      ),
                      Text(
                        'الموقع: ' + widget.tutor.location,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: kTitleTextColor),
                      ),
                      Text(
                        'المادة: ' + widget.tutor.degree,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: kTitleTextColor),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          side: BorderSide(
                            color: kBlueColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowTutorProfilePage(
                                userData: widget.tutor,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "عرض ملف المعلم",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
