import 'dart:convert';

import 'package:Dhyaa/screens/tutor/setAvaliable/ui/theme.dark.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/theme/theme.dart';
import 'package:material_tag_editor/tag_editor.dart';
import '../models/UserData.dart';
import '../responsiveBloc/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart'
    show Fluttertoast, Toast, ToastGravity;

class UpdateProfile extends StatefulWidget {
  final UserData userData;
  const UpdateProfile({Key? key, required this.userData}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // Variables
  var screenWidth = SizeConfig.widthMultiplier;
  UserData userData = emptyUserData;

  var type = '';
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

  bool isOnlineLesson = true;
  bool isStudentHomeLesson = false;
  bool isTutorHomeLesson = false;
  bool allValid = false;
  bool isLoading = false;

  TextEditingController phone = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController degree = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController onlineLessonPrice = TextEditingController();
  TextEditingController studentsHomeLessonPrice = TextEditingController();
  TextEditingController tutorsHomeLessonPrice = TextEditingController();
  TextEditingController bio = TextEditingController();

  List values = [];

  // Functions
  @override
  void initState() {
    userData = widget.userData;
    getUserData();
    setter();
    if (mounted) setState(() {});
    super.initState();
  }

  getUserData() {
    FirestoreHelper.getMyUserData().then((value) {
      userData = value;
      setter();
      if (mounted) setState(() {});
    });
  }

  setter() {
    type = widget.userData.type;
    phone.text = userData.phone.replaceAll('+966', '');
    location.text = userData.location;
    subject.text = userData.majorSubjects;
    degree.text = userData.degree;
    if (userData.degree != '' && userData.degree != null) {
      values = jsonDecode(userData.degree);
    }
    address.text = userData.address;
    isOnlineLesson = userData.isOnlineLesson;
    isStudentHomeLesson = userData.isStudentHomeLesson;
    isTutorHomeLesson = userData.isTutorHomeLesson;
    onlineLessonPrice.text = userData.onlineLessonPrice;
    studentsHomeLessonPrice.text = userData.studentsHomeLessonPrice;
    tutorsHomeLessonPrice.text = userData.tutorsHomeLessonPrice;
    bio.text = userData.bio;
  }

  update() {
    FocusScope.of(context).unfocus();
    checkValidation();

    if (allValid) {
      isLoading = true;
      if (mounted) setState(() {});
      if (!isOnlineLesson) {
        onlineLessonPrice.text = '';
      }
      if (!isStudentHomeLesson) {
        studentsHomeLessonPrice.text = '';
      }
      if (!isTutorHomeLesson) {
        tutorsHomeLessonPrice.text = '';
      }
      var form = {
        'phone': phone.text,
        'location': location.text,
        'majorSubjects': subject.text,
        'degree': degree.text,
        'address': address.text,
        "isOnlineLesson": isOnlineLesson,
        "isStudentHomeLesson": isStudentHomeLesson,
        "isTutorHomeLesson": isTutorHomeLesson,
        "onlineLessonPrice": onlineLessonPrice.text,
        "studentsHomeLessonPrice": studentsHomeLessonPrice.text,
        "tutorsHomeLessonPrice": tutorsHomeLessonPrice.text,
        "bio": bio.text,
      };
      FirestoreHelper.updateUserData(userData.userId, form).then((value) {
        FirestoreHelper.getMyUserData().then((value) {
          isLoading = false;
          if (mounted) setState(() {});
          showToast('تم تحديث الملف الشخصي بنجاح');
          userData = value;
          if (mounted) setState(() {});
        });
      });
    }
  }

  checkValidation() {
    if (phone.text.length > 10) {
      showToast("الهاتف الذي تم إدخاله غير صحيح");
      allValid = false;
    } else if (location.text.isEmpty || oldVal() == null) {
      showToast("المدينة التي تم إدخالها غير صحيحة");
      allValid = false;
    } else if (subject.text.isEmpty && type == 'Tutor') {
      showToast('التخصص المدخل غير صحيح');
      allValid = false;
    } else if (degree.text.isEmpty && type == 'Tutor') {
      showToast('المادة  الذي تم إدخالها غير صحيح');
      allValid = false;
    } else if (address.text.isEmpty && type == 'Tutor') {
      showToast('العنوان / الحي  المدخل غير صحيح');
      allValid = false;
    } else if (((isOnlineLesson && onlineLessonPrice.text.isEmpty) &&
            type == 'Tutor') ||
        ((isStudentHomeLesson && studentsHomeLessonPrice.text.isEmpty) &&
            type == 'Tutor') ||
        ((isTutorHomeLesson && tutorsHomeLessonPrice.text.isEmpty) &&
            type == 'Tutor')) {
      showToast('تأكد من إدخال السعر بشكل صحيح');
      allValid = false;
    } else if ((!isOnlineLesson && type == 'Tutor') &&
        (!isStudentHomeLesson && type == 'Tutor') &&
        (!isTutorHomeLesson && type == 'Tutor')) {
      showToast('تأكد من إدخال السعر بشكل صحيح');
      allValid = false;
    } else if (bio.text.isEmpty && type == 'Tutor') {
      showToast(' المدخل غير صحيح');
      allValid = false;
    } else {
      allValid = true;
    }
    if (mounted) setState(() {});
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: theme.appBackgroundColor,
      textColor: theme.darkTextColor,
      fontSize: screenWidth * 3,
    );
  }

  oldVal() {
    if (citiesList.contains(location.text)) {
      return location.text;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context, userData),
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
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('رقم الجوال'),
                  SizedBox(
                    height: screenWidth * 12.5,
                    width: double.infinity,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {},
                      countries: ["SA"],
                      maxLength: 9,
                      inputBorder: InputBorder.none,
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.DROPDOWN,
                        trailingSpace: false,
                        leadingPadding: 0.0,
                        showFlags: false,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: PhoneNumber(
                        phoneNumber: "XXXXXXXXX",
                        dialCode: "+966",
                        isoCode: "SA",
                      ),
                      textFieldController: phone,
                      formatInput: false,
                      inputDecoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 4,
                            vertical: screenWidth * 3),
                        hintText: 'XXXXXXXXX',
                        hintStyle:
                            textStyle(screenWidth * 3.3, theme.lightTextColor),
                        filled: true,
                        fillColor: Colors.white24,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 200),
                            borderSide: BorderSide(
                                width: .3, color: theme.lightTextColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 200),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.redColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                  (!phone.text.startsWith('5') && phone.text.isNotEmpty)
                      ? Row(children: [
                          text("يجب أن يبدأ الهاتف بالرقم 5", screenWidth * 2.7,
                              theme.redColor)
                        ])
                      : Container(),
                  SizedBox(height: 20),
                  Text('المدينة'),
                  SizedBox(
                    height: screenWidth * 12.5,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      value: oldVal(),
                      items: citiesList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_selectedValue) {
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
                        hintStyle:
                            textStyle(screenWidth * 3.3, theme.lightTextColor),
                        filled: true,
                        fillColor: Colors.white24,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 200),
                            borderSide: BorderSide(
                                width: .3, color: theme.lightTextColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 200),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.yellowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('العنوان / الحي'),
                  SizedBox(
                    height: screenWidth * 12.5,
                    width: double.infinity,
                    child: TextFormField(
                      controller: address,
                      style: textStyle(screenWidth * 3.7, theme.mainColor),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 4,
                            vertical: screenWidth * 3),
                        hintText: 'الياسمين',
                        hintStyle:
                            textStyle(screenWidth * 3.3, theme.lightTextColor),
                        filled: true,
                        fillColor: Colors.white24,
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 200),
                          borderSide: BorderSide(
                              width: .3, color: theme.lightTextColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 200),
                          borderSide: BorderSide(
                            width: .6,
                            color: theme.yellowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Additional only for tutor
                  if (type == 'Tutor')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('التخصص'),
                        SizedBox(
                          height: screenWidth * 12.5,
                          width: double.infinity,
                          child: TextFormField(
                            controller: subject,
                            style:
                                textStyle(screenWidth * 3.7, theme.mainColor),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 4,
                                  vertical: screenWidth * 3),
                              hintText: '',
                              hintStyle: textStyle(
                                  screenWidth * 3.3, theme.lightTextColor),
                              filled: true,
                              fillColor: Colors.white24,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 200),
                                  borderSide: BorderSide(
                                      width: .3, color: theme.lightTextColor)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 200),
                                borderSide: BorderSide(
                                  width: .6,
                                  color: theme.yellowColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('المادة'),
                        Container(
                          width: double.infinity,
                          child: TagEditor(
                            length: values.length,
                            hasAddButton: true,
                            inputDecoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 2,
                              ),
                              hintStyle: textStyle(
                                  screenWidth * 3.3, theme.lightTextColor),
                              hintText: 'إضافة مادة أخرى',
                              filled: true,
                              fillColor: Colors.white24,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 200),
                                borderSide: BorderSide(
                                  width: .3,
                                  color: theme.lightTextColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 200),
                                borderSide: BorderSide(
                                  width: .6,
                                  color: theme.yellowColor,
                                ),
                              ),
                            ),
                            textStyle:
                                textStyle(screenWidth * 3.7, theme.mainColor),
                            onTagChanged: (newValue) {
                              values.add(newValue);
                              degree.text = jsonEncode(values);
                              if (mounted) setState(() {});
                            },
                            tagBuilder: (context, index) => _Chip(
                              index: index,
                              label: values[index],
                              onDeleted: (i) {
                                values.removeAt(i);
                                if (mounted) setState(() {});
                              },
                            ),
                          ),
                        ),
                        text(
                          'انقر فوق + للإضافة المادة',
                          screenWidth * 2.7,
                          kSearchTextColor,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            text(
                              'نوع الدروس',
                              screenWidth * 3,
                              theme.lightTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 35,
                                child: CheckboxListTile(
                                  value: isOnlineLesson,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.all(0),
                                  shape: CircleBorder(),
                                  onChanged: (value) {
                                    isOnlineLesson = value!;
                                    if (mounted) setState(() {});
                                  },
                                  title: Text(
                                    'أون لاين',
                                    style: TextStyle(
                                      fontSize: screenWidth * 3,
                                      color: theme.lightTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              width: 110,
                              child: TextFormField(
                                controller: onlineLessonPrice,
                                style: textStyle(
                                    screenWidth * 3.7, theme.mainColor),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 4,
                                      vertical: screenWidth * 1.5),
                                  hintText: 'ريال/ساعة',
                                  hintStyle: textStyle(
                                      screenWidth * 3.3, theme.lightTextColor),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 200),
                                    borderSide: BorderSide(
                                        width: .3, color: theme.lightTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 200),
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
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 35,
                                child: CheckboxListTile(
                                  value: isStudentHomeLesson,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.all(0),
                                  shape: CircleBorder(),
                                  onChanged: (value) {
                                    isStudentHomeLesson = value!;
                                    if (mounted) setState(() {});
                                  },
                                  title: Text(
                                    'حضوري (مكان الطالب)',
                                    style: TextStyle(
                                      fontSize: screenWidth * 3,
                                      color: theme.lightTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              width: 110,
                              child: TextFormField(
                                controller: studentsHomeLessonPrice,
                                style: textStyle(
                                    screenWidth * 3.7, theme.mainColor),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 4,
                                      vertical: screenWidth * 1.5),
                                  hintText: 'ريال/ساعة',
                                  hintStyle: textStyle(
                                      screenWidth * 3.3, theme.lightTextColor),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 200),
                                    borderSide: BorderSide(
                                        width: .3, color: theme.lightTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 200),
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
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 35,
                                child: CheckboxListTile(
                                  value: isTutorHomeLesson,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.all(0),
                                  shape: CircleBorder(),
                                  onChanged: (value) {
                                    isTutorHomeLesson = value!;
                                    if (mounted) setState(() {});
                                  },
                                  title: Text(
                                    'حضوري (مكان المعلم)',
                                    style: TextStyle(
                                      fontSize: screenWidth * 3,
                                      color: theme.lightTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              width: 110,
                              child: TextFormField(
                                controller: tutorsHomeLessonPrice,
                                style: textStyle(
                                    screenWidth * 3.7, theme.mainColor),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 4,
                                      vertical: screenWidth * 1.5),
                                  hintText: 'ريال/ساعة',
                                  hintStyle: textStyle(
                                      screenWidth * 3.3, theme.lightTextColor),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 200),
                                    borderSide: BorderSide(
                                        width: .3, color: theme.lightTextColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 200),
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
                        SizedBox(height: 20),
                        Text('نبذه عني'),
                        SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: bio,
                            maxLines: 6,
                            style:
                                textStyle(screenWidth * 3.7, theme.mainColor),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 3,
                              ),
                              hintStyle: textStyle(
                                screenWidth * 3.3,
                                theme.lightTextColor,
                              ),
                              filled: true,
                              fillColor: Colors.white24,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 5),
                                borderSide: BorderSide(
                                    width: .3, color: theme.lightTextColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 5),
                                borderSide: BorderSide(
                                  width: .6,
                                  color: theme.yellowColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  SizedBox(height: 40),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.blueColor,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            update();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin:
                                EdgeInsets.symmetric(vertical: screenWidth * 2)
                                    .copyWith(bottom: 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 4,
                                vertical: screenWidth * 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.mainColor),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 50),
                              color: theme.blueColor,
                            ),
                            child: text(
                              'تحديث',
                              screenWidth * 3.9,
                              theme.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final ValueChanged<int> onDeleted;
  final int index;
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: theme.blueColor,
      labelPadding: const EdgeInsets.only(right: 10, top: 6, bottom: 6),
      label: Text(
        label,
        style: TextStyle(color: theme.whiteColor),
      ),
      deleteIcon: Icon(Icons.close, size: 18, color: theme.whiteColor),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
