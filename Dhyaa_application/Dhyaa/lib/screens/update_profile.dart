import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:Dhyaa/globalWidgets/textWidget/text_widget.dart';
import 'package:Dhyaa/provider/firestore.dart';
import 'package:Dhyaa/theme/theme.dart';
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

  bool isPhoneValid = false;
  bool isLocationValid = false;
  bool isSubjectValid = false;
  bool isDegreeValid = false;
  bool allValid = false;

  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController degree = TextEditingController();

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
    // if (userData.phone.startsWith('+966')) {
    //   phone.text = userData.phone.substring(4);
    // } else {
    //   phone.text = userData.phone.replaceAll('+966', 'replace');
    // }
    phone.text = userData.phone.replaceAll('+966', '');

    location.text = userData.location;
    subject.text = userData.majorSubjects;
    degree.text = userData.degree;
  }

  update() {
    checkValidation();
    if (allValid) {
      var form = {
        'phone': phone.text,
        'location': location.text,
        'majorSubjects': subject.text,
        'degree': degree.text,
      };
      FirestoreHelper.updateUserData(userData.userId, form).then((value) {
        showToast('تم تحديث الملف الشخصي بنجاح');
        FirestoreHelper.getMyUserData().then((value) {
          userData = value;
          if (mounted) setState(() {});
        });
      });
    }
  }

  checkValidation() {
    if (phone.text.length > 10) {
      showToast('تم تحديث الملف الشخصي');
      allValid = false;
    } else if (location.text.isEmpty || oldVal() == null) {
      showToast('تم تحديث الملف الشخصي');
      allValid = false;
    } else if (subject.text.isEmpty && type == 'Tutor') {
      showToast("تم تحديث الملف الشخصي");
      allValid = false;
    } else if (degree.text.isEmpty && type == 'Tutor') {
      showToast("تم تحديث الملف الشخصي");
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
    return Scaffold(
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
                    onInputChanged: (PhoneNumber number) {
                      if (phone.text.startsWith('5')) {
                        isPhoneValid = number.phoneNumber!.length > 10;
                      } else {
                        isPhoneValid = false;
                      }
                      if (mounted) setState(() {});
                    },
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
                              color: !isPhoneValid
                                  ? theme.redColor
                                  : theme.yellowColor)),
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
                      isLocationValid = location.text.length > 0;
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
                        borderRadius: BorderRadius.circular(screenWidth * 200),
                        borderSide: BorderSide(
                          width: .6,
                          color: !isLocationValid
                              ? theme.redColor
                              : theme.yellowColor,
                        ),
                      ),
                    ),
                  ),
                ),

                // Additional only for tutor
                if (type == 'Tutor')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text('المادة'),
                      SizedBox(
                        height: screenWidth * 12.5,
                        width: double.infinity,
                        child: TextFormField(
                          controller: subject,
                          onChanged: (value) {
                            isSubjectValid = subject.text.length > 0;
                            if (mounted) setState(() {});
                          },
                          style: textStyle(screenWidth * 3.7, theme.mainColor),
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
                                    color: !isSubjectValid
                                        ? theme.redColor
                                        : theme.yellowColor)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('التخصص'),
                      SizedBox(
                        height: screenWidth * 12.5,
                        width: double.infinity,
                        child: TextFormField(
                          controller: degree,
                          onChanged: (value) {
                            isDegreeValid = degree.text.length > 0;
                            if (mounted) setState(() {});
                          },
                          style: textStyle(screenWidth * 3.7, theme.mainColor),
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
                                    color: !isDegreeValid
                                        ? theme.redColor
                                        : theme.yellowColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    update();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: screenWidth * 2)
                        .copyWith(bottom: 0),
                    padding: EdgeInsets.all(screenWidth * 4.3),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.mainColor),
                      borderRadius: BorderRadius.circular(screenWidth * 50),
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
    );
  }
}
