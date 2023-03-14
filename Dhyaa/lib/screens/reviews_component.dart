import 'package:Dhyaa/models/review.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
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
          : Column(
              children: [
                Column(
                  children: List.generate(widget.allReviews.length, (index) {
                    var item = widget.allReviews[index];
                    return Visibility(
                      visible: index > 2 ? showMore : true,
                      child: Container(
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
                            Wrap(
                              children: [
                                Text(
                                  item.reviewerName,
                                  style: TextStyle(
                                    fontFamily: 'cb',
                                  ),
                                ),
                                SizedBox(width: 10),
                                RatingBar.builder(
                                  initialRating: double.parse(item.stars),
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
                              ],
                            ),
                            ExpandableText(
                              item.review,
                              expandText: 'أظهر المزيد',
                              collapseText: 'أظهر أقل',
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                Visibility(
                  visible: showMore == false && widget.allReviews.length > 3,
                  child: TextButton(
                    onPressed: () {
                      showMore = !showMore;
                      if (mounted) setState(() {});
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
                ),
              ],
            ),
    );
  }
}
