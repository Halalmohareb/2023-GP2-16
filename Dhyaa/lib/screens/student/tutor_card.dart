import 'dart:convert';
import 'dart:math';
import 'package:Dhyaa/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Dhyaa/constant.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/screens/student/showTutorProfilePage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TutorCardWidget extends StatefulWidget {
  final UserData tutor;
  final String myUserId;
  const TutorCardWidget({
    super.key,
    required this.tutor,
    required this.myUserId,
  });

  @override
  State<TutorCardWidget> createState() => _TutorCardWidgetState();
}

class _TutorCardWidgetState extends State<TutorCardWidget> {
  // Functions
  degreePipe(var val) {
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

  lessonTypePipe2() {
    String temp = '';
    if (widget.tutor.isOnlineLesson) {
      temp += 'أون لاين' + ' | ';
    }
    if (widget.tutor.isStudentHomeLesson) {
      temp += 'حضوري (مكان الطالب)' + ' | ';
    }
    if (widget.tutor.isTutorHomeLesson) {
      temp += 'حضوري (مكان المعلم)';
    }
    return temp;
  }

  String getMinPrice() {
  var priceList = [
    if (widget.tutor.onlineLessonPrice.isNotEmpty) int.tryParse(widget.tutor.onlineLessonPrice) ?? 0,
    if (widget.tutor.studentsHomeLessonPrice.isNotEmpty) int.tryParse(widget.tutor.studentsHomeLessonPrice) ?? 0,
    if (widget.tutor.tutorsHomeLessonPrice.isNotEmpty) int.tryParse(widget.tutor.tutorsHomeLessonPrice) ?? 0,
  ];
  priceList.removeWhere((element) => element == 0);
  return priceList.isNotEmpty ? priceList.reduce(min).toString() : '-';
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowTutorProfilePage(
              userData: widget.tutor,
              myUserId: widget.myUserId,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 15,
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                margin: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width - 50,
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
                    Padding(
                      padding: EdgeInsets.only(right: 45),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.tutor.username,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: kTitleTextColor,
                                  fontFamily: 'cb',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating:
                                    double.parse(widget.tutor.averageRating),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: 18,
                                itemPadding: EdgeInsets.all(0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_rate_rounded,
                                  color: kBlueColor,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              SizedBox(width: 5),
                              Text(widget.tutor.averageRating),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18),
                        SizedBox(width: 5),
                        Text(
                          widget.tutor.location + ', ' + widget.tutor.address,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.broadcast_on_personal, size: 18),
                        SizedBox(width: 5),
                        Expanded(child: Text(lessonTypePipe2())),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.price_change, size: 18),
                        SizedBox(width: 5),
                        Expanded(child: Text(getMinPrice() + '/ساعة')),
                      ],
                    ),
                    Text(
                      'التخصص: ' + widget.tutor.majorSubjects,
                    ),
                    Text(
                      'المادة: ' + degreePipe(widget.tutor.degree),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.tutor.avatar,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
