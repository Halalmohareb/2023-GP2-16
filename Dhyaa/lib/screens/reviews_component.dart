import 'package:Dhyaa/models/review.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsComponent extends StatefulWidget {
  final List<Review> allReviews;
  const ReviewsComponent({super.key, required this.allReviews});

  @override
  State<ReviewsComponent> createState() => _ReviewsComponentState();
}

class _ReviewsComponentState extends State<ReviewsComponent> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: widget.allReviews.length == 0
          ? Text("لايوجد تقييم")
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.allReviews.length, (index) {
                  var item = widget.allReviews[index];
                  return Container(
                    height: 125,
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(13.3),
                              child: Image.asset(
                                'assets/images/avatar.png',
                                height: 46.6,
                                width: 46.6,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(
                                    Icons.star_rate_rounded,
                                    color: kBlueColor,
                                  ),
                                  Text(
                                    double.parse(item.stars).toString(),
                                    style: TextStyle(fontFamily: 'cb'),
                                  ),
                                ]),
                                Text(
                                  item.reviewerName,
                                  style: TextStyle(fontFamily: 'cb'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          constraints: BoxConstraints(maxHeight: 50),
                          child: SingleChildScrollView(
                            child: ExpandableText(
                              item.review,
                              expandText: 'أظهر المزيد',
                              collapseText: 'أظهر أقل',
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
