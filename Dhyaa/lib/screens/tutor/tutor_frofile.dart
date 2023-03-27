

  import 'dart:convert';
  import 'dart:math';
  import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
  import 'package:Dhyaa/models/review.dart';
  import 'package:Dhyaa/responsiveBloc/size_config.dart';
  import 'package:Dhyaa/screens/reviews_component.dart';
  import 'package:Dhyaa/screens/student/bookAppointment.dart';
  import 'package:Dhyaa/theme/theme.dart';
  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_rating_bar/flutter_rating_bar.dart';
  import 'package:Dhyaa/models/UserData.dart';
  import 'package:Dhyaa/models/task.dart';
  import 'package:Dhyaa/provider/firestore.dart';
  import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
  import 'package:get/get_connect/http/src/utils/utils.dart';
  import '../chat_screen.dart';
  import '../tutor/editTutorialPage.dart';
  import '../update_profile.dart';

  class tutorFrofile extends StatefulWidget {
  final UserData userData;
  final String myUserId;
  const tutorFrofile({
  Key? key,
  required this.userData,
  required this.myUserId,
  });
  @override
  State<tutorFrofile> createState() => _tutorFrofile();
  }

  class _tutorFrofile extends State<tutorFrofile> {
  UserData userData = emptyUserData;
  UserData myUserData = emptyUserData;
  List<Task> tasks = [];
  List<Review> allReviews = [];
  int tabIndex = 0;
  var screenWidth = SizeConfig.widthMultiplier;

  @override
  void initState() {
  userData = widget.userData;
  getAllReviews();
  //  getRecommendedTutors();
  getAvailability();
  FirestoreHelper.getMyUserData().then((value) {
  myUserData = value;
  if (mounted) setState(() {});
  });
  super.initState();
  }

  getAvailability() {
  FirestoreHelper.getTutorTasks(userData).then((value) async {
  for (var task in value) {
  var s = task.day.split('-');
  DateTime d =
  DateTime(int.parse(s[0]), int.parse(s[1]), int.parse(s[2]));
  bool isAfter = d.isAfter(DateTime.now());
  if (isAfter) tasks.add(task);
  }
  tasks.sort((Task a, Task b) => a.day.compareTo(b.day));
  if (mounted) setState(() {});
  });
  }

  getAllReviews() {
  FirestoreHelper.getAllReview(userData.userId).then((value) {
  allReviews = value;
  if (mounted) setState(() {});
  });
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
  padding: EdgeInsets.symmetric(horizontal: 5),
  child: Wrap(
  children: List.generate(temp.length, (index) {
  var item = temp[index];
  return Container(
  height: 25,
  margin: EdgeInsets.symmetric(horizontal: 5),
  child: TextButton(
  onPressed: null,
  style: TextButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 15),
  backgroundColor: theme.fillLightColor,
  side: BorderSide(color: kBlueColor),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
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
  var screenWidth = SizeConfig.widthMultiplier;

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
  Divider(color: Colors.grey, thickness: 1),
  Padding(
  padding: const EdgeInsets.all(15),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: CachedNetworkImage(
  imageUrl: userData.avatar,
  placeholder: (context, url) => Center(
  child: CircularProgressIndicator(),
  ),
  errorWidget: (context, url, error) =>
  Icon(Icons.error),
  height: 70,
  width: 70,
  fit: BoxFit.cover,
  ),
  ),
  Container(
  padding: EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 5,
  ),
  alignment: Alignment.center,
  decoration: BoxDecoration(
  color: kBlueColor.withOpacity(0.3),
  borderRadius: BorderRadius.circular(10),
  ),
  child: Text.rich(
  TextSpan(
  children: [
  TextSpan(
  text: getMinPrice(userData),
  style: TextStyle(
  fontFamily: 'cb',
  ),
  ),
  TextSpan(
  text: ' ريال/ساعة',
  style: TextStyle(fontSize: 15),
  ),
  ],
  ),
  ),
  ),
  ],
  ),
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  userData.username,
  style: TextStyle(
  fontSize: 20,
  fontFamily: 'cb',
  ),
  ),
  SizedBox(width: 10),
  Row(
  children: [
  RatingBar.builder(
  initialRating:
  double.parse(userData.averageRating),
  minRating: 1,
  direction: Axis.horizontal,
  allowHalfRating: true,
  ignoreGestures: true,
  itemCount: 5,
  itemSize: 20,
  itemPadding: EdgeInsets.all(0),
  itemBuilder: (context, _) => Icon(
  Icons.star_rate_rounded,
  color: kBlueColor,
  ),
  onRatingUpdate: (rating) {},
  ),
  SizedBox(width: 5),
  Text(
  userData.averageRating,
  style: TextStyle(
  fontSize: 16,
  fontFamily: 'cb',
  color: kBlueColor,
  ),
  ),
  ],
  ),
  ],
  ),
  Row(
  children: [
  Icon(Icons.location_on_outlined, size: 16),
  SizedBox(width: 5),
  Text(
  userData.location + ', ' + userData.address,
  ),
  ],
  ),
  Row(
  children: [
  Icon(Icons.broadcast_on_personal_outlined, size: 16),
  SizedBox(width: 5),
  Expanded(
  child: Text(lessonTypePipe2()),
  ),
  ],
  ),
  Text.rich(
  TextSpan(
  children: [
  TextSpan(
  text: 'التخصص: ',
  style: TextStyle(fontFamily: 'cb'),
  ),
  TextSpan(text: userData.majorSubjects),
  ],
  ),
  ),
  ],
  ),
  ),
  SizedBox(height: 10),
  degreePipe(),
  SizedBox(height: 5),
  Container(
  height: tabHight(),
  width: MediaQuery.of(context).size.width,
  child: DefaultTabController(
  initialIndex: 0,
  length: 3,
  child: Column(
  children: [
  TabBar(
  labelColor: kBlueColor,
  onTap: (value) {
  tabIndex = value;
  if (mounted) setState(() {});
  },
  tabs: <Widget>[
  Tab(
  text: 'نبذه عني',
  ),
  Tab(
  text: 'التوفر',
  ),
  Tab(
  text: 'التقييم',
  ),
  ],
  ),
  Expanded(
  child: TabBarView(
  physics: NeverScrollableScrollPhysics(),
  children: <Widget>[
  Text(
  userData.bio == '' ? 'غير متوفرة' : userData.bio,
  ),
  showAvailability(),
  ReviewsComponent(allReviews: allReviews),
  ],
  ),
  ),
  ],
  ),
  ),
  ),
  // Padding(
  //   padding: EdgeInsets.symmetric(horizontal: 10),
  //   child: Align(
  //     alignment: Alignment.topRight,
  //     child: Text(
  //       'قد يعجبك',
  //       style: TextStyle(
  //         fontSize: 16,
  //         fontFamily: 'cb',
  //       ),
  //     ),
  //   ),
  // ),
  // SizedBox(height: 10),
  // Padding(
  //   padding: EdgeInsets.symmetric(horizontal: 10),
  //   child: recommendedWidget,
  // ),
  SizedBox(height: 160),
  GestureDetector(
  onTap: () {
  Navigator.push(context,
  MaterialPageRoute(builder: (context) =>
  UpdateProfile(userData: userData,),),);
  },
  child: Container(
  alignment: Alignment.center,
  width: double.infinity,
  margin:
  EdgeInsets.symmetric(vertical: screenWidth * 2, horizontal: screenWidth*4)
      .copyWith(bottom: 0),
  padding: EdgeInsets.symmetric(
  horizontal: screenWidth * 4,
  vertical: screenWidth * 3),
  decoration: BoxDecoration(
  border: Border.all(color: theme.mainColor),
  borderRadius: BorderRadius.circular(10),
  color: theme.blueColor,
  ),
  child: text(
  'تحديث',
  screenWidth * 3.9,
  theme.whiteColor,
  ),
  ),
  ),

  // widget.myUserId == widget.userData.userId
  //     ? Container(height: 0)
  //     : Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 15),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => BookAppointment(
  //                         userData: userData,
  //                         myUserData: myUserData),
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 width: MediaQuery.of(context).size.width / 2.3,
  //                 margin: EdgeInsets.symmetric(
  //                         vertical: screenWidth * 2)
  //                     .copyWith(bottom: screenWidth),
  //                 padding: EdgeInsets.all(screenWidth * 2.5),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: theme.blueColor),
  //                 child: text(
  //                   'احجز موعدًا',
  //                   screenWidth * 3.4,
  //                   theme.whiteColor,
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => ChatScreen(
  //                         friendId: userData.userId,
  //                         friendName: userData.username),
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 alignment: Alignment.center,
  //                 width: MediaQuery.of(context).size.width / 2.3,
  //                 margin: EdgeInsets.symmetric(
  //                         vertical: screenWidth * 2)
  //                     .copyWith(bottom: 0),
  //                 padding: EdgeInsets.all(screenWidth * 2.5),
  //                 decoration: BoxDecoration(
  //                   color: theme.fillColor,
  //                   border: Border.all(color: theme.mainColor),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: text(
  //                   "تواصل مع المعلم",
  //                   screenWidth * 3.4,
  //                   theme.mainColor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  SizedBox(height: 20),
  ],
  ),
  ),
  ),
  );
  }

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
  priceList.removeWhere((element) => element == 0);
  return priceList.length > 0 ? priceList.reduce(min).toString() : '-';
  }

  Widget recommendedWidget = Container();
  // getRecommendedTutors() {
  //   FirestoreHelper.getRecommendedTutors(userData).then((tutors) {
  //     recommendedWidget = SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: List.generate(tutors.length, (index) {
  //           UserData _tutor = tutors[index];
  //           return Container(
  //             height: 320,
  //             margin: EdgeInsets.symmetric(horizontal: 5),
  //             width: MediaQuery.of(context).size.width / 1.5,
  //             child: Stack(
  //               children: [
  //                 Positioned(
  //                   top: 40,
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width / 1.5,
  //                     padding: EdgeInsets.only(top: 15, left: 10, right: 10),
  //                     height: 270,
  //                     decoration: BoxDecoration(
  //                       color: theme.bgColor,
  //                       borderRadius: BorderRadius.circular(20),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: theme.darkTextColor.withOpacity(0.3),
  //                           blurRadius: 5,
  //                           offset: Offset(0, 3),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         SizedBox(height: 30),
  //                         Text(
  //                           _tutor.username,
  //                           textDirection: TextDirection.rtl,
  //                           style: TextStyle(
  //                             color: kTitleTextColor,
  //                             fontFamily: 'cb',
  //                           ),
  //                         ),
  //                         RatingBar.builder(
  //                           initialRating: double.parse(_tutor.averageRating),
  //                           minRating: 0,
  //                           direction: Axis.horizontal,
  //                           allowHalfRating: true,
  //                           ignoreGestures: true,
  //                           itemCount: 5,
  //                           itemSize: 15,
  //                           itemPadding: EdgeInsets.all(0),
  //                           itemBuilder: (context, _) => Icon(
  //                             Icons.star_rate_rounded,
  //                             color: kBlueColor,
  //                           ),
  //                           onRatingUpdate: (rating) {},
  //                         ),
  //                         SizedBox(height: 5),
  //                         Wrap(
  //                           children: [
  //                             Icon(Icons.location_on, size: 15),
  //                             SizedBox(width: 5),
  //                             Text(
  //                               _tutor.location + ', ' + _tutor.address,
  //                               style: TextStyle(fontSize: 13),
  //                             ),
  //                           ],
  //                         ),
  //                         Wrap(
  //                           children: [
  //                             Icon(Icons.broadcast_on_personal, size: 15),
  //                             SizedBox(width: 5),
  //                             Text(
  //                               lessonTypePipe(_tutor),
  //                               style: TextStyle(fontSize: 13),
  //                             ),
  //                           ],
  //                         ),
  //                         Text(
  //                           'المادة: ' + degreeTextPipe(_tutor.degree),
  //                           textDirection: TextDirection.rtl,
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: TextStyle(fontSize: 13),
  //                         ),
  //                         Text(
  //                           'السعر يبدأ من:  ' +
  //                               getMinPrice(_tutor) +
  //                               ' ' +
  //                               'ريال/ساعة',
  //                           textDirection: TextDirection.rtl,
  //                           style: TextStyle(fontSize: 13),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: 0,
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width / 1.5,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.circular(20),
  //                           child: CachedNetworkImage(
  //                             imageUrl: _tutor.avatar,
  //                             placeholder: (context, url) => Center(
  //                               child: CircularProgressIndicator(),
  //                             ),
  //                             errorWidget: (context, url, error) =>
  //                                 Icon(Icons.error),
  //                             height: 70,
  //                             width: 70,
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //       ),
  //     );
  //     if (mounted) setState(() {});
  //   });
  // }

  showAvailability() {
  return Container(
  height: 55,
  margin: EdgeInsets.all(10),
  child: tasks.length == 0
  ? Align(
  alignment: Alignment.topRight,
  child: Text('المعلم غير متوفر لتحديد موعد'),
  )
      : Wrap(
  spacing: 10.0,
  children: List.generate(tasks.length, (index) {
  return Container(
  height: 55,
  width: MediaQuery.of(context).size.width / 3 - 15,
  margin: EdgeInsets.only(bottom: 10),
  padding: EdgeInsets.all(5),
  decoration: BoxDecoration(
  color: kBlueColor.withOpacity(0.3),
  borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
  Text(
  tasks[index].day.toUpperCase(),
  style: TextStyle(
  fontSize: 11,
  fontFamily: 'cb',
  color: Colors.black,
  ),
  ),
  Text(
  tasks[index].startTime + ' - ' + tasks[index].endTime,
  style: TextStyle(
  fontSize: 11,
  fontFamily: 'cb',
  color: Colors.black,
  ),
  ),
  ],
  ),
  );
  })),
  );
  }

  tabHight() {
  double h = 0;
  if (tabIndex == 0) {
  h = 50.0 + (25.0 * getNumberOfLines(userData.bio, context));
  }
  if (tabIndex == 1) {
  h = tasks.length > 3 ? (tasks.length / 2) * 70 : 120;
  }
  if (tabIndex == 2) {
  h = 200;
  }
  return h;
  }

  int getNumberOfLines(String text, BuildContext context) {
  final textSpan = TextSpan(
  text: text,
  style: DefaultTextStyle.of(context).style,
  );
  final textPainter = TextPainter(
  text: textSpan,
  textDirection: TextDirection.ltr,
  maxLines: null,
  );
  textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
  final lines = textPainter.computeLineMetrics();
  return lines.length;
  }
  }
