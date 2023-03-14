import 'package:Dhyaa/_helper/areas.dart';
import 'package:Dhyaa/_helper/cities.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/models/UserData.dart';
import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'dart:math';
import '../../responsiveBloc/size_config.dart';

class FilterOptions extends StatefulWidget {
  final List<UserData> tutorList;
  final ValueChanged onChange;
  final ValueChanged onRest;
  const FilterOptions({
    super.key,
    required this.tutorList,
    required this.onChange,
    required this.onRest,
  });

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  // Variables
  var screenWidth = SizeConfig.widthMultiplier;
  SfRangeValues priceRange = SfRangeValues(1.0, 100.0);
  TextEditingController location = TextEditingController();
  GlobalKey<FormFieldState> locationKey = GlobalKey<FormFieldState>();
  TextEditingController address = TextEditingController();
  GlobalKey<FormFieldState> addressKey = GlobalKey<FormFieldState>();

  bool isOnlineLesson = true;
  bool isStudentHomeLesson = false;
  bool isTutorHomeLesson = false;

  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;

  var citiesList = [
    "الرياض",
    "جدة",
    "مكة",
    "المدينة",
    "الدمام",
    "الهفوف",
    "الطايف",
    "تبوك",
    "بريدة",
    "خميس مشيط",
    "الجبيل",
    "نجران",
    "المبرز",
    "حائل",
    "أبها",
    "ينبع",
    "عرعر",
    "عنيزة",
    "سكاكا",
    "جازان",
    "القريات",
    "الباحة",
    "بيشة",
    "الرس",
    "الشفا",
  ];
  List areasList = [];

  // Functions
  oldVal() {
    if (citiesList.contains(location.text)) {
      return location.text;
    } else {
      return null;
    }
  }

  getMinPrice(UserData tutor) {
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
    return priceList.length > 0 ? priceList.reduce(min) : 0;
  }

  getMaxPrice(UserData tutor) {
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
    return priceList.length > 0 ? priceList.reduce(max) : 0;
  }

  doFilter() {
    List<UserData> filteredList = [];
    for (var tutor in widget.tutorList) {
      var min = getMinPrice(tutor);
      var max = getMinPrice(tutor);
      bool priceChecker = false;
      bool locationChecker = false;
      bool addressChecker = false;
      bool isOnlineChecker = false;
      bool isStudentHomeChecker = false;
      bool isTutorHomeChecker = false;
      bool ratingChecker = false;

      if ((priceRange.start <= min && priceRange.end >= max)) {
        priceChecker = true;
      }

      if (location.text == '') {
        locationChecker = true;
      } else {
        if (tutor.location == location.text) {
          locationChecker = true;
        }
      }

      if (address.text == '') {
        addressChecker = true;
      } else {
        if (tutor.address == address.text) {
          addressChecker = true;
        }
      }

      if (isOnlineLesson) {
        if (tutor.isOnlineLesson == isOnlineLesson) {
          isOnlineChecker = true;
        }
      } else {
        isOnlineChecker = true;
      }
      if (isStudentHomeLesson) {
        if (tutor.isStudentHomeLesson == isStudentHomeLesson) {
          isStudentHomeChecker = true;
        }
      } else {
        isStudentHomeChecker = true;
      }
      if (isTutorHomeLesson) {
        if (tutor.isTutorHomeLesson == isTutorHomeLesson) {
          isTutorHomeChecker = true;
        }
      } else {
        isTutorHomeChecker = true;
      }

      if (star1) {
        if (double.parse(tutor.averageRating) == 1) {
          ratingChecker = true;
        }
      }

      if (star2) {
        if (double.parse(tutor.averageRating) >= 2 &&
            double.parse(tutor.averageRating) < 3) {
          ratingChecker = true;
        }
      }
      if (star3) {
        if (double.parse(tutor.averageRating) >= 3 &&
            double.parse(tutor.averageRating) < 4) {
          ratingChecker = true;
        }
      }
      if (star4) {
        if (double.parse(tutor.averageRating) >= 4 &&
            double.parse(tutor.averageRating) < 5) {
          ratingChecker = true;
        }
      }
      if (star5) {
        if (double.parse(tutor.averageRating) == 5) {
          ratingChecker = true;
        }
      }
      if (!star1 && !star2 && !star3 && !star4 && !star5) {
        ratingChecker = true;
      }
      if (priceChecker &&
          locationChecker &&
          addressChecker &&
          isOnlineChecker &&
          isStudentHomeChecker &&
          isTutorHomeChecker &&
          ratingChecker) {
        filteredList.add(tutor);
      }
    }

    widget.onChange(filteredList);
    Navigator.pop(context);
  }

  reset() {
    priceRange = SfRangeValues(1.0, 100.0);
    locationKey.currentState?.reset();
    addressKey.currentState?.reset();
    location.clear();
    address.clear();
    areasList.clear();
    isOnlineLesson = true;
    isStudentHomeLesson = false;
    isTutorHomeLesson = false;
    widget.onRest('reset');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'تصفية نتائج البحث',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'cb',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => reset(),
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kBlueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('نطاق السعر للساعة'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            priceRange.start.toStringAsFixed(0) +
                                ' ريال/ساعة' +
                                ' - ' +
                                priceRange.end.toStringAsFixed(0) +
                                ' ريال/ساعة',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SfRangeSlider(
                        min: 1,
                        max: 150,
                        stepSize: 1,
                        interval: 20,
                        showTicks: false,
                        showLabels: false,
                        enableTooltip: true,
                        values: priceRange,
                        minorTicksPerInterval: 1,
                        onChanged: (SfRangeValues values) {
                          priceRange = values;
                          if (mounted) setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kBlueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المدينة'),
                      SizedBox(
                        height: screenWidth * 12.5,
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          value: oldVal(),
                          key: locationKey,
                          items: citiesList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_selectedValue) async {
                            var tempCity = await cities.where((element) =>
                                (element['name_ar'] == _selectedValue));
                            var tempArea = await areas.where((element) =>
                                (element['city_id'] ==
                                    tempCity.first['city_id']));
                            addressKey.currentState?.reset();
                            address.clear();
                            areasList.clear();
                            areasList.addAll(tempArea);
                            location.text = _selectedValue.toString();
                            if (mounted) setState(() {});
                          },
                          style: textStyle(screenWidth * 3.7, theme.mainColor),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 3),
                            hintText: 'الرياض',
                            hintStyle: textStyle(
                                screenWidth * 3.3, theme.lightTextColor),
                            filled: true,
                            fillColor: Colors.white24,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: .3,
                                color: theme.lightTextColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: .6,
                                color: theme.yellowColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('العنوان / الحي'),
                      SizedBox(
                        height: screenWidth * 12.5,
                        width: double.infinity,
                        child: DropdownButtonFormField(
                          key: addressKey,
                          items: areasList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value['name_ar']),
                            );
                          }).toList(),
                          onChanged: (dynamic _selectedValue) {
                            address.text = _selectedValue['name_ar'].toString();
                            print(address.text);
                            if (mounted) setState(() {});
                          },
                          style: textStyle(screenWidth * 3.7, theme.mainColor),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 3),
                            hintText: address.text,
                            hintStyle: textStyle(
                                screenWidth * 3.3, theme.lightTextColor),
                            filled: true,
                            fillColor: Colors.white24,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    width: .3, color: theme.lightTextColor)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: .6,
                                color: theme.yellowColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kBlueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('نوع الدروس'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              isOnlineLesson = !isOnlineLesson;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 17),
                              width: MediaQuery.of(context).size.width / 3 - 25,
                              decoration: BoxDecoration(
                                color: isOnlineLesson
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'أون لاين',
                                  style: TextStyle(
                                    fontSize: screenWidth * 3,
                                    color: theme.lightTextColor,
                                    fontFamily: 'cb',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              isStudentHomeLesson = !isStudentHomeLesson;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              width: MediaQuery.of(context).size.width / 3 - 25,
                              decoration: BoxDecoration(
                                color: isStudentHomeLesson
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'حضوري\n(مكان الطالب)',
                                  style: TextStyle(
                                    fontSize: screenWidth * 3,
                                    color: theme.lightTextColor,
                                    fontFamily: 'cb',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              isTutorHomeLesson = !isTutorHomeLesson;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              width: MediaQuery.of(context).size.width / 3 - 25,
                              decoration: BoxDecoration(
                                color: isTutorHomeLesson
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'حضوري\n(مكان المعلم)',
                                  style: TextStyle(
                                    fontSize: screenWidth * 3,
                                    color: theme.lightTextColor,
                                    fontFamily: 'cb',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kBlueColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('تقييم'),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              star1 = !star1;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              decoration: BoxDecoration(
                                color: star1
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.star_rounded, size: 18),
                                  Text(
                                    '1',
                                    style: TextStyle(
                                      fontFamily: 'cb',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              star2 = !star2;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              decoration: BoxDecoration(
                                color: star2
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.star_rounded, size: 18),
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      fontFamily: 'cb',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              star3 = !star3;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              decoration: BoxDecoration(
                                color: star3
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.star_rounded, size: 18),
                                  Text(
                                    '3',
                                    style: TextStyle(
                                      fontFamily: 'cb',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              star4 = !star4;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              decoration: BoxDecoration(
                                color: star4
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.star_rounded, size: 18),
                                  Text(
                                    '4',
                                    style: TextStyle(
                                      fontFamily: 'cb',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              star5 = !star5;
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              decoration: BoxDecoration(
                                color: star5
                                    ? kBlueColor.withOpacity(0.2)
                                    : kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.star_rounded, size: 18),
                                  Text(
                                    '5',
                                    style: TextStyle(
                                      fontFamily: 'cb',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 45,
                    child: TextButton(
                      onPressed: () {
                        doFilter();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 15),
                              Text('تصفية نتيجة البحث'),
                            ],
                          ),
                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: kBlueColor.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        side: BorderSide(color: kBlueColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
