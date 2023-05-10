import 'package:Dhyaa/models/review.dart';
import 'package:Dhyaa/screens/reviews_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/theme/theme.dart';

class StudentProfileScreen extends StatefulWidget {
  final dynamic userData;
  const StudentProfileScreen({super.key, required this.userData});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  UserData userData = emptyUserData;
  List<Review> allReviews = [];

  @override
  void initState() {
    userData = widget.userData;
    getAllReviews();
    super.initState();
  }

  getAllReviews() {
    FirestoreHelper.getAllReview(userData.userId).then((value) {
      allReviews = value;
      if (mounted) setState(() {});
    });
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            margin: EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/icons/DhyaaLogo.png',
              height: 40,
            ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          userData.username,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'cb',
                          ),
                        ),
                        SizedBox(width: 10),
                        RatingBar.builder(
                          initialRating: double.parse(userData.averageRating),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 20,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: theme.blueColor,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        SizedBox(width: 10),
                        Text(
                          userData.averageRating,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'cb',
                          ),
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'نبذه عني: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'cb',
                            ),
                          ),
                          TextSpan(text: userData.bio),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    ' التقييم ',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'cb',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ReviewsComponent(allReviews: allReviews),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}